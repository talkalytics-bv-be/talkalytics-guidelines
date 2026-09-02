# Contributing to Talkalytics repos

Shared conventions across all Talkalytics repositories. Repo-specific
setup steps and notes are appended below this content when this file is
generated — see `CONTRIBUTING.local.md` in that repo, not this file.

## Getting started

- Clone the repo, then run `git submodule update --init --recursive` to
  pull in these shared guidelines.
- See the repo-specific notes below for local setup steps and this repo's
  place in the wider architecture.

## Branching

- Branch names: `{firstname-lastname}/feature/{short-description}` or
  `{firstname-lastname}/fix/{short-description}`
- Example: `ben-claes/feature/tenant-onboarding`
- All lowercase, hyphen-separated, no spaces.

## Commits

- Fully kebab-case, all lowercase, no spaces.
- Example: `fix-cookie-domain-redirect-loop`, `add-tenant-schema-validation`

## Code style

- **Python** — [Ruff](https://docs.astral.sh/ruff/) for linting and
  formatting. Type hints required on public functions.
- **Docker** — multi-stage builds. Never bake secrets into images.
- **Terraform/Terragrunt** — follow the existing resource-group naming
  pattern (`rg-talkalytics-{suffix}-{env}`) and the two-layer
  canonical-JSON + environment-override pattern for tenant config. Any
  schema change must update `_schema.json` in the same PR.

## Secrets & credentials

- Never hardcode secrets, connection strings, or API keys in code, IaC, or
  commit history — pull from Key Vault or GitHub Actions secrets.
- Never commit `.env` files — only `.env.example` with placeholder values.
- Never paste real tenant config values (Cosmos DB keys, Entra client
  secrets, connection strings) into chat, issues, PRs, or commit messages.

## Infra changes

- All infrastructure changes go through Terraform/Terragrunt — no ad hoc
  `az` CLI edits to live resources.
- New tenants follow the existing canonical-JSON + environment-override
  pattern.

## Pull requests

- Requires 1 review before merge.
- CI must pass (lint + tests) before requesting review.
- PR description should note which tenant(s)/environment(s) this affects,
  if relevant.
- Prefer OIDC authentication over publish-profile or long-lived
  credentials for CI/CD where the pipeline supports it.

## CI/CD

- Shared services (`chat-with-db`, `semantic`) deploy to multiple tenant
  Container Apps via a matrix strategy — new services should plug into the
  existing matrix rather than a bespoke pipeline.
- Per-tenant repos (`dbt`, `ingestion`) deploy independently per tenant.
