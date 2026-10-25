---
name: javascript-code-reviewer
description: >-
  Apply the team's JavaScript coding standard when writing or reviewing browser-side JS (vanilla JS and jQuery):
  event handlers, DOM code, fetch calls, jQuery plugins, classes, modules and utility functions. The house
  conventions include single quotes, 4-space indent, `const`/`let` and never `var`, `===` with no `== null`
  exception, at most 5 parameters, one return at the end except guard clauses, `#` private fields, `$`-prefixed
  jQuery variables, `js-` selectors, `async/await`, no swallowed errors, debounced high-frequency handlers and
  sanitized HTML. Also use it to review or audit existing JS against the standard. Trigger even when the user
  doesn't say "coding standard" — any substantive JS writing or review task should follow it.
---

# JavaScript Code Reviewer

This skill applies the team's standard to browser-side JavaScript (vanilla JS and jQuery) that you write or
review. It has two modes: writing new code and reviewing existing code. Some requests need both.

The full rules are in two reference files. They are the source of truth; this file is only a summary.

- `references/core-rules.md` — the core rules (§1–§24), with examples.
- `references/team-rules.md` — the team rules (§25–§32): modern syntax, errors, async, performance, security,
  testing and tooling.

When a core rule and a team rule disagree, the core rule wins. A core rule marked **Retired** no longer applies;
never cite it. When writing, skim the rules that apply. When reviewing, read both files first, so you can cite
each finding by its exact rule.

---

## Mode 1 — Writing JavaScript

Apply the standard as you write, not as a clean-up afterwards. Most of it is normal modern JS. These rules
**differ** from common habits, so watch them closely:

- **Formatting (§6.1, §16.1, §17, §18).** Single quotes, 4-space indent, semicolons, trailing commas on multi-line
  lists only.
- **Declarations (§2).** `const` by default, `let` only when reassigned, never `var`. One declaration per line.
- **Equality (§13.1, §25.2).** Always `===` / `!==`, even for null checks. Use `??` and `?.`.
- **Comparisons (§13.3).** `if (isValid)` for booleans, but `if (name !== '')` and `if (items.length > 0)` for
  strings and numbers.
- **Conversion (§1.4–§1.6).** `String(x)`, `Number(x)`, `parseInt(x, 10)`, `Boolean(x)`. No `+x` or `!!x`.
- **Parameters (§7.1, §7.2, §7.6).** Never change or reassign a parameter. At most 5; more → one object.
- **Returns (§7.11, §7.12).** One return at the end. Early returns only for guard clauses at the top.
- **Arrow functions (§8.1, §8.2, §25.5).** Arrows for callbacks, with no parentheses around a single parameter
  (`item => item.price`). Top-level and exported functions are named `function` declarations.
- **Modules (§10.2–§10.5).** `import`/`export`; a default export when there is only one; no `import *`; self-host
  libraries.
- **Naming (§19).** Booleans start with `is`/`has`/`are`/`can`/`should`. `UPPER_SNAKE_CASE` only for values fixed
  in the code. Private fields use `#` (§25.1), not `_`.
- **DOM (§22).** `$` prefix on jQuery variables, `js-` classes for selecting (never for styling), and cached
  lookups.
- **Loops (§25.3).** Array methods first; `for...of` for sequential `await` or early `break`; never `for...in`.
- **Errors (§26).** Never an empty `catch`. Handle errors at the edges (event handlers, request starters).
- **Async (§27).** `async`/`await`; `Promise.all` for independent calls; no floating promises; check
  `response.ok`.
- **Performance (§28.1).** Debounce or throttle `input`, `keyup`, `scroll`, `resize` and `mousemove` handlers.
- **Security (§6.5, §6.6, §29).** `textContent`/`.text()` for untrusted text; DOMPurify if HTML is needed. No
  `eval`, no secrets in client code, no tokens in `localStorage`.

The common reason behind these rules is **explicit over implicit**: the reader should see what the code does
without guessing.

### Projects without a bundler

If the page loads plain `<script>` tags with no bundler or `type="module"`, `import`/`export` (§10.2) is not
available. Wrap each file in an IIFE (§7.13) or a jQuery ready block, and add a short comment that says why.

---

## Mode 2 — Reviewing JavaScript

Read both reference files first, then check the code in this order, not by spot-checking:

1. **Security (§6.5, §6.6, §7.10, §29).** Unsanitized HTML, `eval`, secrets, tokens in storage, failing open.
2. **Error handling (§1.8, §23.3, §26).** Empty `catch`, thrown strings, errors handled deep inside helpers.
3. **Async (§23, §27).** Floating promises, nested chains, sequential `await`s that could run in parallel.
4. **Correctness (§1.1, §1.2, §2.6, §2.7, §7.1, §7.2, §13).** Changing types, accidental globals, mutated
   parameters, loose equality.
5. **Structure and naming (§3–§12, §19–§22, §25).** Go rule by rule, watching the Mode 1 list most closely.
6. **Performance (§22.4, §28).** Missing debounce, repeated DOM queries, work inside loops.
7. **Formatting (§16–§18).** Report all formatting issues as one grouped finding, and suggest running Prettier
   with the settings in §31.1.

If a problem breaks both a core rule and a team rule, cite both (for example `§6.6 / §29.1`).

### Review output format

Start with a one-line verdict (clean, or N findings). Then list each finding:

```
[§N.N] <short title> — <location, e.g. cart.js:42>
  Problem: <one sentence on what's wrong>
  Fix:
      <minimal corrected snippet>
```

Order the findings by the steps above: security first, formatting last. End with a short note on what already
follows the standard. Don't invent findings: "this is clean" is a valid result.

When the user asks you to *fix* the code, apply the corrections, show the diff or the corrected file, and leave
every other line unchanged.
