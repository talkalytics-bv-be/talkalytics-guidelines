# talkalytics-guidelines

Canonical source for shared repo guidelines across all Talkalytics
repositories: `CONTRIBUTING.md`, `CLAUDE.md`, and `SECURITY.md`.

This repo is not meant to be used standalone — it's added as a git
submodule to every other Talkalytics repo, then combined with each repo's
own `*.local.md` notes to produce the actual root-level files those repos
commit and use.

## Using this repo in a consuming repo

Add it as a submodule:

```bash
git submodule add https://github.com/talkalytics-bv-be/talkalytics-guidelines .guidelines
git submodule update --init --recursive
```

Create repo-specific notes files at that repo's root:

- `CONTRIBUTING.local.md`
- `CLAUDE.local.md`
- `SECURITY.local.md` (optional)

Then generate the real files:

```bash
./.guidelines/scripts/sync-guidelines.sh
```

This produces `CONTRIBUTING.md`, `CLAUDE.md`, and `SECURITY.md` at the repo
root by combining the canonical content here with that repo's local notes,
with a generated header pointing back to both sources. Commit the
generated files — they need to render normally on GitHub.

## Keeping consuming repos in sync

When a guideline changes here:

1. Update the relevant file in this repo and merge.
2. In each consuming repo:
   ```bash
   git submodule update --remote .guidelines
   ./.guidelines/scripts/sync-guidelines.sh
   git add CONTRIBUTING.md CLAUDE.md SECURITY.md .guidelines
   git commit -m "sync-guidelines-update"
   ```

Copy `templates/check-guidelines-sync.yml` into a consuming repo's
`.github/workflows/` to fail CI automatically if the generated files ever
drift from the canonical source (e.g. someone edited a generated file
directly, or forgot to re-sync after a submodule update).

## Enforcement

A guidelines doc only matters if breaking it gets caught. Three layers,
in order of how much they actually block anything:

1. **`.github/workflows/checks.yml`** (in this repo) — the real check
   logic: Ruff (lint + format), secret scanning (gitleaks), branch/commit
   naming, and the guidelines-sync check. Defined once, here.
2. **`templates/workflows/checks-caller.yml`** — copy into each consuming
   repo as `.github/workflows/checks.yml`. It's a thin `uses:` reference
   to (1), so the logic stays single-sourced. One-time setup: this repo's
   Settings → Actions → General → Access must allow use by other repos in
   `talkalytics-bv-be` (private-repo reusable workflows need this).
3. **`templates/pre-commit-config.yaml.example`** — copy into each
   consuming repo as `.pre-commit-config.yaml`. Runs Ruff, gitleaks, and
   the kebab-case commit check locally before a commit is even made.
   Bypassable with `--no-verify`, but genuine friction, and the only
   layer here that doesn't depend on a GitHub plan.

**Important caveat:** GitHub Free for organizations does not enforce
required status checks or required reviews on private repositories. The
CI checks in (1)/(2) run and report pass/fail on every PR, but nothing
currently blocks a merge on a red check — that requires GitHub Pro (per
repo) or GitHub Team (org-wide, via organization rulesets). Nothing needs
to change in these workflows when that happens — just mark them as
required status checks once the org is on a plan that supports it.

## Ruff configuration

**`templates/ruff.toml.example`** — copy into each *Python* repo's root
as `ruff.toml` (or merge into an existing `pyproject.toml`). Without this,
`ruff check`/`ruff format --check` still run but only apply Ruff's default
rule set, which does not include type-hint enforcement — the `ANN` rules
in this template are what actually make "type hints required on public
functions" (from `CONTRIBUTING.md`) a checked rule rather than just text.
Verified against sample code before shipping: a function missing type
hints is correctly flagged (`ANN001`/`ANN201`); properly annotated code
passes clean; `ruff format --check` and import-ordering (`I`) both behave
as expected.

## What lives where

| File | Canonical (this repo) | Consuming repo |
|---|---|---|
| `CONTRIBUTING.md` | source | generated — do not edit |
| `CLAUDE.md` | source | generated — do not edit |
| `SECURITY.md` | source | generated — do not edit |
| `CONTRIBUTING.local.md` | — | hand-written |
| `CLAUDE.local.md` | — | hand-written |
| `README.md` | this file only | fully local, not generated |
| `CODEOWNERS` | — | fully local (GitHub requires it at repo root) |
