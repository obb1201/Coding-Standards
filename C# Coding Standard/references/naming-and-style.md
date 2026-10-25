# Naming Conventions and Style (§1)

Rules are numbered to match the source standard. Cite them as `§1.N` in reviews.

## Quick index

| # | Rule |
|---|------|
| 1.1 | PascalCase for classes and structs |
| 1.2 | camelCase for locals and parameters |
| 1.3 | Verb-object pairs for method names |
| 1.4 | `ALL_CAPS_WITH_UNDERSCORES` for constants |
| 1.5 | PascalCase for namespaces |
| 1.6 | `b`-prefix boolean variables; `Is`/`Has`/`Can`/`Should` boolean properties |
| 1.7 | `I`-prefix interfaces |
| 1.8 | `E`-prefix enums |
| 1.9 | `_`-prefix private members; camelCase the rest of the name (`_age`) |
| 1.10 | Methods returning a value are named after the value |
| 1.11 | Descriptive variable names (not `i`/`e` except trivial loop indices) |
| 1.12 | Acronyms of exactly 2 chars: all caps (`ID`) |
| 1.13 | Acronyms of 3+ chars: first char only (`HttpAddress`) |
| 1.14 | Prefer properties over get/set methods |
| 1.15 | Real tabs equal to 4 spaces |
| 1.16 | Declare locals as close as possible to first use |
| 1.17 | Opening brace `{` always on a new line (Allman) |
| 1.18 | Braces even for single-line scopes |
| 1.19 | Precision specifier on floats (`0.5F`) unless double is needed |
| 1.20 | Always a `default` case in a switch |
| 1.21 | `//fallthrough` comment on intentional fall-through |
| 1.22 | `Debug.Fail(...)` in a default that must not happen |
| 1.23 | Recursive methods end in `Recursive` |
| 1.24 | Member ordering: members (public→private), then methods (public→private) |
| 1.25 | Prefer distinct descriptive names over overloading |
| 1.26 | One class per file (small related classes may group) |
| 1.27 | Filename matches class name, including case |
| 1.28 | Use `Debug.Assert` for assertions (non-recoverable) |
| 1.29 | Bitflag enums suffixed `Flags` |
| 1.30 | When distinct names don't fit, prefer overloading over default parameters |
| 1.31 | Default parameters restricted to immutable constants (`null`/`false`/`0`) |
| 1.32 | No shadowed variables |
| 1.33 | Prefer `System.Collections.Generic` over `System.Collections` |
| 1.34 | Prefer real type over `var` (Enumerator is acceptable) |
| 1.35 | No hand-written singletons; use a static class or a DI singleton |
| 1.36 | `async Task`, not `async void` (except event handlers) |
| 1.37 | Validate external data at the boundary, return early |
| 1.38 | Don't throw from internal functions — handle at the boundary |
| 1.39 | Avoid null parameters, especially in public functions |
| 1.40 | `OrNull` postfix on a parameter that may be null (only where nullable reference types are off) |
| 1.41 | Avoid returning null, especially from public functions |
| 1.42 | If null may be returned, document it in `<returns>` |
| 1.43 | Avoid object initializers on classes with constructor validation; prefer explicit ctor with named params |

## Full rules

**1.1** Use Pascal casing for class and structs.

```csharp
class SomeClass
{
}

struct SomeStruct
{
}
```

**1.2** Use camel casing for local variable names and function parameters.

```csharp
void SomeMethod(int someParameter)
{
    int someNumber;
}
```

**1.3** Use verb-object pairs for method names.

**1.4** Use `ALL_CAPS_SEPARATED_BY_UNDERSCORE` for constants.

```csharp
const int SOME_CONSTANT = 1;
```

**1.5** Use Pascal casing for namespaces.

```csharp
namespace MyCompany.Graphics
```

**1.6** Prefix boolean variables with `b`. Prefix boolean properties with `Is`, `Has`, `Can`, or `Should`, whichever reads correctly as a yes/no question about the object:

- `Is` — state or identity: `IsFired`, `IsActive`, `IsValid`
- `Has` — possession or presence: `HasErrors`, `HasChildren`
- `Can` — capability or permission: `CanEdit`, `CanExecute`
- `Should` — recommendation or expected behavior: `ShouldRetry`, `ShouldSerialize`

Use `Has` rather than `Have` — a property is a singular subject ("the order *has* items" → `HasItems`).

```csharp
bool bFired;                        // for local variable
bool _bFired;                       // for private class member variable
bool IsFired { get; private set; }
bool HasErrors { get; private set; }
bool CanEdit { get; private set; }
```

**1.7** Prefix interfaces with `I`.

```csharp
interface ISomeInterface
{
}
```

**1.8** Prefix enums with `E`.

```csharp
public enum EDirection
{
    North,
    South
}
```

**1.9** Prefix private member variables with `_`. Use camel casing for the rest of a member variable (`_age`, `_bFired`).

```csharp
public class Employee
{
    public int DepartmentID { get; set; }
    private int _age;
}
```

**1.10** Methods with return values must have a name describing the value returned.

```csharp
uint GetAge();
```

**1.11** Use descriptive variable names, e.g. `index` or `employee` instead of `i` or `e` unless it is a trivial index variable used for loops.

**1.12** Capitalize every character in acronyms if they have only 2 characters.

```csharp
public int ID { get; private set; }
```

**1.13** Capitalize only the first character in acronyms if they have more than 2 characters.

```csharp
public string HttpAddress { get; private set; }
```

**1.14** Prefer properties over getter/setter functions.

Use:

```csharp
public class Employee
{
    public string Name { get; set; }
}
```

Instead of:

```csharp
public class Employee
{
    private string _name;

    public string GetName()
    {
        return _name;
    }

    public void SetName(string name)
    {
        _name = name;
    }
}
```

**1.15** Use real tabs that are equal to 4 spaces.

**1.16** Declare each local variable as close as possible to its first use.

**1.17** Always place an opening curly brace (`{`) on a new line.

**1.18** Add curly braces even if there's only one line in the scope.

```csharp
if (bSomething)
{
    return;
}
```

**1.19** Add a precision suffix to floating-point literals (`0.5F`) unless you need a double.

```csharp
float ratio = 0.5F;
```

**1.20** Always have a default case for a switch statement.

```csharp
switch (number)
{
    case 0:
        ...
        break;
    default:
        break;
}
```

**1.21** Always add `//fallthrough` comment for switch case fall through.

```csharp
switch (number)
{
    case 0:
        ...
        //fallthrough
    case 1:
        ...
        break;
    default:
        break;
}
```

**1.22** If default case must not happen in a switch case, always add `Debug.Fail(...)` with a short message. It stops in debug builds and does nothing in release builds.

```csharp
switch (type)
{
    case 1:
        ...
        break;
    default:
        Debug.Fail("unknown type");
        break;
}
```

**1.23** Names of recursive functions end with "Recursive".

```csharp
void FibonacciRecursive();
```

**1.24** Order of class members and methods must be as follows:

1. public members
2. internal members
3. protected members
4. private members
5. public methods
6. internal methods
7. protected methods
8. private methods

**1.25** Function overloading must be avoided in most cases. Give each method a distinct, descriptive name. Use this order of preference: distinct names first, then overloads (§1.30), then default parameters (§1.31).

Use:

```csharp
Anim GetAnimByIndex(int index);
Anim GetAnimByName(string name);
```

Instead of:

```csharp
Anim GetAnim(int index);
Anim GetAnim(string name);
```

**1.26** Each class must be in a separate source file unless it makes sense to group several smaller classes.

**1.27** The filename must be the same as the name of the class including upper and lower cases.

```csharp
class Anim {}
```

`Anim.cs`

**1.28** Use assert for any assertion you have. Assert is not recoverable. (e.g. most functions will have `Debug.Assert(not null parameters)`)

**1.29** The name of a bitflag enum must be suffixed by `Flags`.

```csharp
public enum EVisibilityFlags
{
}
```

**1.30** Prefer overloading over default parameters. (Distinct names come first; see the order in §1.25.)

**1.31** When default parameters are used, restrict them to natural immutable constants such as `null`, `false`, or `0`.

**1.32** Shadowed variables are not allowed.

Bad — the parameter `Count` hides the property `Count`, so inside `Func` you cannot tell which one `Count` means:

```csharp
public class SomeClass
{
    public int Count { get; set; }

    public void Func(int Count)
    {
        for (int count = 0; count != 10; ++count)
        {
            // Use Count
        }
    }
}
```

Good — every name is different, so `Count` always means the property:

```csharp
public class SomeClass
{
    public int Count { get; set; }

    public void Func(int maxCount)
    {
        for (int index = 0; index != maxCount; ++index)
        {
            // Use Count
        }
    }
}
```

**1.33** Always use containers from `System.Collections.Generic` over ones from `System.Collections`. Using a pure array is fine as well.

**1.34** Prefer to use real type over `var`. Acceptable `var` usage includes Enumerator.

**1.35** Do not write the singleton pattern by hand (a private constructor plus a static `Instance` property). Use a static class for stateless helpers. For a service that needs one shared instance, register it with dependency injection (`services.AddSingleton<IClock, SystemClock>()`) so it can be injected and replaced in tests.

Use:

```csharp
public static class MathHelper
{
    public static int Clamp(int value, int min, int max)
    {
        return Math.Min(Math.Max(value, min), max);
    }
}

builder.Services.AddSingleton<IClock, SystemClock>();
```

Instead of:

```csharp
public class Clock
{
    private static readonly Clock _instance = new Clock();

    private Clock()
    {
    }

    public static Clock Instance
    {
        get { return _instance; }
    }
}
```

**1.36** Use `async Task` instead of `async void`. The only place `async void` is allowed is for event handlers.

**1.37** Validate external data at the boundary and return early if it is invalid. After that point, assume all data is valid.

**1.38** Therefore, do not throw any exception from inside our function. This should be handled at the boundary only.

**1.39** Prefer not to allow null parameters in your function, especially from a public one.

**1.40** If a null parameter is used, postfix the parameter name with `OrNull`. This applies only to projects where nullable reference types are not enabled. When `<Nullable>enable</Nullable>` is on, the `?` in the type already says this, so write `string? name` instead of `string nameOrNull`.

**1.41** Prefer not to return null from any function, especially from a public one. However, you sometimes need to do this to avoid throwing exceptions.

**1.42** If null is returned from any function, specify that at the beginning of the function.

```csharp
/// <returns>null if something, otherwise ...</returns>
```

**1.43** Try not to use object initializers. Use an explicit constructor with named parameters instead, because an initializer skips any validation in the constructor. Exceptions:

1. When the object is created at one place only. (e.g. one-time DTO)
2. When the object is created inside a static method of the owning class. (e.g. factory pattern)
3. Data-only types with no constructor validation: DTOs, EF Core entities, and options classes bound from configuration.
4. Types that use `required` or `init` properties, because the compiler already checks that required values are set.
