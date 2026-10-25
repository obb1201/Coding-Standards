# Changelog

Notable changes to this repository, newest first.

## 2026-10-25

- Added `Security Reviewer/`, which replaces the synced `security-reviewer` skill (same name). It now covers C#,
  .NET, JavaScript, SQL Server / Azure SQL, Power Platform, SharePoint Online and Dynamics 365 CE. It can review
  code, exported solutions and design descriptions.
  - `references/owasp-top-10-2025.md` is copied unchanged, so `[A0N]` citations still work.
  - New stack files with stable rule IDs: `CS-n`, `NET-n`, `JS-n`, `SQL-n`, `PP-n`, `SP-n` and `D365-n`.
    Findings are cited as `[A0N][STACK-n]`.
  - First version: each stack rule is one line. Code examples are still to be added.
  - Team decisions: one skill with a file per stack, D365 Customer Engagement only (not F&O), and SQL Server /
    Azure SQL only.

- Added `JavaScript Coding Standard/`, which replaces the `javascript-code-reviewer` skill (same name). The old
  skill's `§1`–`§15` numbers no longer apply, so citations in past reviews will not match.
  - `references/core-rules.md`: the base rules, §1.1–§24.1, rewritten in our own words with new examples.
  - `references/team-rules.md`: team rules §25–§32. They cover modern syntax, errors, async, performance,
    security, testing, ESLint/Prettier settings and general principles. Most come from the old skill.
  - Team decisions: a core rule wins over a team rule. Use 5 parameters at most (§7.6), single quotes (§6.1),
    4-space indent (§16.1), one return at the end except guard clauses (§7.11–§7.12), a default export for
    single-export modules (§10.3), and `item => ...` for single-parameter arrows (§8.2). `can` is added to the
    boolean prefixes (§19.2).
  - Retired core rules (numbers kept): §3.2 reserved-word keys, §11.2 generators, §11.1 → §25.3 (loops),
    §13.2 → §25.2 (no `== null`), §19.6 → §25.1 (`#` private fields). §6.3 was never assigned.
  - Security rules stay in this skill (§29) and match the `security-reviewer` skill. §29.5 (SRI for CDN scripts)
    covers the CDN exception in §10.5.
  - Fixed problems found in the old skill. Its examples used brace-less `if`s that its own ESLint config banned.
    It listed server-side rules (SQL, Zod) in a browser skill, and its export rule contradicted itself.
- Added the JavaScript standard to the `README.md` table and the `CLAUDE.md` layout notes.

- Added `scripts/package-skills.ps1`. It builds an upload-ready zip for each skill folder in `dist/` (ignored by git). Documented the sync steps in `README.md` and `CLAUDE.md`.
- Fixed a typo ("follow it.g") at the end of the `SKILL.md` description.

- Simplified the C# standard's documentation. No rule's meaning changed.
  - `SKILL.md`: rewritten to about half its length. Each override rule is one short bullet with its § number and a short reason. Details such as exception lists and dismissal steps now point to the reference files instead of being repeated. "Read the references" is said once instead of four times. The frontmatter description is shorter.
  - `codeql-checks.md`: plain-English wording for the intro, §2.2 trigger, the EF Core note, and the §2.4 false-positive note.
  - `naming-and-style.md`: shorter wording for §1.16, §1.19, §1.30, §1.37, and §1.43.

- Resolved conflicting and unclear rules in the C# standard (team decisions). Rule numbers did not change.
  - §1.9: private fields are `_` + camelCase (`_age`). The rule text said PascalCase; the example was already right.
  - §1.22: use `Debug.Fail(...)`. Removed the text about a custom assert with a release-build optimization hint.
  - §1.25 / §1.30: one clear order of preference — distinct names, then overloads, then default parameters.
  - §1.35: hand-written singletons are banned; static classes and DI singletons (`AddSingleton`) are allowed. Added examples.
  - §1.40: `OrNull` is required only where nullable reference types are off.
  - §1.43: object initializers are also allowed for DTOs, EF Core entities, options classes, and `required`/`init` types.
  - §2.3–§2.5: CodeQL alerts are suppressed by dismissing them in the GitHub Security tab, not with `GlobalSuppressions.cs`.
  - `SKILL.md`: updated the summary to match all of the above.

- Copied the `csharp-code-reviewer` skill into `C# Coding Standard/`.
- Fixed code examples in the C# standard so they follow its own rules. No rule changed.
  - `codeql-checks.md`: replaced `var` with real types (§1.34), and single-letter lambda names with descriptive ones (§1.11).
  - `codeql-checks.md` §2.4: both return statements now return an action result, so the example compiles.
  - `naming-and-style.md` §1.1, §1.7: replaced C++-style forward declarations with valid C#.
  - `naming-and-style.md` §1.5: example namespace changed from `System.Graphics` to `MyCompany.Graphics`.
  - `naming-and-style.md` §1.14: the "instead of" methods now have bodies, and `SetName` returns `void`.
  - `naming-and-style.md` §1.19: `float f` renamed to `float ratio`.
  - `naming-and-style.md` §1.32: labelled the example as Bad and added a Good example.

- Added a "Working rules" section to `CLAUDE.md`: write in simple English, ask about unclear requirements, and record changes in this file.
- Created this change log.
