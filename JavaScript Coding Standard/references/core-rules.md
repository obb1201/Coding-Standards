# Core Rules (§1–§24)

These are the base rules of the team's JavaScript standard. Cite them as `§N.N` in reviews (for example
`§7.6`). When a core rule and a team rule disagree, the core rule wins, unless the core rule is marked
**Retired**. The team rules are in `team-rules.md` (§25 and up).

A **Retired** rule keeps its number so old citations still make sense, but it no longer applies. Do not cite
it in a review. Each retired rule names the rule that replaces it, if there is one.

All examples follow the standard: 4-space indent, single quotes, semicolons, and trailing commas on
multi-line lists.

## Quick index

| # | Rule |
|---|------|
| 1.1 | A variable keeps the type it was first given |
| 1.2 | A function always returns the same type |
| 1.3 | Convert types at the start of the statement |
| 1.4 | Convert to string with `String(value)` |
| 1.5 | Convert to number with `Number(value)`; `parseInt` always with a radix |
| 1.6 | Convert to boolean with `Boolean(value)` |
| 1.7 | No "trick" operators; if one is needed for speed, comment it |
| 1.8 | Throw `Error` or a subclass of it, never a string |
| 2.1 | `const` for every reference that is not reassigned |
| 2.2 | `let` when you must reassign; never `var` |
| 2.3 | One declaration per variable |
| 2.4 | Group the `const`s, then the `let`s |
| 2.5 | Declare variables near their first use |
| 2.6 | Always declare variables (no accidental globals) |
| 2.7 | No chained assignments (`a = b = c`) |
| 3.1 | Object literal `{}`, not `new Object()` |
| 3.2 | **Retired** (reserved words as keys) |
| 3.3 | Computed property names for dynamic keys |
| 3.4 | Method shorthand |
| 3.5 | Property value shorthand |
| 3.6 | Shorthand properties first |
| 3.7 | Quote only keys that are not valid identifiers |
| 3.8 | Object spread to copy; object rest to omit keys |
| 4.1 | Array literal `[]`, not `new Array()` |
| 4.2 | `push` to add items |
| 4.3 | Spread or `slice()` to copy arrays |
| 4.4 | `Array.from` for array-like objects |
| 4.5 | Array callbacks must return a value |
| 4.6 | Line breaks inside brackets of a multi-line array |
| 5.1 | Object destructuring when using several properties |
| 5.2 | Array destructuring |
| 5.3 | Return an object, not an array, for several return values |
| 6.1 | Single quotes |
| 6.2 | Don't break long strings across lines |
| 6.3 | Not used |
| 6.4 | Template strings, not concatenation |
| 6.5 | Never `eval()` a string |
| 6.6 | Never put untrusted strings into the DOM without sanitizing them |
| 7.1 | Never mutate parameters |
| 7.2 | Never reassign parameters |
| 7.3 | Default parameter syntax for arguments that may be left out |
| 7.4 | No side effects in default parameters |
| 7.5 | Default parameters last |
| 7.6 | At most 5 parameters; more → pass one object |
| 7.7 | Never name a parameter `arguments` |
| 7.8 | Never use `arguments`; use rest syntax `...args` |
| 7.9 | No function declarations inside blocks |
| 7.10 | Never use the `Function` constructor |
| 7.11 | One return, at the end of the function |
| 7.12 | Exception to 7.11: guard clauses may return early at the top |
| 7.13 | Wrap an IIFE in parentheses |
| 8.1 | Arrow functions for function expressions (callbacks) |
| 8.2 | No parentheses around a single arrow parameter |
| 9.1 | `class` syntax, not `prototype` |
| 9.2 | `static` for class-wide members |
| 9.3 | `extends` for inheritance |
| 9.4 | A custom `toString()` must work and have no side effects |
| 9.5 | No duplicate class members |
| 10.1 | One module per area of functionality |
| 10.2 | `import`/`export`, not `require` |
| 10.3 | A module with a single export uses a default export |
| 10.4 | No wildcard imports |
| 10.5 | Self-host third-party libraries |
| 11.1 | **Retired** → §25.3 (loops) |
| 11.2 | **Retired** (generators) |
| 12.1 | Dot notation for known property names |
| 12.2 | Bracket notation for property names in a variable |
| 13.1 | `===` and `!==`, never `==` or `!=` |
| 13.2 | **Retired** → §25.2 (null checks) |
| 13.3 | Shortcuts for booleans; explicit comparisons for strings and numbers |
| 13.4 | Braces around `case` blocks that declare variables |
| 13.5 | No nested ternaries; keep ternaries on one line |
| 14.1 | Braces on every multi-line block |
| 14.2 | `} else {` on one line |
| 15.1 | `/** ... */` (JSDoc) for multi-line comments, with types |
| 15.2 | `//` comments on their own line, above the code, with a blank line before |
| 15.3 | Mark follow-up comments with `FIXME` or `TODO` |
| 15.4 | `// FIXME:` for problems |
| 15.5 | `// TODO:` for planned improvements |
| 16.1 | 4-space soft tabs |
| 16.2 | One space before a leading brace |
| 16.3 | Space after `if`/`while`; no space between a function name and `(` |
| 16.4 | Spaces around operators |
| 16.5 | End each file with one newline |
| 16.6 | Long method chains (more than 2 calls): one call per line, leading dot |
| 16.7 | Blank line after a block, before the next statement |
| 16.8 | No blank lines at the start or end of a block |
| 16.9 | No spaces inside parentheses |
| 16.10 | No spaces inside square brackets |
| 16.11 | Spaces inside curly braces |
| 16.12 | Multi-line signatures and calls: one item per line, trailing comma |
| 16.13 | Lines at most 100 characters |
| 17.1 | Trailing commas on multi-line arrays and objects |
| 17.2 | No trailing commas on single-line arrays and objects |
| 18.1 | Always use semicolons |
| 19.1 | Methods are verbs; properties are nouns |
| 19.2 | Booleans start with `is`, `has`, `are`, `can` or `should` |
| 19.3 | Descriptive names; single letters only by convention (`i`, `x`) |
| 19.4 | camelCase for objects, functions and instances |
| 19.5 | PascalCase for classes and constructors |
| 19.6 | **Retired** → §25.1 (`#` private fields) |
| 19.7 | Don't save `this` in a variable; use arrow functions or `bind` |
| 19.8 | A file that exports one class is named after the class |
| 19.9 | `UPPER_SNAKE_CASE` for constants |
| 19.10 | Group related constants in one object |
| 19.11 | `Symbol()` for constants whose values have no meaning |
| 20.1 | `get`/`set` accessors, not `getX()`/`setX()` methods |
| 20.2 | Getters have no side effects |
| 21.1 | Event payloads are objects, not raw values |
| 22.1 | `$` prefix on jQuery object variables |
| 22.2 | `js-` prefix on selectors used by JavaScript; never style them |
| 22.3 | A selector tied to a JS class has the class's name |
| 22.4 | Cache jQuery lookups |
| 23.1 | Wrap callback-based async work in a Promise |
| 23.2 | No nested promise chains; prefer `await` |
| 23.3 | Every promise chain ends with `.catch()` |
| 24.1 | Minify and bundle production JavaScript, and test the bundle |

## Full rules

### §1 Types

**1.1** A variable keeps the type it was first given. Don't change a number into a string, and so on.

```javascript
// Bad
let count = 1;
count = 'none';

// Good
let count = 1;
count = 2;
```

**1.2** A function always returns the same type. Don't return a string on one path and `false` on another.

```javascript
// Bad
function getLabel(isActive) {
    if (isActive) {
        return 'Active';
    }

    return false;
}

// Good
function getLabel(isActive) {
    const label = isActive ? 'Active' : '';
    return label;
}
```

**1.3** Do any type conversion at the start of the statement, so the reader sees it first.

**1.4** Convert to a string with `String(value)`.
*Why: `value + ''` calls `valueOf()`, and `value.toString()` fails on `null` and `undefined`.*

```javascript
// Bad
const totalText = score + '';
const totalText = score.toString();

// Good
const totalText = String(score);
```

**1.5** Convert to a number with `Number(value)`. When you parse a string, use `parseInt` with a radix.

```javascript
// Bad
const quantity = +inputValue;
const quantity = new Number(inputValue);
const quantity = parseInt(inputValue);

// Good
const quantity = Number(inputValue);
const quantity = parseInt(inputValue, 10);
```

**1.6** Convert to a boolean with `Boolean(value)`.

```javascript
// Bad
const hasItems = !!itemCount;

// Good
const hasItems = Boolean(itemCount);
```

**1.7** Avoid "trick" operators whose purpose is not obvious (`~~x`, `x >> 0`, `+x`). If you need one for speed,
add a comment that says what it does and why.

**1.8** Throw a built-in `Error` type (`Error`, `TypeError`, `RangeError`) or a class that extends `Error`. Never
throw a string. *Why: an `Error` has a stack trace, and callers can catch by type.* See also §26.3.

```javascript
// Bad
throw 'Cannot divide by 0';

// Good
throw new RangeError('Cannot divide by 0');
```

### §2 Variables

**2.1** Use `const` for every reference that is not reassigned.

**2.2** If you must reassign a reference, use `let`. Never use `var`. *Why: `var` is function-scoped and hoisted;
`let` and `const` are block-scoped.*

```javascript
// Bad
var count = 1;
count += 1;

// Good
let count = 1;
count += 1;
```

**2.3** Use one `const` or `let` per variable.

```javascript
// Bad
const items = getItems(),
    isReady = true;

// Good
const items = getItems();
const isReady = true;
```

**2.4** Group all the `const`s, then all the `let`s.

```javascript
// Good
const isReady = true;
const items = getItems();
let selectedItem;
```

**2.5** Declare a variable near its first use. Don't do work before a guard clause that may return early.

```javascript
// Bad
function checkName(mode) {
    const name = getName();

    if (mode === 'test') {
        return '';
    }

    return name;
}

// Good
function checkName(mode) {
    if (mode === 'test') {
        return '';
    }

    const name = getName();
    return name;
}
```

**2.6** Always declare variables with `const` or `let`. An undeclared variable becomes a global.

```javascript
// Bad
cart = new Cart();

// Good
const cart = new Cart();
```

**2.7** Don't chain assignments. In `let a = b = c = 1;` only `a` is declared; `b` and `c` become globals.

```javascript
// Bad
let a = b = c = 1;

// Good
const a = 1;
const b = a;
const c = a;
```

### §3 Objects

**3.1** Create objects with the literal syntax.

```javascript
// Bad
const item = new Object();

// Good
const item = {};
```

**3.2 — Retired.** It banned reserved words such as `class` as object keys. That only mattered for old ES5
browsers. Reserved words are valid keys in every browser we support.

**3.3** Use computed property names when a key is dynamic, so the whole object is defined in one place.

```javascript
// Bad
const filters = { status: 'open' };
filters[fieldName] = value;

// Good
const filters = {
    status: 'open',
    [fieldName]: value,
};
```

**3.4** Use method shorthand.

```javascript
// Bad
const cart = {
    add: function (item) {
        // ...
    },
};

// Good
const cart = {
    add(item) {
        // ...
    },
};
```

**3.5** Use property value shorthand when the key and the variable have the same name.

```javascript
// Bad
const point = { x: x, y: y };

// Good
const point = { x, y };
```

**3.6** Put shorthand properties at the start of the object.

```javascript
// Good
const point = {
    x,
    y,
    color: 'blue',
    opacity: 0.5,
};
```

**3.7** Quote only the keys that are not valid identifiers.

```javascript
// Bad
const headers = { 'accept': 'text/html', 'content-type': 'text/html' };

// Good
const headers = { accept: 'text/html', 'content-type': 'text/html' };
```

**3.8** Copy objects with spread, not `Object.assign`. Use rest syntax to make a copy without some keys.
*Why: `Object.assign(original, ...)` changes `original` by mistake.*

```javascript
// Bad
const copy = Object.assign(original, { isActive: true });

// Good
const copy = { ...original, isActive: true };
const { password, ...safeUser } = user;
```

### §4 Arrays

**4.1** Create arrays with the literal syntax.

```javascript
// Bad
const items = new Array();

// Good
const items = [];
```

**4.2** Use `push` to add items.

```javascript
// Bad
items[items.length] = 'apple';

// Good
items.push('apple');
```

**4.3** Copy an array with spread or `slice()`, not a loop.

```javascript
// Good
const itemsCopy = [...items];
```

**4.4** Convert an array-like object (such as a `NodeList`) with `Array.from`.

```javascript
// Good
const buttons = Array.from(document.querySelectorAll('.js-button'));
```

**4.5** Array method callbacks (`map`, `filter`, `reduce`, ...) must return a value. You can leave out `return`
when the body is a single expression.

```javascript
// Bad
const totals = orders.map(order => {
    const tax = order.price * TAX_RATE;
});

// Good
const totals = orders.map(order => {
    const tax = order.price * TAX_RATE;
    return order.price + tax;
});

// Good
const prices = orders.map(order => order.price);
```

**4.6** If an array spans several lines, put a line break after `[` and before `]`.

```javascript
// Bad
const users = [{
    id: 1,
}, {
    id: 2,
}];

// Good
const users = [
    { id: 1 },
    { id: 2 },
];
```

### §5 Destructuring

**5.1** Use object destructuring when you use several properties of one object.

```javascript
// Bad
function getFullName(user) {
    const firstName = user.firstName;
    const lastName = user.lastName;
    return `${firstName} ${lastName}`;
}

// Good
function getFullName({ firstName, lastName }) {
    return `${firstName} ${lastName}`;
}
```

**5.2** Use array destructuring.

```javascript
// Bad
const first = parts[0];
const second = parts[1];

// Good
const [first, second] = parts;
```

**5.3** To return several values, return an object, not an array. *Why: callers pick what they need by name, and
you can add values later without breaking them.*

```javascript
// Bad
return [left, right, top, bottom];

// Good
return { left, right, top, bottom };
```

### §6 Strings

**6.1** Use single quotes. Use template strings only when you insert values (§6.4).

```javascript
// Bad
const name = "Ada";

// Good
const name = 'Ada';
```

**6.2** Don't split a long string across lines with `+` or `\`. *Why: split strings are hard to search for.* A
long string may go over the 100-character limit in §16.13.

**6.3** Not used. This number was never assigned.

**6.4** Build strings with template strings, not concatenation. No spaces inside `${}`.

```javascript
// Bad
const greeting = 'Hello, ' + name + '!';

// Good
const greeting = `Hello, ${name}!`;
```

**6.5** Never call `eval()` on a string. *Why: it runs any code in the string.* See also §7.10.

**6.6** Never put an untrusted string into the DOM unless it has been sanitized. Untrusted means anything a user
or an outside source can change: form input, query strings, cookies, and AJAX responses. See §29.1 for how.

### §7 Functions

**7.1** Never mutate (change) an object passed in as a parameter. *Why: the caller's object changes without
warning.*

```javascript
// Bad
function applyDefaults(options) {
    options.timeout = 5000;
}

// Good
function applyDefaults(options) {
    return { timeout: 5000, ...options };
}
```

**7.2** Never reassign a parameter.

```javascript
// Bad
function greet(name) {
    name = name || 'guest';
    // ...
}

// Good
function greet(name = 'guest') {
    // ...
}
```

**7.3** Use default parameter syntax for arguments that callers may leave out. Note that a default is used only
for `undefined`, not for `null`.

**7.4** Don't put side effects in a default parameter.

```javascript
// Bad
function nextId(id = counter++) {
    // ...
}
```

**7.5** Put default parameters last.

```javascript
// Bad
function search(options = {}, query) {
    // ...
}

// Good
function search(query, options = {}) {
    // ...
}
```

**7.6** A function has at most 5 parameters. If it needs more, take one object instead. *Why: with many
positional arguments, the order is easy to get wrong and hard to read at the call site.*

```javascript
// Bad
function createUser(name, email, role, team, isAdmin, shouldNotify) {
    // ...
}

// Good
function createUser({ name, email, role, team, isAdmin, shouldNotify = true }) {
    // ...
}
```

**7.7** Never name a parameter `arguments`. It hides the built-in `arguments` object.

**7.8** Never use the `arguments` object. Use rest syntax. *Why: rest parameters are a real array, and the
signature shows what the function takes.*

```javascript
// Bad
function joinAll() {
    const parts = Array.prototype.slice.call(arguments);
    return parts.join('');
}

// Good
function joinAll(...parts) {
    return parts.join('');
}
```

**7.9** Never declare a function inside a block (`if`, `while`, ...). Assign a function expression to a variable
instead.

```javascript
// Bad
if (isLoggedIn) {
    function showMenu() {
        // ...
    }
}

// Good
let showMenu = null;

if (isLoggedIn) {
    showMenu = () => {
        // ...
    };
}
```

**7.10** Never use the `Function` constructor. *Why: like `eval()`, it runs code from a string.*

```javascript
// Bad
const add = new Function('a', 'b', 'return a + b');
```

**7.11** Prefer one return, at the end of the function. Avoid returns in the middle. *Why: many exits make the
flow hard to follow and invite different return types (§1.2).*

```javascript
// Bad
function loadUser(userId) {
    if (userId !== null) {
        return getUser(userId);
    } else {
        return new User();
    }
}

// Good
function loadUser(userId) {
    let user = null;

    if (userId !== null) {
        user = getUser(userId);
    } else {
        user = new User();
    }

    return user;
}
```

**7.12** The exception to §7.11 is guard clauses. When you check that the parameters are valid, return early at
the top of the function.

```javascript
// Good
function add(first, second) {
    if (Number.isNaN(first) || Number.isNaN(second)) {
        return 0;
    }

    const sum = first + second;
    return sum;
}
```

**7.13** Wrap an immediately invoked function expression (IIFE) in parentheses. With modules you rarely need an
IIFE; see the no-bundler note in `SKILL.md`.

```javascript
// Good
(function () {
    // ...
}());
```

### §8 Arrow functions

**8.1** When you need a function expression, such as a callback, use an arrow function. *Why: it keeps the outer
`this` and is shorter.* If the logic is long, move it into a named function (§25.5).

```javascript
// Bad
items.map(function (item) {
    return item.price;
});

// Good
items.map(item => item.price);
```

**8.2** Leave out the parentheses around a single parameter. Use them for zero or several parameters.

```javascript
// Bad
items.map((item) => item.price);

// Good
items.map(item => item.price);
items.reduce((total, item) => total + item.price, 0);
```

### §9 Classes

**9.1** Use `class`. Don't change `prototype` directly.

```javascript
// Bad
function Queue(contents = []) {
    this.items = [...contents];
}

Queue.prototype.pop = function () {
    return this.items.shift();
};

// Good
class Queue {
    #items = [];

    constructor(contents = []) {
        this.#items = [...contents];
    }

    pop() {
        return this.#items.shift();
    }
}
```

**9.2** Use `static` for properties and methods that belong to the class, not to an instance.

```javascript
// Good
class Queue {
    static instanceCount = 0;

    constructor() {
        Queue.instanceCount += 1;
    }

    static getInstanceCount() {
        return Queue.instanceCount;
    }
}
```

**9.3** Use `extends` for inheritance. *Why: it is built in and keeps `instanceof` working.*

```javascript
// Good
class PeekableQueue extends Queue {
    peek() {
        // ...
    }
}
```

**9.4** A custom `toString()` is fine, but it must always work and must have no side effects.

**9.5** Don't declare the same class member twice. The last one silently wins, so a duplicate is almost always a
bug.

### §10 Modules

**10.1** Make a separate module for each area of functionality. Don't put several concerns, or the whole app, in
one file.

**10.2** Use `import`/`export`, not CommonJS `require` or another module system.

```javascript
// Bad
const CartService = require('./CartService');

// Good
import CartService from './CartService';
```

**10.3** When a module has only one export, make it the default export.

```javascript
// Bad
export function formatPrice(amount) {
    // ...
}

// Good
export default function formatPrice(amount) {
    // ...
}
```

**10.4** Don't use wildcard imports.

```javascript
// Bad
import * as priceUtils from './priceUtils';

// Good
import { formatPrice, roundPrice } from './priceUtils';
```

**10.5** Self-host third-party libraries whenever possible. Don't load scripts from outside domains or CDNs. The
exception is a library that has no self-hosted version, such as Google Maps or Google Analytics; then follow
§29.5. *Why: outside scripts add attack paths, leak users' IP addresses, and can go down.*

```javascript
// Bad
import $ from 'https://code.jquery.com/jquery-3.7.1.min.js';

// Good
import $ from './vendor/jquery.min.js';
```

### §11 Iterators and generators

**11.1 — Retired → §25.3.** It banned `for...of` loops entirely. That made sequential `await` and early exit from
a loop awkward. §25.3 keeps the preference for array methods and allows `for...of` where it is clearer.

**11.2 — Retired.** It banned generators because they did not transpile well to ES5. We no longer target ES5.

### §12 Properties

**12.1** Use dot notation for property names you know in advance.

```javascript
// Bad
const isAdmin = user['isAdmin'];

// Good
const isAdmin = user.isAdmin;
```

**12.2** Use bracket notation when the property name is in a variable.

```javascript
// Good
const value = user[fieldName];
```

### §13 Comparison

**13.1** Use `===` and `!==`. Never use `==` or `!=`. *Why: `==` converts types with surprising rules
(`0 == ''` is `true`).* This includes null checks; see §25.2.

```javascript
// Bad
if (status == 'open') {
    // ...
}

// Good
if (status === 'open') {
    // ...
}
```

**13.2 — Retired → §25.2.** It allowed `== null` to check for both `null` and `undefined`. We use strict
equality everywhere instead, so the linter can ban `==` with no exceptions.

**13.3** Use shortcuts for booleans. For strings and numbers, compare explicitly.

```javascript
// Bad
if (isValid === true) {
    // ...
}

if (name) {
    // ...
}

if (items.length) {
    // ...
}

// Good
if (isValid) {
    // ...
}

if (name !== '') {
    // ...
}

if (items.length > 0) {
    // ...
}
```

**13.4** In a `switch`, wrap a `case` or `default` that declares `let`, `const`, `function` or `class` in braces.
*Why: without braces, the declaration is visible in every case.*

```javascript
// Good
switch (action) {
    case 'add': {
        const item = createItem();
        cart.add(item);
        break;
    }

    default: {
        logUnknownAction(action);
    }
}
```

**13.5** Don't nest ternaries. Keep each ternary on one line.

```javascript
// Bad
const label = count > 10
    ? 'many'
    : count > 0 ? 'some' : 'none';

// Good
const someOrNone = count > 0 ? 'some' : 'none';
const label = count > 10 ? 'many' : someOrNone;
```

### §14 Blocks

**14.1** Use braces on every multi-line block. A body without braces is allowed only on the same line as its
`if`.

```javascript
// Bad
if (isDone)
    return;

// Good
if (isDone) {
    return;
}
```

**14.2** Put `else` on the same line as the closing brace of the `if`.

```javascript
// Bad
if (isOpen) {
    close();
}
else {
    open();
}

// Good
if (isOpen) {
    close();
} else {
    open();
}
```

### §15 Comments

**15.1** Use `/** ... */` (JSDoc) for multi-line comments. Give types for all parameters and the return value.

```javascript
// Good
/**
 * Builds a new element from a tag name.
 *
 * @param {string} tag The tag name, such as 'div'.
 * @returns {HTMLElement} The new element.
 */
function makeElement(tag) {
    // ...
}
```

**15.2** Use `//` for one-line comments. Put the comment on its own line above the code it describes. Put a blank
line before it, unless it is the first line of a block.

```javascript
// Bad
const isActive = true; // is current tab

// Good
// The current tab is always active.
const isActive = true;
```

**15.3** Start any comment that needs follow-up with `FIXME` or `TODO`, so readers know it is a task.

**15.4** Use `// FIXME:` for a problem that must be fixed.

```javascript
// FIXME: should not use a global here
total = 0;
```

**15.5** Use `// TODO:` for an improvement to make later.

```javascript
// TODO: make the total configurable through options
this.total = 0;
```

### §16 Whitespace

Prettier and ESLint enforce most of §16 to §18 (see §31). In a review, report them as one grouped, low-severity
finding.

**16.1** Indent with 4 spaces (soft tabs).

**16.2** Put one space before a leading brace.

```javascript
// Bad
function test(){
    dog.set('attr',{ age: 1 });
}

// Good
function test() {
    dog.set('attr', { age: 1 });
}
```

**16.3** Put one space after `if`, `while` and other control keywords. Put no space between a function name and
its `(`.

```javascript
// Bad
if(isReady) {
    start ();
}

// Good
if (isReady) {
    start();
}
```

**16.4** Put spaces around operators.

```javascript
// Bad
const total=price+tax;

// Good
const total = price + tax;
```

**16.5** End each file with exactly one newline.

**16.6** When a chain has more than 2 method calls, put each call on its own line, starting with the dot.

```javascript
// Bad
$('#items').find('.selected').addClass('is-open').end().find('.count').text(total);

// Good
$('#items')
    .find('.selected')
    .addClass('is-open')
    .end()
    .find('.count')
    .text(total);
```

**16.7** Leave a blank line after a block, before the next statement.

```javascript
// Bad
if (isDone) {
    return result;
}
return fallback;

// Good
if (isDone) {
    return result;
}

return fallback;
```

**16.8** Don't start or end a block with a blank line.

```javascript
// Bad
function run() {

    start();

}

// Good
function run() {
    start();
}
```

**16.9** No spaces inside parentheses: `run(task)`, not `run( task )`.

**16.10** No spaces inside square brackets: `[1, 2, 3]`, not `[ 1, 2, 3 ]`.

**16.11** Spaces inside curly braces: `{ name: 'Ada' }`, not `{name: 'Ada'}`.

**16.12** When a function signature or call spans several lines, put each item on its own line and add a
trailing comma after the last one.

```javascript
// Bad
function createOrder(customer,
                     items,
                     discount) {
    // ...
}

// Good
function createOrder(
    customer,
    items,
    discount,
) {
    // ...
}
```

**16.13** Keep lines to at most 100 characters, including indentation. The exception is a long string (§6.2).

### §17 Commas

**17.1** Use a trailing comma on multi-line arrays and objects. Never put commas at the start of a line. *Why:
adding an item changes only one line in the diff.*

```javascript
// Bad
const hero = {
    firstName: 'Ada',
    lastName: 'Lovelace'
};

// Good
const hero = {
    firstName: 'Ada',
    lastName: 'Lovelace',
};
```

**17.2** Don't use a trailing comma on a single-line array or object.

```javascript
// Bad
const heroes = ['Ada', 'Grace',];

// Good
const heroes = ['Ada', 'Grace'];
```

### §18 Semicolons

**18.1** Always end statements with a semicolon. Don't rely on automatic semicolon insertion.

### §19 Naming conventions

**19.1** Name methods with verbs and properties with nouns.

```javascript
// Bad
class Plane {
    flew = 0;

    airborne() {
        // ...
    }
}

// Good
class Plane {
    altitude = 0;

    takeOff() {
        // ...
    }
}
```

**19.2** Start the name of a boolean variable, property or method with `is`, `has`, `are`, `can` or `should`.
(`can` is a team addition.)

```javascript
// Bad
if (visible) {
    // ...
}

// Good
if (isVisible) {
    // ...
}

if (user.canEdit()) {
    // ...
}
```

**19.3** Use descriptive names. Use single letters only where they are the normal name, such as `i` for an index
or `x`/`y` for coordinates.

```javascript
// Bad
function q() {
    // ...
}

// Good
function query() {
    // ...
}
```

**19.4** Use camelCase for objects, functions and instances.

```javascript
// Bad
const this_is_my_object = {};

// Good
const thisIsMyObject = {};
```

**19.5** Use PascalCase for classes and constructors.

```javascript
// Bad
class user {
    // ...
}

// Good
class User {
    // ...
}
```

**19.6 — Retired → §25.1.** It used a leading `_` for private or protected properties. The `_` is only a
convention; real private fields (`#name`) are now enforced by the language.

**19.7** Don't save `this` in a variable (`self`, `that`). Use an arrow function or `bind`.

```javascript
// Bad
function start() {
    const self = this;

    return function () {
        self.run();
    };
}

// Good
function start() {
    return () => {
        this.run();
    };
}
```

**19.8** If a file exports one class, name the file exactly after the class: `CheckBox` lives in `CheckBox.js`.

**19.9** Write constants in `UPPER_SNAKE_CASE`. A constant is a value fixed when you write the code, such as
`MAX_RETRIES = 3`. A `const` that holds a computed or runtime value is still camelCase.

```javascript
// Good
const MAX_RETRIES = 3;
const user = await fetchUser(userId);
```

**19.10** Group related constants in one object. Name its keys in `UPPER_SNAKE_CASE` too.

```javascript
// Bad
const SELECTOR_ACTIVE = '.is-active';
const SELECTOR_MODAL_CLOSE = '.js-modal-close';

// Good
const SELECTORS = {
    ACTIVE: '.is-active',
    MODAL_CLOSE: '.js-modal-close',
};
```

**19.11** If a constant's value is arbitrary and has no meaning of its own, use `Symbol()`.

```javascript
// Good
const PAGES = {
    HOME: Symbol('home'),
    ABOUT: Symbol('about'),
};
```

### §20 Accessors

**20.1** Use `get` and `set` accessors, not `getX()` and `setX()` methods.

```javascript
// Bad
class Dragon {
    #age = 0;

    getAge() {
        return this.#age;
    }

    setAge(value) {
        this.#age = value;
    }
}

// Good
class Dragon {
    #age = 0;

    get age() {
        return this.#age;
    }

    set age(value) {
        this.#age = value;
    }
}
```

**20.2** A getter must have no side effects. It only reads.

```javascript
// Bad
get age() {
    this.#readCount += 1;
    return this.#age;
}

// Good
get age() {
    return this.#age;
}
```

### §21 Events

**21.1** When you attach data to an event (DOM or custom), pass an object, not a raw value. *Why: you can add
fields later without changing every handler.*

```javascript
// Bad
$(this).trigger('listingUpdated', listing.id);

$(this).on('listingUpdated', (event, listingId) => {
    // ...
});

// Good
$(this).trigger('listingUpdated', { listingId: listing.id });

$(this).on('listingUpdated', (event, data) => {
    // use data.listingId
});
```

### §22 DOM interaction

**22.1** Start the name of a variable that holds a jQuery object with `$`.

```javascript
// Bad
const sidebar = $('.js-sidebar');

// Good
const $sidebar = $('.js-sidebar');
```

**22.2** Give every element that JavaScript selects a class starting with `js-`. Use `js-` classes only for
selecting, never for styling. *Why: designers can change style classes without breaking the script.*

```html
<!-- Bad: the script depends on a style class -->
<a href="#" class="previous-button">Previous</a>

<!-- Good -->
<a href="#" class="previous-button js-previous-button">Previous</a>
```

**22.3** When an element's behavior comes from a JavaScript class, name its `js-` selector after that class.

```javascript
// Bad
new CarouselView($('.js-carousel'));

// Good
new CarouselView($('.js-CarouselView'));
```

**22.4** Cache jQuery lookups. Don't run the same selector twice.

```javascript
// Bad
$('.js-sidebar').hide();
$('.js-sidebar').addClass('is-closed');

// Good
const $sidebar = $('.js-sidebar');
$sidebar.hide();
$sidebar.addClass('is-closed');
```

### §23 Asynchronous operations

**23.1** Wrap callback-based async work (timers, old APIs) in a native `Promise`, so it works with `await`.

```javascript
// Good
function waitFor(milliseconds) {
    return new Promise(resolve => {
        window.setTimeout(resolve, milliseconds);
    });
}
```

**23.2** Don't nest promise chains. Use a flat chain, or better, `async`/`await` (§27.1).

```javascript
// Bad
waitFor(1000).then(() => {
    waitFor(2000).then(() => {
        console.log('Done');
    });
});

// Good
async function runSequence() {
    await waitFor(1000);
    await waitFor(2000);
    console.log('Done');
}
```

**23.3** End every promise chain with `.catch()`. *Why: otherwise an error inside the chain can fail silently.*
For `async` functions, see §27.4.

```javascript
// Good
waitFor(1000)
    .then(() => showMessage())
    .catch(error => logger.error('waitFor failed', error));
```

### §24 Deployment

**24.1** Minify and bundle all JavaScript that goes to production. Test the bundled code early, because it can
behave differently from the source.
