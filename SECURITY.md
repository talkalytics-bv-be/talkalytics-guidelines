# Security policy

## Reporting a vulnerability

If you discover a security vulnerability in this repository or any
Talkalytics system, report it privately rather than opening a public
issue. Email **[TODO: add security contact email]** with details, and
we'll respond as soon as possible. Do not include real secrets, tokens,
or customer data in the report itself.

## Secrets policy

- Secrets (connection strings, API keys, client secrets) are never stored
  in code or committed to any repository.
- Secrets live in Azure Key Vault (production/tenant secrets) or GitHub
  Actions secrets (CI/CD credentials).
- Key Vault access is restricted via Azure AD groups
  (`azuread-group-key-vault-administrators`).
- Local development uses `.env` files (never committed), populated from
  `.env.example`.

## Access

**[TODO: fill in once there's more than one person with access — who has
access to what, how access is granted and revoked, Entra ID group
structure for SQL/Key Vault admin roles.]**
