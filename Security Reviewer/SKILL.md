---
name: security-reviewer
description: >-
  Review or write secure code and solutions on the team's Microsoft stack, using OWASP Top 10:2025: C#,
  .NET / ASP.NET Core, browser JavaScript/jQuery, SQL Server / Azure SQL (T-SQL), Power Platform (Power Apps,
  Power Automate, Dataverse, Power Pages), SharePoint Online (SPFx, PnP, Graph) and Dynamics 365 Customer
  Engagement (plugins, web resources, security roles). Handles code, exported solutions and design
  descriptions. Triggers include "review this for security", "is this safe?", "check for vulnerabilities",
  "OWASP", auth/session code, SQL queries, HTML from user input, API endpoints, secrets, file uploads,
  error handling, security roles, sharing settings, connectors, DLP policies and flows. Trigger even when
  security isn't mentioned, if the work touches auth, input, data, permissions or errors.
---

# Security Reviewer

This skill applies OWASP Top 10:2025 to every stack the team uses. It has two modes: writing secure code
from the start, and reviewing existing work. Many requests need both.

## Core principle

**Never trust input, and always fail closed.**

- **Never trust input.** Data from outside your own code must be validated, encoded or parameterized before
  use. This includes user input, query strings, headers, deserialized payloads, connector responses, list
  items, and Dataverse fields that users can edit.
- **Always fail closed.** When something fails, deny access and show a generic message. Never allow the
  action and swallow the error.

Everything in the OWASP Top 10 comes back to one or both of these.

## Reference files

Always read `references/owasp-top-10-2025.md`. Then read the stack file for each technology in the work under
review. Read only the files you need.

| Work involves... | Read |
| --- | --- |
| Any review or secure-write task | `owasp-top-10-2025.md` (categories `[A01]`–`[A10]`) |
| C# language code: crypto, deserialization, file and process APIs | `csharp.md` (`CS-n`) |
| ASP.NET Core, Identity, middleware, config, hosting, NuGet | `dotnet.md` (`NET-n`) |
| Browser JavaScript, jQuery, D365 web resources, SPFx front end | `javascript.md` (`JS-n`) |
| T-SQL, stored procedures, database permissions, Azure SQL settings | `sql.md` (`SQL-n`) |
| Power Apps, Power Automate, Dataverse, Power Pages, environments, DLP | `power-platform.md` (`PP-n`) |
| SharePoint Online sites, permissions, SPFx, PnP, Graph | `sharepoint.md` (`SP-n`) |
| Dynamics 365 CE: security roles, plugins, web resources, Web API | `dynamics-365.md` (`D365-n`) |

Some files overlap on purpose. A D365 plugin is C#, so read `dynamics-365.md` and `csharp.md`. A D365 web
resource is JavaScript, so read `dynamics-365.md` and `javascript.md`. A platform file holds only what is
specific to that platform.

Rule IDs never change. If a rule becomes outdated, mark it **Retired** and keep its number.

## What you may be given

| Input | How to review it |
| --- | --- |
| Code (C#, JS/TS, T-SQL, Power Fx, flow JSON, PnP PowerShell) | Check each line against the rules and give exact locations. |
| Exported solution (solution zip, `customizations.xml`, role XML, flow definitions) | Check settings and permissions: roles, connection references, environment variables, sharing. |
| Design description (notes, diagrams, screenshots, admin settings) | Do a design review. Report risks and open questions. You cannot see the code, so do not claim line-level findings. |

## Mode 1: Writing secure work

Apply the matching stack file while you write, not afterwards. Defaults for every stack:

- Check authorization on the server for the specific record. Hiding UI is not access control.
- Parameterize every query: EF Core LINQ, `SqlParameter`, `sp_executesql` with parameters, and FetchXML
  conditions built with proper encoding.
- Keep secrets in Key Vault, Dataverse secret environment variables or app settings. Never put them in code,
  flows, web resources or list items.
- Grant the least privilege: the narrowest security role, Graph scope, SQL permission or connector.
- Log security events. Never log secrets or personal data.

## Mode 2: Security review

1. Identify the stacks and the input type (code, solution or design).
2. Read the reference files listed above.
3. Check the work against each relevant OWASP category and stack rule.
4. Report findings in the format below, most severe first.

### Severity tiers

| Tier | Examples | Action |
| --- | --- | --- |
| **Critical** | Injection, auth bypass, remote code execution, XSS that steals sessions, data shared with everyone or anonymous users | Fix before merge or deploy |
| **High** | Missing record-level check (IDOR), hardcoded secret, failing open, over-privileged role or app registration | Fix before merge or deploy |
| **Medium** | Missing rate limit, weak session settings, verbose errors, missing DLP policy | Fix before release |
| **Low** | Missing header, unpinned dependency, gap in audit logging | Fix in the next sprint |

### Output format

Start with a one-line verdict (clean, or N findings). Then list findings, Critical first:

```
[A0N][STACK-n] <short title> — <location, e.g. AuthController.cs:42 or "Flow: Approve invoice">
  Severity: Critical / High / Medium / Low
  Problem: <what is wrong and what an attacker could do>
  Why: <the principle behind it>
  Fix: <minimal corrected snippet or setting>
```

Leave out `[STACK-n]` when only an OWASP category applies. End with a short note on what is already secure.
"No findings" is a valid result.

When asked to **fix** rather than flag, change only what the vulnerability needs and leave other lines alone.

### False positives

Before you flag something:

- Confirm the input really comes from an untrusted source and not from an internal enum or fixed config.
- Check whether a control upstream (middleware, a plugin, a DLP policy, a parent site's permissions) already
  covers it.
- For design input, phrase uncertain items as questions:
  `Possible [A01][PP-3]: confirm the flow's connection runs as the user, not the maker.`
