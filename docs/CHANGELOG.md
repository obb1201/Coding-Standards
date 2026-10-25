# Changelog

Notable changes to this repository, newest first.

## 2026-10-25

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
