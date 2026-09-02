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
- Avoid duplication. Before adding code, search for an existing helper,
  function, or module that already does the job and reuse it. If the
  same logic would appear in more than one place, extract it into a
  shared, well-named unit. Prefer small, composable, single-purpose
  modules over copy-paste or large catch-all files.
- Keep a critical mindset and dare to push back. Don't agree by default
  or implement a request you believe is wrong. Question assumptions,
  point out flaws, edge cases, and simpler alternatives, and say so
  plainly when a proposed approach is a mistake. Flag risks and
  trade-offs instead of quietly working around them. Being helpful
  means being honest, not agreeable.

## When unsure

- Check for precedent in a sibling repo before inventing a new pattern.
- If a repo-specific gotcha isn't covered here, check `CLAUDE.local.md`
  in this repo.
