## Using this repo in a consuming repo

**Recommended: run `templates/bootstrap-repo.sh`** (see "Rolling out to
an existing repo" below) — it does everything in this section for you in
one step, plus the CI caller workflow, `ruff.toml`, and the pre-commit
config. Use it unless you specifically want to do each step by hand.

Manual steps, if you're not using the script (this is what the script
does internally):

​```bash
cd /path/to/new-repo

# 1. Add the submodule properly
git submodule add https://github.com/talkalytics-bv-be/talkalytics-guidelines .guidelines
git submodule update --init --recursive

# 2. Repo-specific notes (fill these in after)
cp .guidelines/templates/CONTRIBUTING.local.md.example CONTRIBUTING.local.md
cp .guidelines/templates/CLAUDE.local.md.example CLAUDE.local.md

# 3. CI workflows
mkdir -p .github/workflows
cp .guidelines/templates/workflows/checks-caller.yml .github/workflows/checks.yml
cp .guidelines/templates/workflows/guidelines-auto-update.yml .github/workflows/guidelines-auto-update.yml

# 4. Python-only: Ruff config + pre-commit with Ruff
cp .guidelines/templates/ruff.toml.example ruff.toml
cp .guidelines/templates/pre-commit-config.yaml.example .pre-commit-config.yaml
# Non-Python repos: use this instead of the line above
# cp .guidelines/templates/pre-commit-config-non-python.yaml.example .pre-commit-config.yaml

# 5. Generate CONTRIBUTING.md / CLAUDE.md / SECURITY.md
./.guidelines/scripts/sync-guidelines.sh

# 6. Commit
git add .
git commit -m "add-shared-guidelines-and-checks"
git push

# 7. Local pre-commit hooks (once per clone, not per repo)
pre-commit install
pre-commit install --hook-type commit-msg
​```

Create repo-specific notes files at that repo's root:

- `CONTRIBUTING.local.md`
- `CLAUDE.local.md`
- `SECURITY.local.md` (optional)

Then generate the real files:

​```bash
./.guidelines/scripts/sync-guidelines.sh
​```

This produces `CONTRIBUTING.md`, `CLAUDE.md`, and `SECURITY.md` at the repo
root by combining the canonical content here with that repo's local notes,
with a generated header pointing back to both sources. Commit the
generated files — they need to render normally on GitHub.