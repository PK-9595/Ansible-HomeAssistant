#!/usr/bin/env bash
set -u

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
NOTES_DIR="$ROOT_DIR/docs/codebase-notes"
README="$NOTES_DIR/README.md"
FAILED=0

fail() {
  printf 'FAIL: %s\n' "$1"
  FAILED=1
}

pass() {
  printf 'PASS: %s\n' "$1"
}

required_files=(
  "AGENTS.md"
  "docs/codebase-notes/README.md"
  "docs/codebase-notes/_template.md"
  "docs/codebase-notes/check-notes.ps1"
  "docs/codebase-notes/check-notes.sh"
  "docs/codebase-notes/00-system-overview.md"
  "docs/codebase-notes/01-architecture.md"
  "docs/codebase-notes/02-key-flows.md"
  "docs/codebase-notes/03-data-and-storage.md"
  "docs/codebase-notes/04-apis-and-integrations.md"
  "docs/codebase-notes/05-deployment-and-config.md"
  "docs/codebase-notes/06-known-risks.md"
  "docs/codebase-notes/adr/README.md"
)

for file in "${required_files[@]}"; do
  if [[ -f "$ROOT_DIR/$file" ]]; then
    pass "Required file exists: $file"
  else
    fail "Required file missing: $file"
  fi
done

if [[ -e "$NOTES_DIR/AGENTS.md" ]]; then
  fail "docs/codebase-notes/AGENTS.md must not exist"
else
  pass "No docs/codebase-notes/AGENTS.md"
fi

while IFS= read -r -d '' note; do
  rel="${note#$ROOT_DIR/}"
  if grep -q 'Last verified against codebase:' "$note"; then
    pass "Last verified marker present: $rel"
  else
    fail "Last verified marker missing: $rel"
  fi
done < <(find "$NOTES_DIR" -type f -name '*.md' -print0)

if [[ -f "$README" ]]; then
  while IFS= read -r -d '' note; do
    rel="${note#$NOTES_DIR/}"
    [[ "$rel" == "README.md" ]] && continue
    if grep -Fq "$rel" "$README"; then
      pass "README mentions note: $rel"
    else
      fail "README does not mention note: $rel"
    fi
  done < <(find "$NOTES_DIR" -type f -name '*.md' -print0)
fi

KEY_FLOWS="$NOTES_DIR/02-key-flows.md"
if [[ -f "$KEY_FLOWS" ]]; then
  key_flow_lines="$(wc -l < "$KEY_FLOWS" | tr -d ' ')"
  if [[ "$key_flow_lines" -lt 100 ]]; then
    pass "02-key-flows.md is under 100 lines"
  else
    fail "02-key-flows.md must stay under 100 lines"
  fi
fi

while IFS= read -r -d '' note; do
  rel="${note#$ROOT_DIR/}"
  if grep -En '(^|[[:space:]`(])([[:alnum:]_.\/-]+\.[[:alnum:]_-]+):[0-9]+\b|(^|[[:space:]])line[[:space:]]+[0-9]+\b' "$note" >/dev/null; then
    fail "Possible exact line-number reference found: $rel"
  else
    pass "No exact line-number references: $rel"
  fi
done < <(find "$NOTES_DIR" -type f -name '*.md' -print0)

while IFS= read -r -d '' note; do
  rel="${note#$NOTES_DIR/}"
  case "$rel" in
    README.md|_template.md|00-system-overview.md|01-architecture.md|02-key-flows.md|03-data-and-storage.md|04-apis-and-integrations.md|05-deployment-and-config.md|06-known-risks.md|adr/README.md)
      continue
      ;;
  esac

  if [[ "$rel" == *flow*.md || "$rel" == flows/* ]]; then
    content_lines="$(grep -Ev '^\s*$|^\s*#|Last verified against codebase:' "$note" | wc -l | tr -d ' ')"
    if [[ "$content_lines" -lt 3 ]]; then
      fail "Domain-specific flow file appears to be a placeholder: $rel"
    else
      pass "Domain-specific flow file has content: $rel"
    fi
  fi
done < <(find "$NOTES_DIR" -type f -name '*.md' -print0)

if [[ "$FAILED" -eq 0 ]]; then
  printf 'Docs notes validation passed.\n'
  exit 0
fi

printf 'Docs notes validation failed.\n'
exit 1
