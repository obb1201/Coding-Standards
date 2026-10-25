---
name: csharp-code-reviewer
description: >-
  Apply the team's C# coding standard when writing or reviewing C#: classes, services, controllers, EF Core code,
  DTOs. The house conventions differ from .NET defaults (Allman braces, `b`-prefixed booleans, `E`-prefixed enums,
  `ALL_CAPS` constants, no `var`, member ordering, exceptions only at the boundary). Also use it to review or audit
  C# against the standard, and to fix or prevent GitHub Code Scanning (CodeQL) alerts such as
  `cs/linq/missed-where`, `cs/linq/missed-select`, `cs/catch-of-all-exceptions`, and
  `cs/dereferenced-value-may-be-null`. Trigger even when the user doesn't say "coding standard" — any substantive
  C# writing or review task should follow it.g
---

# C# Code Reviewer

This skill applies the team's standard to C# you write or review. It has two modes: writing new code and
reviewing existing code. Some requests need both.

The full rules are in two reference files. They are the source of truth; this file is only a summary.

- `references/naming-and-style.md` — the naming and style rules (§1), with examples.
- `references/codeql-checks.md` — the CodeQL Code Scanning rules (§2) and the suppression policy (§2.5).

When writing, skim the rules that apply. When reviewing, read both files first, so you can cite each finding by
its exact rule.

---

## Mode 1 — Writing C#

Apply the standard as you write, not as a clean-up afterwards. Most of it matches normal good C#. These rules
**override** common .NET habits, so watch them closely:

- **Allman braces (§1.17, §1.18).** `{` always on its own line, and braces even on one-line `if`s.
  *Why: brace-less one-liners cause subtle bugs, and Allman keeps diffs clean.*
- **Booleans (§1.6).** Variables and fields get a `b` prefix (`bFired`, `_bFired`). Properties read as a yes/no
  question: `IsActive`, `HasErrors`, `CanEdit`, `ShouldRetry`. *Why: you can see it's a boolean without
  looking up the declaration.*
- **Prefixes (§1.7, §1.8, §1.29).** `I` for interfaces, `E` for enums (`EDirection`), and a `Flags` suffix on bitflag
  enums (`EVisibilityFlags`). *Why: the symbol's kind is visible at the call site.*
- **Constants (§1.4).** `ALL_CAPS_WITH_UNDERSCORES`: `const int MAX_RETRIES = 3;`.
- **Private members (§1.9).** `_` then camelCase: `_age`, `_bFired`.
- **No `var` (§1.34).** Write `Employee employee = ...`. *Why: the reader sees the type without checking the
  method signature.*
- **Acronyms (§1.12, §1.13).** Two letters: all caps (`ID`). Three or more: first letter only (`HttpAddress`).
- **Member order (§1.24).** Fields and properties first, then methods. Within each group: public, internal,
  protected, private.
- **Overloads (§1.25, §1.30, §1.31).** Distinct names first (`GetAnimByIndex` / `GetAnimByName`), then overloads,
  then default parameters. *Why: similar overloads are easy to call wrongly.*
- **Object initializers (§1.43).** Avoid them on classes that validate in the constructor; use the constructor with
  named parameters. See §1.43 for the allowed exceptions.
- **Singletons (§1.35).** No hand-written singletons. Use a static class or a DI singleton (`AddSingleton`).
- **Async (§1.36).** `async Task`, never `async void`, except event handlers. *Why: `async void` exceptions can't be
  caught and crash the process.*
- **Exceptions (§1.37, §1.38).** Validate external data at the boundary and return early. Inside, assume data is
  valid and don't throw. *Why: one place handles each kind of problem.*
- **Null (§1.39–§1.42).** Avoid null parameters and return values, especially in public methods. Mark parameters
  that may be null (§1.40) and document null returns in `<returns>`.
- **Switches (§1.20–§1.22).** Always a `default`, `//fallthrough` on intended fall-through, and `Debug.Fail(...)` in a
  default that should never run. *Why: unexpected values fail loudly instead of silently.*
- **Names and files (§1.23, §1.27).** Recursive methods end in `Recursive`. The filename matches the class name.

The common reason behind these rules is **readability and predictability over cleverness**.

### CodeQL-clean by construction

Write code that passes the scan without suppressions (details in §2):

- Loop that skips items with `if`/`continue` → `.Where(...)` (§2.1, `cs/linq/missed-where`).
- Loop that only maps items into a new list → `.Select(...)` (§2.2, `cs/linq/missed-select`).
- `catch { }` or `catch (Exception)` → catch specific types (§2.3, `cs/catch-of-all-exceptions`).
- Value that may be null → guard it before use (§2.4, `cs/dereferenced-value-may-be-null`). Enable
  `<Nullable>enable</Nullable>`.

For EF Core, put `Where`/`Select` on the `IQueryable` so they run as SQL, and call `ToList()` last.

---

## Mode 2 — Reviewing C#

Read both reference files first, then check the code step by step, not by spot-checking:

1. **CodeQL (§2) first.** These break the pipeline. Check each rule's trigger pattern.
2. **Style and naming (§1).** Go rule by rule. Watch the override rules from Mode 1 most closely.
3. **Cite both rules when two apply.** A generic `catch` breaks `cs/catch-of-all-exceptions` and §1.38. An
   unguarded null breaks `cs/dereferenced-value-may-be-null` and §1.37.

### Review output format

Start with a one-line verdict (clean, or N findings). Then list each finding:

```
[<rule-id or §1.N>] <short title> — <location, e.g. OrderService.cs:42>
  Problem: <one sentence on what's wrong>
  Fix:
      <minimal corrected snippet>
```

Order by severity: CodeQL warnings, then CodeQL recommendations, then style. If a finding looks like a CodeQL false
positive, say so and point to §2.5 instead of rewriting the code.

End with a short note on what already follows the standard. Don't invent findings: "this is clean" is a valid
result.

When the user asks you to *fix* the code, apply the corrections, show the diff or the corrected file, and leave
every other line unchanged.
