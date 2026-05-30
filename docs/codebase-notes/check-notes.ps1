$ErrorActionPreference = "Stop"

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$RootDir = (Resolve-Path (Join-Path $ScriptDir "../..")).Path
$NotesDir = Join-Path $RootDir "docs/codebase-notes"
$Readme = Join-Path $NotesDir "README.md"
$Failed = $false

function Get-RelativePathCompat($BasePath, $TargetPath) {
    $BaseFull = [System.IO.Path]::GetFullPath($BasePath).TrimEnd(
        [System.IO.Path]::DirectorySeparatorChar,
        [System.IO.Path]::AltDirectorySeparatorChar
    ) + [System.IO.Path]::DirectorySeparatorChar
    $TargetFull = [System.IO.Path]::GetFullPath($TargetPath)
    $BaseUri = New-Object System.Uri($BaseFull)
    $TargetUri = New-Object System.Uri($TargetFull)
    $RelativeUri = $BaseUri.MakeRelativeUri($TargetUri).ToString()
    return [System.Uri]::UnescapeDataString($RelativeUri).Replace("/", [System.IO.Path]::DirectorySeparatorChar)
}

function Fail($Message) {
    Write-Host "FAIL: $Message"
    $script:Failed = $true
}

function Pass($Message) {
    Write-Host "PASS: $Message"
}

$RequiredFiles = @(
    "AGENTS.md",
    "docs/codebase-notes/README.md",
    "docs/codebase-notes/_template.md",
    "docs/codebase-notes/check-notes.ps1",
    "docs/codebase-notes/check-notes.sh",
    "docs/codebase-notes/00-system-overview.md",
    "docs/codebase-notes/01-architecture.md",
    "docs/codebase-notes/02-key-flows.md",
    "docs/codebase-notes/03-data-and-storage.md",
    "docs/codebase-notes/04-apis-and-integrations.md",
    "docs/codebase-notes/05-deployment-and-config.md",
    "docs/codebase-notes/06-known-risks.md",
    "docs/codebase-notes/adr/README.md"
)

foreach ($File in $RequiredFiles) {
    $Path = Join-Path $RootDir $File
    if (Test-Path -LiteralPath $Path -PathType Leaf) {
        Pass "Required file exists: $File"
    } else {
        Fail "Required file missing: $File"
    }
}

$NestedAgents = Join-Path $NotesDir "AGENTS.md"
if (Test-Path -LiteralPath $NestedAgents) {
    Fail "docs/codebase-notes/AGENTS.md must not exist"
} else {
    Pass "No docs/codebase-notes/AGENTS.md"
}

$MarkdownNotes = Get-ChildItem -LiteralPath $NotesDir -Recurse -File -Filter "*.md"

foreach ($Note in $MarkdownNotes) {
    $Rel = Get-RelativePathCompat $RootDir $Note.FullName
    $Text = Get-Content -LiteralPath $Note.FullName -Raw
    if ($Text -match "Last verified against codebase:") {
        Pass "Last verified marker present: $Rel"
    } else {
        Fail "Last verified marker missing: $Rel"
    }
}

if (Test-Path -LiteralPath $Readme -PathType Leaf) {
    $ReadmeText = Get-Content -LiteralPath $Readme -Raw
    foreach ($Note in $MarkdownNotes) {
        $RelToNotes = (Get-RelativePathCompat $NotesDir $Note.FullName).Replace("\", "/")
        if ($RelToNotes -eq "README.md") {
            continue
        }

        if ($ReadmeText.Contains($RelToNotes)) {
            Pass "README mentions note: $RelToNotes"
        } else {
            Fail "README does not mention note: $RelToNotes"
        }
    }
}

$KeyFlows = Join-Path $NotesDir "02-key-flows.md"
if (Test-Path -LiteralPath $KeyFlows -PathType Leaf) {
    $LineCount = (Get-Content -LiteralPath $KeyFlows).Count
    if ($LineCount -lt 100) {
        Pass "02-key-flows.md is under 100 lines"
    } else {
        Fail "02-key-flows.md must stay under 100 lines"
    }
}

$LineReferencePattern = '(^|[\s`(])([\w.\/-]+\.[\w-]+):[0-9]+\b|(^|\s)line\s+[0-9]+\b'
foreach ($Note in $MarkdownNotes) {
    $Rel = Get-RelativePathCompat $RootDir $Note.FullName
    $Text = Get-Content -LiteralPath $Note.FullName -Raw
    if ($Text -match $LineReferencePattern) {
        Fail "Possible exact line-number reference found: $Rel"
    } else {
        Pass "No exact line-number references: $Rel"
    }
}

$CoreNotes = @(
    "README.md",
    "_template.md",
    "00-system-overview.md",
    "01-architecture.md",
    "02-key-flows.md",
    "03-data-and-storage.md",
    "04-apis-and-integrations.md",
    "05-deployment-and-config.md",
    "06-known-risks.md",
    "adr/README.md"
)

foreach ($Note in $MarkdownNotes) {
    $RelToNotes = (Get-RelativePathCompat $NotesDir $Note.FullName).Replace("\", "/")
    if ($CoreNotes -contains $RelToNotes) {
        continue
    }

    if ($RelToNotes -like "*flow*.md" -or $RelToNotes -like "flows/*") {
        $UsefulLines = Get-Content -LiteralPath $Note.FullName |
            Where-Object { $_ -notmatch '^\s*$' -and $_ -notmatch '^\s*#' -and $_ -notmatch 'Last verified against codebase:' }

        if ($UsefulLines.Count -lt 3) {
            Fail "Domain-specific flow file appears to be a placeholder: $RelToNotes"
        } else {
            Pass "Domain-specific flow file has content: $RelToNotes"
        }
    }
}

if ($Failed) {
    Write-Host "Docs notes validation failed."
    exit 1
}

Write-Host "Docs notes validation passed."
exit 0
