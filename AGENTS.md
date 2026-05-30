# Agent Instructions

Before non-trivial repository work, read `docs/codebase-notes/README.md` and the notes most relevant to the task.

The codebase is the source of truth. Use the notes as a navigation aid, then verify important assumptions against the actual files before changing behavior or documentation. If notes and code disagree, trust the code and correct the notes.

When new confirmed repository knowledge is discovered, update `docs/codebase-notes/`. Prefer correcting existing notes over creating redundant notes. Put new information in the most relevant note instead of dumping unrelated facts into one file. Do not delete `docs/codebase-notes/`.

After changing notes or this file, run the docs validator for the environment you are in:

- Windows or PowerShell available: `powershell -ExecutionPolicy Bypass -File docs/codebase-notes/check-notes.ps1`
- PowerShell Core available: `pwsh -ExecutionPolicy Bypass -File docs/codebase-notes/check-notes.ps1`
- Linux/macOS shell: `bash docs/codebase-notes/check-notes.sh`

If more than one validator can run in the current environment, run each available equivalent.

Include this section in every final response:

```text
Docs Updated:
- list files updated, or
- None -- no new confirmed knowledge discovered
```
