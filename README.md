## Using this repo in a consuming repo

**Recommended: run `templates/bootstrap-repo.sh`** (see "Rolling out to
an existing repo" below) — it does everything in this section for you in
one step, plus the CI caller workflow, `ruff.toml`, and the pre-commit
config. Use it unless you specifically want to do each step by hand.

Manual steps, if you're not using the script (this is what the script
does internally):

​```bash
git submodule add https://github.com/talkalytics-bv-be/talkalytics-guidelines .guidelines
git submodule update --init --recursive
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