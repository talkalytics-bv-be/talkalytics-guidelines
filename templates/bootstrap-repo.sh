#!/usr/bin/env bash
set -euo pipefail

# bootstrap-repo.sh
#
# Run from the ROOT of a repo that does NOT yet have the shared
# Talkalytics guidelines set up. Adds the .guidelines submodule, copies
# the local-notes templates, wires up the CI caller workflow, and (with
# --python) the Ruff config + Python-flavored pre-commit config.
#
# Usage (run from inside the target repo):
#   /path/to/bootstrap-repo.sh              # non-Python repo (e.g. dbt)
#   /path/to/bootstrap-repo.sh --python      # Python repo (e.g. chat-with-db, semantic)
#
# Safe to re-run: every step is skipped if its output already exists.

GUIDELINES_REPO_URL="${GUIDELINES_REPO_URL:-https://github.com/talkalytics-bv-be/talkalytics-guidelines}"
PYTHON_REPO=false

if [[ "${1:-}" == "--python" ]]; then
  PYTHON_REPO=true
fi

if [ ! -d .git ]; then
  echo "Error: run this from the root of a git repo (no .git found here)."
  exit 1
fi

if [ -d .guidelines ]; then
  echo ".guidelines already exists here — skipping submodule add."
else
  echo "==> Adding .guidelines submodule"
  git submodule add "$GUIDELINES_REPO_URL" .guidelines
fi
git submodule update --init --recursive

echo "==> Copying local-notes templates (only if missing)"
[ -f CONTRIBUTING.local.md ] || cp .guidelines/templates/CONTRIBUTING.local.md.example CONTRIBUTING.local.md
[ -f CLAUDE.local.md ] || cp .guidelines/templates/CLAUDE.local.md.example CLAUDE.local.md

echo "==> Wiring up CI caller workflow"
mkdir -p .github/workflows
[ -f .github/workflows/checks.yml ] || cp .guidelines/templates/workflows/checks-caller.yml .github/workflows/checks.yml

echo "==> Wiring up guidelines auto-update workflow"
[ -f .github/workflows/guidelines-auto-update.yml ] || cp .guidelines/templates/workflows/guidelines-auto-update.yml .github/workflows/guidelines-auto-update.yml

if [ "$PYTHON_REPO" = true ]; then
  echo "==> Python repo: adding ruff.toml (skipped if ruff.toml or pyproject.toml already exists)"
  if [ ! -f ruff.toml ] && [ ! -f pyproject.toml ]; then
    cp .guidelines/templates/ruff.toml.example ruff.toml
  fi
  echo "==> Adding pre-commit config (with Ruff)"
  [ -f .pre-commit-config.yaml ] || cp .guidelines/templates/pre-commit-config.yaml.example .pre-commit-config.yaml
else
  echo "==> Non-Python repo: adding pre-commit config (SQLFluff + gitleaks, no Ruff hook)"
  [ -f .pre-commit-config.yaml ] || cp .guidelines/templates/pre-commit-config-non-python.yaml.example .pre-commit-config.yaml
  echo "==> Adding .sqlfluff config (skipped if one already exists)"
  [ -f .sqlfluff ] || cp .guidelines/templates/sqlfluff-config.example .sqlfluff
fi

echo "==> Generating CONTRIBUTING.md / CLAUDE.md / SECURITY.md"
./.guidelines/scripts/sync-guidelines.sh

cat <<NEXT

Done. Next steps:
  1. Fill in CONTRIBUTING.local.md and CLAUDE.local.md with this repo's specifics.
  2. Review the generated CONTRIBUTING.md / CLAUDE.md / SECURITY.md.
  3. git add . && git commit -m "add-shared-guidelines-and-checks" && git push
  4. pre-commit install && pre-commit install --hook-type commit-msg
  5. Confirm the CI checks appear on the next PR (visible, not yet blocking
     on GitHub Free — see README.md's Enforcement section).
NEXT