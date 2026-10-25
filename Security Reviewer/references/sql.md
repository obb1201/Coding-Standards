# SQL Server / Azure SQL Security Rules (`SQL-n`)

T-SQL code, database design and server settings for SQL Server and Azure SQL. Cite a rule as `[A0N][SQL-n]`.
Calling SQL from C# is covered by `CS-1` and `[A05]` in `owasp-top-10-2025.md`.

## Rules

### Queries and code
- **SQL-1** `[A05]` In dynamic SQL, pass values as parameters to `sp_executesql`. Never concatenate them.
- **SQL-2** `[A05]` Wrap object names in dynamic SQL with `QUOTENAME`, and check them against a list of
  allowed names.
- **SQL-3** `[A01]` Do not use `EXECUTE AS OWNER` or ownership chaining to skip permission checks without a
  documented reason.
- **SQL-4** `[A02]` Turn off `xp_cmdshell`, OLE Automation and CLR unless they are needed and documented.

### Permissions
- **SQL-5** `[A01]` Apps connect with their own least-privilege user. They never use `sa`, `db_owner` or a
  shared admin login.
- **SQL-6** `[A01]` Grant `EXECUTE` on stored procedures or schemas. Avoid direct table rights when an app
  only needs procedures.
- **SQL-7** `[A07]` Prefer Microsoft Entra authentication and managed identities over SQL logins and
  passwords.
- **SQL-8** `[A01]` Use row-level security when rows belong to different tenants or users.

### Data protection
- **SQL-9** `[A04]` Keep TDE on. Use Always Encrypted for highly sensitive columns. Connections use
  `Encrypt=True` and do not set `TrustServerCertificate=True`.
- **SQL-10** `[A04]` Mask sensitive columns for users who do not need them (dynamic data masking). Masking
  is not encryption.
- **SQL-11** `[A04]` Backups are encrypted and stored with restricted access.

### Network and monitoring
- **SQL-12** `[A02]` Azure SQL uses private endpoints or tight firewall rules. Never allow `0.0.0.0` to
  `255.255.255.255`.
- **SQL-13** `[A09]` Turn on auditing and Microsoft Defender for SQL. Review alerts.
