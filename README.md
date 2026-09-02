## Using this repo in a consuming repo

**Recommended: run `templates/bootstrap-repo.sh`** (see "Rolling out to
an existing repo" below) — it does everything in this section for you in
one step, plus the CI caller workflow, `ruff.toml`, and the pre-commit
config. Use it unless you specifically want to do each step by hand.

Manual steps, if you're not using the script (this is what the script
does internally):

​```bash

cd /path/to/talkalytics-codebase

# Download straight to the parent directory — never lands inside the repo this time
curl -o ../bootstrap-repo.sh https://raw.githubusercontent.com/talkalytics-bv-be/talkalytics-guidelines/production/templates/bootstrap-repo.sh
chmod +x ../bootstrap-repo.sh

# Run it against this repo — no --python, this is dbt
../bootstrap-repo.sh

# Fill these in with this repo's specifics before committing
open CONTRIBUTING.local.md CLAUDE.local.md   # or edit however you prefer

# Quick look at what got generated
cat CONTRIBUTING.md

# Commit
git add .
git commit -m "add-shared-guidelines-and-checks"
git push

# Local pre-commit hooks (once per clone, not per repo)
pre-commit install
pre-commit install --hook-type commit-msg

# Clean up the script now that it's done its job
rm ../bootstrap-repo.sh

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