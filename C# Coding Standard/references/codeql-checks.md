# GitHub Code Scanning (CodeQL) Checks (§2)

These rules address CodeQL alerts raised by the `csharp-security-and-quality` query suite. The goal is to write code that passes the scan cleanly rather than relying on suppressions. Each subsection lists the CodeQL rule ID so a finding can be traced back to the standard. Cite them in reviews by rule ID (e.g. `cs/linq/missed-where`).

## Quick index

| Rule ID | Short name | Severity |
|---------|-----------|----------|
| `cs/linq/missed-where` | Loop filter should be LINQ `Where` | recommendation |
| `cs/linq/missed-select` | Loop transform should be LINQ `Select` | recommendation |
| `cs/catch-of-all-exceptions` | Generic catch clause (CWE-396) | recommendation |
| `cs/dereferenced-value-may-be-null` | Possible null dereference (CWE-476) | **warning** |

## 2.1 Missed opportunity to use `Where` — `cs/linq/missed-where`

**Triggered by:** a loop that filters its sequence by skipping iterations — either `if (!condition) continue;` at the top of the body, or wrapping the whole body in `if (condition) { ... }`.

**Rule:** express the filter with LINQ `Where` instead of an in-loop guard.

```csharp
// Bad — flagged
foreach (var asset in assets)
{
    if (!asset.IsActive)
    {
        continue;
    }

    Process(asset);
}

// Good
foreach (var asset in assets.Where(a => a.IsActive))
{
    Process(asset);
}
```

## 2.2 Missed opportunity to use `Select` — `cs/linq/missed-select`

**Triggered by:** a loop whose first action computes a value from the iteration variable, after which the iteration variable itself is never used again. The intent is a transformation, not iteration over the original sequence.

**Rule:** express the transformation with LINQ `Select`.

```csharp
// Bad — flagged
var names = new List<string>();
foreach (var employee in employees)
{
    var name = employee.FullName;
    names.Add(name);
}

// Good
var names = employees.Select(e => e.FullName).ToList();
```

> Note for EF Core: applying `Select`/`Where` to an `IQueryable` translates to SQL and runs server-side, which is preferable. Be deliberate about when you call `ToList()` — materialize only after the query is fully composed.

## 2.3 Generic catch clause — `cs/catch-of-all-exceptions`

**Triggered by:** a bare `catch { }` or `catch (Exception)` without a filter. CWE-396. A broad catch hides unrelated failures and makes diagnosis harder.

**Rule:** catch the specific exception type(s) you can actually handle. This aligns with §1.38 — exceptions are handled at the boundary, and even there the catch should be specific.

```csharp
// Bad — flagged
try
{
    return ParseAndStore(input);
}
catch
{
    return 0;
}

// Good
try
{
    return ParseAndStore(input);
}
catch (FormatException ex)
{
    _logger.LogWarning(ex, "Invalid input format");
    return 0;
}
catch (DbUpdateException ex)
{
    _logger.LogError(ex, "Persist failed");
    throw;
}
```

**Permitted exception:** the query does not flag a generic catch whose only purpose is to **rethrow** (e.g. logging then `throw;`). If a true catch-all is unavoidable at a top-level boundary (global exception handler, background-service loop), catch `Exception`, log it, and document the justification in `GlobalSuppressions.cs`.

## 2.4 Dereferenced variable may be null — `cs/dereferenced-value-may-be-null`

**Triggered by:** dereferencing a variable (method call, property access, indexer) on a path where it may be `null`. CWE-476; raised as a **warning**, the most serious of the four.

**Rule:** guard the dereference, or prove non-null before the use. Prefer enabling nullable reference types (`<Nullable>enable</Nullable>`) so the compiler surfaces these at build time before CodeQL does.

```csharp
// Bad — flagged
var user = _repo.Find(id);   // may return null
return user.Email;            // possible NullReferenceException

// Good — guard and return early (consistent with §1.37)
var user = _repo.Find(id);
if (user is null)
{
    return NotFound();
}

return user.Email;
```

Other acceptable patterns: null-conditional with a fallback (`user?.Email ?? string.Empty`), or `ArgumentNullException.ThrowIfNull(user)` at a boundary.

> Known false positives: the analysis is largely intra-procedural and can misfire when a value is guarded by a separate `HasValue` check or captured in a LINQ lambda with deferred execution. Confirm it is genuinely safe before suppressing — only then record it in `GlobalSuppressions.cs` with the rule ID, reason, and reviewer initials.

## 2.5 Suppression policy

Suppress only a verified false positive or a deliberate design decision. Use a justified `SuppressMessage` in `GlobalSuppressions.cs`:

```csharp
[assembly: SuppressMessage(
    "CodeQL", "cs/catch-of-all-exceptions",
    Justification = "Top-level background loop must not crash the host; logs and continues. Reviewed RT 2026-06-17.",
    Scope = "member",
    Target = "~M:MyApp.Workers.NotificationWorker.ExecuteAsync(System.Threading.CancellationToken)")]
```
