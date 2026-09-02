# AI assistant guardrails

This repo follows the conventions in `CONTRIBUTING.md` — read that first.
This file adds rules specific to AI coding assistants (Claude Code and
similar) working in Talkalytics repos.

## Hard rules

- Never hardcode or invent secrets, connection strings, or API keys. If
  one is missing or required, stop and flag it — do not fabricate a
  placeholder that looks like a real value.
- Never run destructive Azure CLI commands (delete, overwrite prod
  config) or apply Terraform changes to live infrastructure without
  explicit confirmation from a human.
- Always confirm which tenant and environment you're operating in before
  making a change that could cross tenant boundaries.
- All infra changes go through Terraform/Terragrunt — never make ad hoc
  `az` CLI changes to live resources, even "temporarily."
- Match existing patterns in sibling repos (`chat-with-db`, `semantic`,
  per-tenant `dbt`/`ingestion`) rather than introducing a new convention
  unprompted.
- Follow the branch and commit naming conventions in `CONTRIBUTING.md`
  exactly — lowercase, hyphenated, no spaces.
- Run Ruff (lint + format) before considering a Python task done.

## When unsure

- Check for precedent in a sibling repo before inventing a new pattern.
- If a repo-specific gotcha isn't covered here, check `CLAUDE.local.md`
  in this repo.
