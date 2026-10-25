---
name: csharp-code-reviewer
description: >-
  Apply the team's C# coding standard when writing or reviewing C#.
  Use this whenever generating new C# — classes, methods, services, controllers, EF Core code, DTOs — so the
  output follows the house conventions, which deliberately diverge from idiomatic .NET defaults (Allman braces,
  `b`-prefixed boolean variables, `E`-prefixed enums, `ALL_CAPS` constants, `var` avoidance, member ordering,
  boundary-only exception handling). Also use it when reviewing, auditing, or code-reviewing existing C#, when
  asked to check code against the coding standard, or when fixing / preventing GitHub Code Scanning (CodeQL)
  alerts such as `cs/linq/missed-where`, `cs/linq/missed-select`, `cs/catch-of-all-exceptions`, and
  `cs/dereferenced-value-may-be-null` so the CI/CD pipeline scan stays clean. Trigger even when the user doesn't
  say "coding standard" explicitly — any substantive C# authoring or review task should follow it.
---

# C# Code Reviewer

This skill makes C# you write or review conform to the team's standard. It has two modes. Figure out which one
the request is — authoring new code, or evaluating existing code — and follow that path. Many requests are both
(e.g. "write this service, following our standard" then later "review it").

The full rules live in two reference files. Read them as described below rather than working from memory of this
summary alone — the wording and rule IDs matter, especially when you report a finding the user will act on.

- `references/naming-and-style.md` — the 43 naming/style rules (§1), with examples.
- `references/codeql-checks.md` — the four CodeQL Code Scanning rules (§2) and the suppression policy.

---

## Mode 1 — Writing C#

When you generate C#, apply the standard as you write. Don't produce idiomatic-default C# and
then fix it up; write it correctly the first time.

Most of the standard agrees with ordinary good C#. What needs deliberate attention is the set of conventions that
**override** what you'd otherwise reach for by habit. Internalize these:

- **Allman braces (§1.17, §1.18).** Opening `{` goes on its own line, always — including single-statement `if`,
  which still gets braces. No K&R, no brace-less one-liners. *Why: brace-less single-liners are the source of
  a whole class of subtle bugs (Apple's goto-fail, for example). Allman style also makes diff output cleaner —
  the brace line never merges with a content change.*

- **Boolean naming (§1.6).** Local/field booleans are `b`-prefixed (`bFired`, private field `_bFired`). Boolean
  *properties* instead read as a yes/no question: `Is*` / `Has*` / `Can*` / `Should*` (`IsActive`, `HasErrors`,
  `CanEdit`). Use `Has`, not `Have`. *Why: a reader scanning a method can immediately tell `bFired` is a boolean
  without inspecting its declaration. The property prefixes make conditions read like English: `if (user.IsActive)`
  is unambiguous; `if (user.Active)` could be a status string.*

- **`E`-prefixed enums (§1.8)**, and bitflag enums additionally suffixed `Flags` (§1.29): `EDirection`,
  `EVisibilityFlags`. `I`-prefixed interfaces (§1.7) is the familiar one. *Why: enums and interfaces appear
  frequently in parameter types and switch cases. The prefix makes the symbol's kind visible at the call site
  without hovering for IntelliSense.*

- **`ALL_CAPS_WITH_UNDERSCORES` constants (§1.4)** — not PascalCase. `const int MAX_RETRIES = 3;` *Why:
  distinguishes a compile-time fixed value from a readonly field or property at a glance. Magic numbers become
  obviously named constants.*

- **Private members `_`-prefixed (§1.9).** The rule says PascalCase the rest of the name, though its own example
  shows `private int _age;` — follow the surrounding file's existing casing and check §1.9 if it matters.
  *Why: the `_` prefix signals "internal state — don't touch from outside" without needing to read the access
  modifier, which speeds up comprehension when scanning a class body.*

- **Prefer the real type over `var` (§1.34).** `var` is acceptable only where the type is noise, e.g. an
  enumerator. Write `Employee employee = ...`, not `var employee = ...`. *Why: explicit types are
  self-documenting. A reader seeing `Employee employee = repo.Find(id)` knows the return type immediately;
  `var employee = repo.Find(id)` requires them to check the method signature — an extra cognitive step that
  compounds across a large codebase.*

- **Acronym casing (§1.12, §1.13).** Exactly 2 chars → all caps (`ID`). 3+ chars → first only (`HttpAddress`).
  *Why: consistency across the codebase. Without a rule, you get `ID`/`Id`/`id` and `HTTP`/`Http`/`http`
  mixed through the same project.*

- **Member ordering (§1.24).** Fields/properties first (public → internal → protected → private), then methods in
  the same visibility order. *Why: a predictable layout means you always know where to look. Public surface
  is at the top — the contract a caller cares about — implementation details are at the bottom.*

- **Avoid overloads (§1.25) and object initializers (§1.43).** Prefer distinct descriptive names
  (`GetAnimByIndex` / `GetAnimByName`) and explicit constructors with named parameters. Prefer overloading over
  default parameters (§1.30); when defaults are used, only immutable constants (§1.31). *Why: overloads with
  similar signatures are easy to call incorrectly and hard to read at the call site. Object initializers bypass
  the constructor, which means validation logic there is silently skipped.*

- **`async Task`, never `async void` (§1.36)** — except event handlers. *Why: `async void` methods can't be
  awaited, so exceptions they throw are unobservable and will crash the process. `async Task` lets callers
  await and catch.*

- **Exceptions at the boundary only (§1.37, §1.38).** Validate external data at the entry point and return early;
  inside the codebase assume data is valid and **don't throw**. *Why: exceptions as control flow inside a
  system are expensive and make reasoning about code paths difficult. Catching at the boundary means one place
  handles one class of problem, not exception handlers scattered through the call stack.*

- **Null discipline (§1.39–§1.42).** Avoid null params/returns, especially on public surfaces. A param that may
  be null is postfixed `OrNull`. A method that may return null says so in its `<returns>` doc. *Why: null is
  the most common source of runtime exceptions in .NET. Making nullability explicit in names and docs forces
  the caller to acknowledge it rather than assuming a value is always present.*

- **Switches (§1.20–§1.22).** Always a `default`. `//fallthrough` on intentional fall-through. `Debug.Fail(...)`
  in a default that should be unreachable. *Why: a switch without a default silently does nothing on an
  unexpected value. Making every code path explicit — including the impossible ones — turns silent bugs into
  loud failures that surface in development.*

- **Recursive methods end in `Recursive` (§1.23).** Filename matches the class name exactly (§1.27). *Why:
  recursion is non-obvious from a call site. The suffix warns the reader that stack depth is a concern and
  that the function calls itself. Filename matching the class name makes navigation predictable — no guessing.*

The rationale across most of these is the standard's first principle: **readability and predictability over
cleverness.** The prefixes and ordering let a reader infer a symbol's kind and scope without chasing its
declaration; the brace and switch rules remove ambiguity about control flow. When a rule trades away a modern
convenience (like `var` or object initializers), it's buying that predictability.

If you're writing anything non-trivial, open `references/naming-and-style.md` and skim the relevant rules rather
than trusting this summary — it's a condensation, not the source of truth.

### CodeQL-clean by construction

While writing, also avoid the four patterns the Code Scanning suite flags (full detail in
`references/codeql-checks.md`). The aim is code that passes the scan with no suppressions:

- Filtering a loop with `if (!cond) continue;` or a body-wrapping `if` → use `.Where(...)` (`cs/linq/missed-where`).
  *Why: the filter intent is buried inside the loop body. `.Where()` makes it visible at the sequence level,
  and on `IQueryable` it translates to a SQL `WHERE` clause instead of fetching all rows first.*
- A loop that just maps each item into a new collection → use `.Select(...)` (`cs/linq/missed-select`).
  *Why: same principle — the transformation intent is explicit, and on `IQueryable` it becomes a SQL projection.*
- `catch { }` or `catch (Exception)` without a filter → catch specific types (`cs/catch-of-all-exceptions`).
  A log-and-`throw;` rethrow is allowed. *Why: a broad catch silently absorbs exceptions you didn't anticipate —
  `OutOfMemoryException`, `ThreadAbortException` — making bugs impossible to diagnose. Specific catches document
  exactly which failures you're handling and why.*
- Dereferencing a possibly-null value → guard and return early, or use `?.`/`??`/`ThrowIfNull`
  (`cs/dereferenced-value-may-be-null`, a warning — the most serious). Prefer `<Nullable>enable</Nullable>` so the
  compiler catches these before CodeQL does. *Why: null dereference is CWE-476, one of the most common causes of
  runtime crashes. Enabling nullable reference types moves this from a runtime surprise to a compile-time error.*

For EF Core, push `Where`/`Select` onto `IQueryable` so they translate to SQL, and call `ToList()` only after the
query is fully composed.

---

## Mode 2 — Reviewing C#

When you audit existing C#, **read both reference files first** (`naming-and-style.md` and `codeql-checks.md`), then
walk the code against them. The reference text is what lets you cite a finding precisely, which is the whole point of
a review — the author needs to know *which* rule and *how* to fix it.

Work through the code systematically rather than spot-checking:

1. **CodeQL / Code Scanning first (§2).** These are what break the pipeline, so lead with them. For each of the four
   rules, scan for its trigger pattern. The null-dereference rule is a warning (most serious); the other three are
   recommendations.
2. **Style and naming (§1).** Go rule by rule, or section by section. Pay special attention to the override
   conventions listed in Mode 1, since those are the ones most likely to be wrong in code written to ordinary .NET
   habits.
3. **Note the reinforcing pairs.** A generic `catch` violates both `cs/catch-of-all-exceptions` and §1.38; an
   unguarded deref violates both `cs/dereferenced-value-may-be-null` and §1.37. Cite both when they apply — it shows
   the finding isn't just a linter nit.

### Review output format

Lead with a one-line verdict (clean / N findings). Then list findings, **CodeQL findings first**, each as:

```
[<rule-id or §1.N>] <short title> — <location, e.g. OrderService.cs:42>
  Problem: <one sentence on what's wrong>
  Fix:
      <minimal corrected snippet>
```

Group or order by severity: CodeQL warnings, then CodeQL recommendations, then style violations. If a finding is a
likely CodeQL false positive, say so and point to the suppression policy (§2.5) rather than reflexively rewriting —
suppression is for *verified* false positives or deliberate design decisions, recorded in `GlobalSuppressions.cs`
with rule ID, justification, and reviewer initials.

Close by naming what's already compliant, briefly — it tells the author the review was thorough, not just a list of
complaints. Don't invent violations to pad the list; "this is clean" is a valid and valuable result.

When the user asks you to *fix* rather than just flag, apply the corrections and show the diff or the corrected
file, keeping every other line untouched.
