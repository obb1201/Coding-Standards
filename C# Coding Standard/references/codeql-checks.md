# GitHub Code Scanning (CodeQL) Checks (§2)

These rules cover alerts from the CodeQL `csharp-security-and-quality` suite. The goal is code that passes the scan without suppressions. Cite each rule in reviews by its rule ID (e.g. `cs/linq/missed-where`).

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
foreach (Asset asset in assets)
{
    if (!asset.IsActive)
    {
        continue;
    }

    Process(asset);
}

// Good
foreach (Asset asset in assets.Where(activeAsset => activeAsset.IsActive))
{
    Process(asset);
}
```

## 2.2 Missed opportunity to use `Select` — `cs/linq/missed-select`

**Triggered by:** a loop that first computes a value from the loop variable and then never uses the loop variable again. The loop is really transforming the items.

**Rule:** express the transformation with LINQ `Select`.

```csharp
// Bad — flagged
List<string> names = new List<string>();
foreach (Employee employee in employees)
{
    string name = employee.FullName;
    names.Add(name);
}

// Good
List<string> names = employees.Select(employee => employee.FullName).ToList();
```

> Note for EF Core: `Select`/`Where` on an `IQueryable` become SQL and run in the database, which is better. Call `ToList()` only after the query is fully built.

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

**Permitted exception:** the query does not flag a generic catch whose only purpose is to **rethrow** (e.g. logging then `throw;`). If a true catch-all is unavoidable at a top-level boundary (global exception handler, background-service loop), catch `Exception`, log it, and dismiss the alert as described in §2.5.

## 2.4 Dereferenced variable may be null — `cs/dereferenced-value-may-be-null`

**Triggered by:** dereferencing a variable (method call, property access, indexer) on a path where it may be `null`. CWE-476; raised as a **warning**, the most serious of the four.

**Rule:** guard the dereference, or prove non-null before the use. Prefer enabling nullable reference types (`<Nullable>enable</Nullable>`) so the compiler surfaces these at build time before CodeQL does.

```csharp
// Bad — flagged
User? user = _repo.Find(id);   // may return null
return Ok(user.Email);         // possible NullReferenceException

// Good — guard and return early (consistent with §1.37)
User? user = _repo.Find(id);
if (user is null)
{
    return NotFound();
}

return Ok(user.Email);
```

Other acceptable patterns: null-conditional with a fallback (`user?.Email ?? string.Empty`), or `ArgumentNullException.ThrowIfNull(user)` at a boundary.

> Known false positives: the analysis mostly checks one method at a time. It can misfire when a separate `HasValue` check guards the value, or when the value is used in a LINQ lambda that runs later. Confirm the code is safe before you dismiss the alert (§2.5).

## 2.5 Suppression policy

Suppress only a verified false positive or a deliberate design decision. Do it by dismissing the alert in GitHub:

1. Open the alert in the repository's **Security → Code scanning** tab.
2. Choose **Dismiss alert** and pick the reason: **False positive** or **Won't fix** (for a deliberate design decision).
3. In the comment, write the justification and the reviewer's initials and date.

Example comment:

> Top-level background loop must not crash the host; logs and continues. Reviewed RT 2026-06-17.

Do not use `[SuppressMessage]` in `GlobalSuppressions.cs` for CodeQL alerts. That attribute is read by .NET analyzers, not by GitHub Code Scanning.
