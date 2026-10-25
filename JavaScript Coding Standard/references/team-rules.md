# Team Rules (§25 and up)

These rules add to the core rules in `core-rules.md` (§1–§24). Some replace a retired core rule; the rule says
so. Cite them as `§N.N` in reviews (for example `§26.1`). If a team rule disagrees with an active core rule, the
core rule wins; flag the conflict so the standard can be fixed.

## Quick index

| # | Rule |
|---|------|
| 25.1 | `#` private fields, not `_` (replaces §19.6) |
| 25.2 | Null checks use strict equality, `??` and `?.` (replaces §13.2) |
| 25.3 | Prefer array methods; `for...of` where it is clearer; no `for...in` (replaces §11.1) |
| 25.4 | Lookup object or `switch` instead of a long `if`/`else if` chain |
| 25.5 | Named function declarations for top-level and exported functions |
| 25.6 | Keep functions short and focused (about 30 lines) |
| 26.1 | Never swallow an error |
| 26.2 | Handle errors at the edges, not deep inside helpers |
| 26.3 | Custom error classes extend `Error` and set `name` |
| 27.1 | `async`/`await` over `.then()` chains in new code |
| 27.2 | `Promise.all` for independent async work |
| 27.3 | `Promise.allSettled` when some failures are acceptable |
| 27.4 | No floating promises |
| 27.5 | `fetch` over `$.ajax` in new code; check `response.ok` |
| 28.1 | Debounce or throttle high-frequency event handlers |
| 28.2 | Move repeated work out of loops |
| 28.3 | `Set` for membership checks, `Map` for key-value lookups |
| 29.1 | Prefer `textContent`/`.text()`; sanitize HTML with DOMPurify |
| 29.2 | No secrets in client-side code |
| 29.3 | No auth tokens in `localStorage` or `sessionStorage` |
| 29.4 | Client-side checks are for the user; the server must check again |
| 29.5 | Scripts that must load from a CDN use Subresource Integrity (SRI) |
| 29.6 | Fail closed, and show users generic error messages |
| 30.1 | Tests follow Arrange, Act, Assert |
| 30.2 | Test names describe the behavior |
| 30.3 | Test behavior, not implementation details |
| 31.1 | ESLint and Prettier enforce the standard |
| 32.1 | General principles |

## Full rules

### §25 Modern JavaScript

**25.1** Make private class members real private fields with `#`. Don't use a leading `_`. This replaces §19.6.
*Why: `_` is only a convention, and outside code can still read `obj._count`. Reading `#count` from outside the
class is a syntax error.*

```javascript
// Bad
class Counter {
    _count = 0;
}

// Good
class Counter {
    #count = 0;

    increment() {
        this.#count += 1;
    }

    get value() {
        return this.#count;
    }
}
```

**25.2** For null checks, use strict equality (§13.1). Use `??` for a fallback value and `?.` to read through a
value that may be missing. This replaces §13.2. Note that `??` falls back only on `null` and `undefined`, not on
`0` or `''`; `||` falls back on all of them.

```javascript
// Bad
if (user == null) {
    // ...
}

const port = config.port || 3000;
const city = user && user.address && user.address.city;

// Good
if (user === null || user === undefined) {
    // ...
}

const port = config.port ?? 3000;
const city = user?.address?.city;
```

**25.3** To loop over an array, prefer array methods (`map`, `filter`, `find`, `some`, `every`, `reduce`). For
objects, loop over `Object.keys()`, `Object.values()` or `Object.entries()`. `for...of` is allowed when it is
clearer: when you `await` items one at a time, or need to `break` out early. Never use `for...in`. This replaces
§11.1.

```javascript
// Bad
let total = 0;

for (const order of orders) {
    total += order.price;
}

// Good
const total = orders.reduce((sum, order) => sum + order.price, 0);

// Good: each upload must finish before the next one starts
for (const file of files) {
    await uploadFile(file);
}
```

**25.4** Replace a long `if`/`else if` chain that maps values with a lookup object or a `switch`.

```javascript
// Bad
function getStatusText(code) {
    let text = 'Unknown';

    if (code === 200) {
        text = 'OK';
    } else if (code === 404) {
        text = 'Not Found';
    } else if (code === 500) {
        text = 'Server Error';
    }

    return text;
}

// Good
const STATUS_TEXT = {
    200: 'OK',
    404: 'Not Found',
    500: 'Server Error',
};

function getStatusText(code) {
    return STATUS_TEXT[code] ?? 'Unknown';
}
```

**25.5** Write top-level and exported functions as named `function` declarations. Use arrow functions for
callbacks (§8.1). *Why: a named function shows its name in stack traces and tells the reader what the module
does.*

```javascript
// Bad
export const calculateDiscount = (price, percent) => price * (percent / 100);

// Good
export default function calculateDiscount(price, percent) {
    return price * (percent / 100);
}
```

**25.6** Keep each function short and focused on one job. If a function grows past about 30 lines, think about
splitting it.

### §26 Error handling

**26.1** Never swallow an error. A `catch` block must at least log the error. Re-throw it unless the code really
handles it. An empty `catch` is always a finding. *Why: a silent failure shows up later as a different bug that
is hard to trace.*

```javascript
// Bad
try {
    await saveRecord(data);
} catch (error) {
}

// Good
try {
    await saveRecord(data);
} catch (error) {
    logger.error('Failed to save record', { error });
    throw error;
}
```

**26.2** Handle errors at the edges of the system: event handlers, the code that starts a request, and app start
up. Inside helpers, let errors pass up. *Why: one place decides what the user sees and what gets logged.*

```javascript
// Good
$('.js-save-button').on('click', async () => {
    try {
        await saveForm(readForm());
        showMessage('Saved.');
    } catch (error) {
        logger.error('Save failed', { error });
        showMessage('Could not save. Please try again.');
    }
});
```

**26.3** For app-specific errors, write a class that extends `Error` (§1.8) and sets `name`. Add fields that help
the handler decide what to do.

```javascript
// Good
class ApiError extends Error {
    constructor(message, status) {
        super(message);
        this.name = 'ApiError';
        this.status = status;
    }
}
```

### §27 Async code

**27.1** In new code, use `async`/`await`, not `.then()` chains. *Why: the code reads top to bottom, and it works
with `try`/`catch`.* Existing chains must still follow §23.2 and §23.3.

**27.2** When async calls don't depend on each other, run them at the same time with `Promise.all`, not one
`await` after another.

```javascript
// Bad
const users = await fetchUsers();
const orders = await fetchOrders();

// Good
const [users, orders] = await Promise.all([fetchUsers(), fetchOrders()]);
```

**27.3** When some calls may fail and the rest should still go on, use `Promise.allSettled`, then check each
result.

```javascript
// Good
const results = await Promise.allSettled(recipients.map(recipient => sendEmail(recipient)));
const failed = results.filter(result => result.status === 'rejected');
```

**27.4** Never leave a promise floating. Every promise must be awaited, returned, or ended with `.catch()`. An
`async` function that is called without `await`, such as an event handler, must catch its own errors (§26.2).

```javascript
// Bad
saveDraft(form);

// Good
saveDraft(form).catch(error => logger.error('Draft save failed', { error }));
```

**27.5** In new code, use `fetch` with `async`/`await`, not `$.ajax`. `fetch` does not throw on HTTP errors, so
check `response.ok`.

```javascript
// Good
async function fetchUser(userId) {
    const response = await fetch(`/api/users/${userId}`);

    if (!response.ok) {
        throw new ApiError('Failed to load user', response.status);
    }

    const user = await response.json();
    return user;
}
```

### §28 Performance

**28.1** Debounce or throttle handlers for events that fire many times a second: `input`, `keyup`, `scroll`,
`resize` and `mousemove`. This applies to jQuery `.on(...)` handlers too. *Why: without it, every keystroke can
send a request or redraw the page.*

```javascript
// Good
function debounce(callback, delay) {
    let timerId = null;

    return (...args) => {
        clearTimeout(timerId);
        timerId = setTimeout(() => callback(...args), delay);
    };
}

$('.js-search').on('input', debounce(event => searchProducts(event.target.value), 300));
```

**28.2** Move work that gives the same result each time, such as DOM queries and lookups, out of loops (see also
§22.4).

```javascript
// Bad
items.forEach(item => {
    $('.js-list').append(renderItem(item));
});

// Good
const $list = $('.js-list');
$list.append(items.map(renderItem));
```

**28.3** Use a `Set` to check membership and a `Map` for key-value lookups that change at runtime. Don't search
an array over and over.

```javascript
// Bad: searches the whole array once per item
const selectedItems = items.filter(item => selectedIds.includes(item.id));

// Good
const selectedIdSet = new Set(selectedIds);
const selectedItems = items.filter(item => selectedIdSet.has(item.id));
```

### §29 Security

These rules match the `security-reviewer` skill (OWASP Top 10:2025). For a full security review, use that skill
as well.

**29.1** Put untrusted text into the page with `textContent` or jQuery `.text()`. If you really need to insert
HTML, clean it with DOMPurify first. This is how to follow §6.6. *Why: unsanitized HTML lets an attacker run
script in the user's browser (XSS).*

```javascript
// Bad
element.innerHTML = comment.body;
$('.js-comment').html(comment.body);

// Good
element.textContent = comment.body;
$('.js-comment').text(comment.body);

// Good, when HTML is required
element.innerHTML = DOMPurify.sanitize(comment.bodyHtml);
```

**29.2** Never put secrets (API keys, passwords, connection strings) in client-side code. Anyone can read it.
Call your own server, which holds the secret. Use HTTPS URLs for every request.

**29.3** Never store auth tokens in `localStorage` or `sessionStorage`. Any XSS can read them. Let the server set
an `HttpOnly` cookie instead.

**29.4** Validate input in the browser to help the user, but never rely on it. The server must validate the same
data again, and must check that the user is allowed to do the action. Hiding a button is not access control.

**29.5** When a script must load from a CDN (the exception in §10.5), add an `integrity` hash (Subresource
Integrity) and `crossorigin="anonymous"`. Pin an exact version.

```html
<script src="https://cdn.example.com/library-3.7.1.min.js"
        integrity="sha384-..."
        crossorigin="anonymous"></script>
```

**29.6** Fail closed. If a permission check errors, treat it as "not allowed". Show the user a generic message,
and send the details to the log, not to the screen.

```javascript
// Bad
async function canEditRecord(recordId) {
    let canEdit = true;

    try {
        canEdit = await checkPermission(recordId);
    } catch (error) {
        logger.error('Permission check failed', { error });
    }

    return canEdit;
}

// Good
async function canEditRecord(recordId) {
    let canEdit = false;

    try {
        canEdit = await checkPermission(recordId);
    } catch (error) {
        logger.error('Permission check failed', { error });
    }

    return canEdit;
}
```

### §30 Testing

**30.1** Lay out each test as Arrange, Act, Assert, with a blank line between the parts.

**30.2** Name tests so they read like a spec: `'returns 0 when the cart is empty'`, not `'test1'`.

**30.3** Test what the code does (its output and visible effects), not how it does it (private fields, call
order of helpers).

```javascript
// Good
test('returns 0 when the cart is empty', () => {
    const cart = new Cart();

    const total = cart.getTotal();

    expect(total).toBe(0);
});
```

### §31 Tooling

**31.1** Let tools enforce what they can, so reviews can focus on the rest. Use Prettier for formatting and ESLint
for the other rules. Projects should start from these settings.

Prettier (`.prettierrc`):

```json
{
    "semi": true,
    "singleQuote": true,
    "tabWidth": 4,
    "printWidth": 100,
    "trailingComma": "all",
    "arrowParens": "avoid"
}
```

Key ESLint rules (ESLint 9 names):

| ESLint rule | Enforces |
|---|---|
| `no-var`, `prefer-const`, `one-var: ["error", "never"]`, `no-multi-assign`, `no-undef` | §2 |
| `radix`, `no-implicit-coercion`, `no-new-wrappers` | §1.4–§1.6 |
| `no-object-constructor`, `object-shorthand`, `prefer-object-spread` | §3 |
| `no-array-constructor`, `array-callback-return` | §4 |
| `prefer-template`, `no-eval`, `no-implied-eval`, `no-new-func` | §6, §7.10 |
| `no-param-reassign: ["error", { "props": true }]`, `max-params: ["error", 5]`, `prefer-rest-params`, `no-inner-declarations` | §7 |
| `prefer-arrow-callback` | §8.1 |
| `no-dupe-class-members` | §9.5 |
| `import/prefer-default-export`, `import/no-namespace` (eslint-plugin-import) | §10.3, §10.4 |
| `dot-notation` | §12.1 |
| `eqeqeq: ["error", "always"]`, `no-case-declarations`, `no-nested-ternary` | §13 |
| `curly: ["error", "multi-line"]` | §14.1 |
| `camelcase`, `new-cap` | §19 |
| `no-restricted-syntax` on `ForInStatement` | §25.3 |
| `no-empty` (blocks, including `catch`) | §26.1 |
| `@typescript-eslint/no-floating-promises`, or code review where type info is not available | §27.4 |
| `jsdoc/require-param-type`, `jsdoc/require-returns-type` (eslint-plugin-jsdoc) | §15.1 |

ESLint no longer ships its own formatting rules. Prettier covers §16–§18 and §3.7. Two rules it does not cover
are §16.6 and §16.7. Use `@stylistic/newline-per-chained-call` and `@stylistic/padding-line-between-statements`
from `@stylistic/eslint-plugin` for those.

### §32 General principles

**32.1** When no rule covers a case, use these.

| Principle | Meaning |
|---|---|
| Explicit over implicit | Clear, plain code over clever, short code |
| KISS | The simplest solution that works |
| DRY | Put shared logic in one function or module |
| YAGNI | Don't build for needs you don't have yet |
| Fail fast | Check inputs early and stop with a clear error |
| Immutability | Make new objects and arrays instead of changing existing ones |
| Pure functions | Same input gives the same output, with few side effects |
