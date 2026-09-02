#!/usr/bin/env bash
set -euo pipefail

# sync-guidelines.sh
#
# Regenerates CONTRIBUTING.md, CLAUDE.md, and SECURITY.md at the repo root
# by combining the canonical content in the .guidelines submodule with
# this repo's own *.local.md notes files.
#
# Usage (run from the consuming repo's root):
#   ./.guidelines/scripts/sync-guidelines.sh          regenerate files in place
#   ./.guidelines/scripts/sync-guidelines.sh --check  verify files are up to date (CI)

GUIDELINES_DIR=".guidelines"
FILES=("CONTRIBUTING" "CLAUDE" "SECURITY")
CHECK_MODE=false

if [[ "${1:-}" == "--check" ]]; then
  CHECK_MODE=true
fi

if [ ! -d "$GUIDELINES_DIR" ]; then
  echo "Error: $GUIDELINES_DIR not found. Run: git submodule update --init --recursive"
  exit 1
fi

STATUS=0

for name in "${FILES[@]}"; do
  canonical="$GUIDELINES_DIR/$name.md"
  local_notes="$name.local.md"
  output="$name.md"

  if [ ! -f "$canonical" ]; then
    echo "Skipping $name.md — no canonical source at $canonical"
    continue
  fi

  generated=$(
    {
      echo "<!-- GENERATED FILE — do not edit directly."
      echo "     Canonical source: $canonical"
      if [ -f "$local_notes" ]; then
        echo "     Repo-specific notes: $local_notes"
      fi
      echo "     Regenerate with: ./.guidelines/scripts/sync-guidelines.sh -->"
      echo ""
      cat "$canonical"
      if [ -f "$local_notes" ]; then
        echo ""
        echo "---"
        echo ""
        cat "$local_notes"
      fi
    }
  )

  if [ "$CHECK_MODE" = true ]; then
    if [ ! -f "$output" ] || [ "$generated" != "$(cat "$output")" ]; then
      echo "OUT OF SYNC: $output does not match canonical source. Run sync-guidelines.sh to fix."
      STATUS=1
    else
      echo "OK: $output is up to date"
    fi
  else
    printf '%s\n' "$generated" > "$output"
    echo "Generated $output"
  fi
done

exit $STATUS
