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
