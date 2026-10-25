# OWASP Top 10:2025 — Security Reference

Based on the OWASP Top 10:2025 (released November 2025). Cite findings as `[A0N]` (e.g. `[A01]`).
Each category includes: what it is, why it matters, what to look for in code review, and secure patterns
for both C# (.NET) and JavaScript (browser/jQuery).

---

## A01 — Broken Access Control

**What it is:** Users can act outside their intended permissions — accessing other users' data, calling
admin-only endpoints, or bypassing authorization checks entirely.

**Why it matters:** The most prevalent OWASP risk. 94% of tested applications had at least one broken
access control vulnerability. Attackers probe for missing checks systematically.

**What to look for:**
- Authorization checked only at the UI level (hidden buttons), not enforced server-side
- Direct object references in URLs/params without ownership checks (`/api/orders/1234` — is 1234 yours?)
- Missing role checks on sensitive controller actions or API endpoints
- Insecure Direct Object Reference (IDOR): `userId` or `documentId` taken from the request without verification
- Elevation of privilege: regular user accessing admin functionality

**C# — vulnerable:**
```csharp
// No ownership check — any authenticated user can access any order
public async Task<IActionResult> GetOrder(int orderId)
{
    Order order = await _repo.FindByIdAsync(orderId);
    return Ok(order);
}
```

**C# — secure:**
```csharp
[Authorize]
public async Task<IActionResult> GetOrder(int orderId)
{
    string currentUserId = User.FindFirstValue(ClaimTypes.NameIdentifier);
    Order order = await _repo.FindByIdAsync(orderId);

    if (order is null || order.OwnerId != currentUserId)
    {
        return Forbid();
    }

    return Ok(order);
}
```

**JavaScript — vulnerable:**
```javascript
// Client-side only — server never verifies ownership
function loadOrder(orderId) {
    if (currentUser.role === "admin") {
        showAdminPanel();
    }
    fetch(`/api/orders/${orderId}`).then(r => r.json()).then(renderOrder);
}
```

**JavaScript — secure:** Authorization is a server concern. On the client, never use role checks as the
sole gate. Always assume the server enforces access — the JS just renders what the server returns (or
handles a 403).

---

## A02 — Security Misconfiguration

**What it is:** Insecure default settings, unnecessary features enabled, missing hardening, verbose error
messages, or default credentials left in place. Jumped from #5 to #2 in 2025 — reflecting how deployment
complexity has outpaced configuration discipline.

**Why it matters:** Misconfiguration is easy to exploit and often invisible until something breaks. A
single `X-Powered-By: ASP.NET` header or a stack trace in a 500 response hands attackers your technology
stack for free.

**What to look for:**
- Stack traces or detailed error messages returned to clients
- Debug endpoints or developer tools enabled in production
- Default credentials not changed
- Unnecessary HTTP methods allowed (TRACE, PUT on read-only APIs)
- Missing security headers (`X-Content-Type-Options`, `X-Frame-Options`, `Content-Security-Policy`)
- CORS configured too broadly (`Access-Control-Allow-Origin: *` on authenticated endpoints)

**C# — secure patterns:**
```csharp
// Suppress detailed errors in production (Program.cs / Startup.cs)
if (!app.Environment.IsDevelopment())
{
    app.UseExceptionHandler("/Error");
    app.UseHsts();
}

// Add security headers via middleware
app.Use(async (context, next) =>
{
    context.Response.Headers.Append("X-Content-Type-Options", "nosniff");
    context.Response.Headers.Append("X-Frame-Options", "DENY");
    context.Response.Headers.Append("Referrer-Policy", "no-referrer");
    await next();
});

// Restrict CORS to known origins only
builder.Services.AddCors(options =>
{
    options.AddPolicy("AllowKnownOrigins", policy =>
        policy.WithOrigins("https://app.example.com")
              .AllowedMethods("GET", "POST"));
});
```

**JavaScript — secure patterns:**
```javascript
// Never expose internal error details to the user
async function saveRecord(data) {
    try {
        const response = await fetch("/api/records", {
            method: "POST",
            body: JSON.stringify(data),
            headers: { "Content-Type": "application/json" }
        });
        if (!response.ok) {
            // Show generic message — log detail server-side
            showError("Save failed. Please try again.");
            return;
        }
        return response.json();
    } catch (error) {
        console.error("Save failed:", error); // dev console only
        showError("An unexpected error occurred.");
    }
}
```

---

## A03 — Software Supply Chain Failures *(new in 2025)*

**What it is:** Risks from dependencies, build tools, and distribution infrastructure — malicious packages,
compromised maintainers, tampered builds, and unpinned dependency versions. Has the **highest average
exploit and impact scores** of any 2025 category despite being new.

**Why it matters:** Attacks on the supply chain bypass application-level defenses entirely — the malicious
code arrives pre-packaged as a "legitimate" library. SolarWinds, XZ Utils, and npm package hijackings are
the template.

**What to look for:**
- NuGet/npm packages not pinned to exact versions
- Dependencies not regularly audited for known CVEs
- No integrity verification on downloaded packages (`integrity` attribute on script tags)
- Wildcard version ranges in `package.json` (`^`, `~`)
- Build pipeline steps that download and execute scripts without verification

**C# — secure patterns:**
```xml
<!-- Pin exact versions in .csproj -->
<PackageReference Include="Newtonsoft.Json" Version="13.0.3" />

<!-- Run regularly in CI -->
<!-- dotnet list package --vulnerable -->
<!-- dotnet outdated -->
```

**JavaScript — secure patterns:**
```html
<!-- Use Subresource Integrity (SRI) for CDN scripts -->
<script src="https://cdn.example.com/jquery-3.7.1.min.js"
        integrity="sha384-[hash]"
        crossorigin="anonymous"></script>
```

```json
// package.json — pin exact versions, no ^ or ~
{
  "dependencies": {
    "dompurify": "3.1.5"
  }
}
```

---

## A04 — Cryptographic Failures

**What it is:** Sensitive data exposed due to weak or missing encryption — in transit, at rest, or in
memory. Includes weak algorithms, poor key management, and storing secrets in code.

**Why it matters:** Cryptographic failures are silent — you don't know data was exposed until after a
breach. The gap between "encrypted" and "securely encrypted" is wide.

**What to look for:**
- Passwords stored as plain text or with weak hashing (MD5, SHA1 without salt)
- Sensitive data in query strings, logs, or error messages
- Hardcoded secrets, API keys, or connection strings in source code
- HTTP used instead of HTTPS for sensitive data
- Weak or deprecated algorithms: DES, 3DES, RC4, MD5, SHA1
- Insufficient key lengths (RSA < 2048-bit, AES-128 where AES-256 is warranted)

**C# — vulnerable:**
```csharp
// Storing plain text password
user.Password = inputPassword;

// Hardcoded secret
string apiKey = "sk_live_abc123xyz";

// MD5 — broken
string hash = Convert.ToHexString(MD5.HashData(Encoding.UTF8.GetBytes(password)));
```

**C# — secure:**
```csharp
// Password hashing with ASP.NET Core Identity (bcrypt-based)
string hashedPassword = _passwordHasher.HashPassword(user, inputPassword);

// Secrets via environment / config, never in source
string apiKey = _config["ExternalApi:Key"]; // loaded from env/KeyVault

// Modern hashing
string hash = Convert.ToHexString(SHA256.HashData(Encoding.UTF8.GetBytes(data)));
```

**JavaScript — secure patterns:**
```javascript
// Never store secrets in client-side JS — they're visible to anyone
// Use environment variables server-side; expose only safe, scoped tokens to the browser

// Use HTTPS fetch — never downgrade
const response = await fetch("https://api.example.com/data"); // always https://

// Don't log sensitive data
console.log("User:", user.name); // OK
console.log("Token:", user.authToken); // NOT OK — visible in browser console
```

---

## A05 — Injection

**What it is:** Untrusted data sent to an interpreter (SQL, shell, LDAP, XML) as part of a command.
Injection dropped from #3 to #5 in 2025 as parameterized queries became widespread — but it remains
catastrophic when it does appear.

**Why it matters:** SQL injection can expose or destroy an entire database in a single request. Command
injection can give an attacker a shell on the server.

**What to look for:**
- String concatenation used to build SQL queries
- User input passed to shell commands, `Process.Start`, `eval()`
- Raw HTML constructed from user input without sanitization (XSS — also falls here)
- ORM queries bypassed in favour of raw SQL with unparameterized input

**C# — vulnerable:**
```csharp
// SQL injection
string sql = "SELECT * FROM Users WHERE Username = '" + username + "'";
SqlCommand cmd = new SqlCommand(sql, connection);

// Command injection
Process.Start("cmd.exe", "/c ping " + userInput);
```

**C# — secure:**
```csharp
// Parameterized query
string sql = "SELECT * FROM Users WHERE Username = @username";
SqlCommand cmd = new SqlCommand(sql, connection);
cmd.Parameters.AddWithValue("@username", username);

// EF Core — safe by default via LINQ
User user = await _ctx.Users.FirstOrDefaultAsync(u => u.Username == username);

// If raw SQL is needed in EF Core, use FromSqlInterpolated (not FromSqlRaw with concat)
IQueryable<User> users = _ctx.Users.FromSqlInterpolated($"SELECT * FROM Users WHERE Username = {username}");
```

**JavaScript — vulnerable:**
```javascript
// XSS via innerHTML (injection of script content)
document.getElementById("output").innerHTML = userInput;

// jQuery equivalent
$("#output").html(userInput); // dangerous if userInput is unsanitized
```

**JavaScript — secure:**
```javascript
import DOMPurify from "dompurify";

// Sanitize before any HTML injection
document.getElementById("output").innerHTML = DOMPurify.sanitize(userInput);

// Better: use textContent when you don't need HTML rendering
document.getElementById("output").textContent = userInput;

// jQuery safe alternatives
$("#output").text(userInput);        // safe — escapes HTML
$("#output").val(userInput);         // safe for input values
```

---

## A06 — Insecure Design

**What it is:** Flaws in architecture and design that create vulnerabilities regardless of implementation
quality — missing threat modeling, weak password-reset flows, no rate limiting by design, missing
authorization steps in the workflow.

**Why it matters:** Implementation fixes can't compensate for a broken design. A login flow that emails a
reset link without verifying identity, or an API that allows unlimited retries, needs a design change.

**What to look for:**
- No rate limiting on authentication, password reset, or OTP endpoints
- Business logic that can be bypassed by skipping steps (e.g. checkout without payment)
- Password reset that relies on guessable tokens or leaks the token in a URL
- Missing account lockout on brute-force targets
- Trust boundaries that assume the client is honest

**C# — secure patterns:**
```csharp
// Rate limiting in ASP.NET Core (Program.cs)
builder.Services.AddRateLimiter(options =>
{
    options.AddFixedWindowLimiter("login", limiterOptions =>
    {
        limiterOptions.PermitLimit = 5;
        limiterOptions.Window = TimeSpan.FromMinutes(1);
    });
});

// Cryptographically secure reset token — not a sequential ID
string resetToken = Convert.ToBase64String(RandomNumberGenerator.GetBytes(32));
```

**JavaScript — patterns:**
```javascript
// Disable the submit button after first click to prevent double-submission
async function handleSubmit(event) {
    const button = event.currentTarget;
    button.disabled = true;

    try {
        await submitOrder();
    } finally {
        button.disabled = false;
    }
}

// Never enforce business rules only on the client
// e.g. don't skip the payment step based on a JS flag — the server must verify
```

---

## A07 — Identification & Authentication Failures

**What it is:** Weaknesses in authentication — weak passwords permitted, credentials exposed, session
tokens not invalidated, missing MFA on sensitive operations.

**Why it matters:** Compromised credentials are the #1 attack vector in breaches. Authentication bugs
give attackers direct access to user accounts.

**What to look for:**
- Passwords not hashed with a strong adaptive algorithm (bcrypt, Argon2, scrypt)
- Session tokens not invalidated on logout
- "Remember me" tokens stored insecurely or never expiring
- No MFA available on sensitive actions
- Session IDs in URLs (visible in logs and referrer headers)
- Credentials transmitted over HTTP

**C# — vulnerable:**
```csharp
// Session not invalidated on logout
public IActionResult Logout()
{
    return RedirectToAction("Index", "Home"); // does nothing to the session
}
```

**C# — secure:**
```csharp
// Proper logout with ASP.NET Core Identity
public async Task<IActionResult> Logout()
{
    await _signInManager.SignOutAsync();
    HttpContext.Session.Clear();
    return RedirectToAction("Index", "Home");
}

// Cookie auth options — secure defaults
builder.Services.ConfigureApplicationCookie(options =>
{
    options.Cookie.HttpOnly = true;
    options.Cookie.SecurePolicy = CookieSecurePolicy.Always;
    options.Cookie.SameSite = SameSiteMode.Strict;
    options.SlidingExpiration = true;
    options.ExpireTimeSpan = TimeSpan.FromHours(8);
});
```

**JavaScript — secure patterns:**
```javascript
// Never store auth tokens in localStorage — XSS-accessible
// Use HttpOnly cookies (set server-side) instead

// On logout, clear any client-side state and redirect
async function logout() {
    await fetch("/auth/logout", { method: "POST" });
    // Clear any in-memory state
    currentUser = null;
    window.location.href = "/login";
}

// Never put session IDs or tokens in URLs
// Bad:  fetch(`/api/data?token=${authToken}`)
// Good: use Authorization header or HttpOnly cookie
```

---

## A08 — Software & Data Integrity Failures

**What it is:** Code or data pipelines that don't verify integrity — insecure deserialization, auto-update
mechanisms without signature verification, CI/CD pipelines that trust unverified input.

**Why it matters:** An attacker who can influence what gets deserialized or what code gets deployed can
achieve remote code execution.

**What to look for:**
- Deserializing untrusted data using `BinaryFormatter`, `JavaScriptSerializer`, or `XmlSerializer` with
  polymorphic types from user input
- Using `JsonConvert.DeserializeObject` with `TypeNameHandling.All` on untrusted input
- Auto-update or plugin loading without signature verification
- `eval()` or `new Function()` called with any external or user-supplied input

**C# — vulnerable:**
```csharp
// BinaryFormatter with untrusted data — remote code execution risk
object obj = formatter.Deserialize(untrustedStream);

// Newtonsoft with TypeNameHandling — allows type confusion attacks
var settings = new JsonSerializerSettings { TypeNameHandling = TypeNameHandling.All };
var result = JsonConvert.DeserializeObject(untrustedJson, settings);
```

**C# — secure:**
```csharp
// Use System.Text.Json — no polymorphic type loading by default
MyDto result = JsonSerializer.Deserialize<MyDto>(untrustedJson);

// If Newtonsoft is required, never use TypeNameHandling on untrusted input
var settings = new JsonSerializerSettings { TypeNameHandling = TypeNameHandling.None };
```

**JavaScript — secure patterns:**
```javascript
// Never use eval() on external or user-supplied data
// Bad:
eval(dataFromServer.script);
new Function(userInput)();

// Good: use structured data (JSON) and handle it explicitly
const data = JSON.parse(serverResponse); // safe — JSON.parse doesn't execute code
renderTemplate(data.title, data.body);   // render known properties, not arbitrary code
```

---

## A09 — Security Logging & Alerting Failures

**What it is:** Insufficient logging and monitoring — attacks happen but leave no trace, or logs exist
but nobody alerts on them. The name changed in 2025 to emphasize that logging without alerting has
minimal security value.

**Why it matters:** The average time to detect a breach is months. Without logging, forensics is
impossible. Without alerting, logs are shelfware.

**What to look for:**
- Authentication failures not logged (failed logins, invalid tokens)
- No logging on high-value operations (permission changes, data exports, admin actions)
- Log entries that include sensitive data (passwords, full credit card numbers, session tokens)
- Logs written to local disk only with no central aggregation
- No alert thresholds defined for repeated failures

**C# — secure patterns:**
```csharp
// Log security events with structured logging (Serilog / ILogger)
public async Task<IActionResult> Login(LoginModel model)
{
    Microsoft.AspNetCore.Identity.SignInResult result = await _signInManager.PasswordSignInAsync(
        model.Username, model.Password, model.RememberMe, lockoutOnFailure: true);

    if (result.Succeeded)
    {
        _logger.LogInformation("User {Username} logged in from {IP}",
            model.Username, HttpContext.Connection.RemoteIpAddress);
        return RedirectToAction("Index");
    }

    _logger.LogWarning("Failed login attempt for {Username} from {IP}",
        model.Username, HttpContext.Connection.RemoteIpAddress);

    return View(model);
}

// Never log sensitive data
_logger.LogInformation("Processing payment for order {OrderId}", orderId); // Good
_logger.LogInformation("Card number: {CardNumber}", cardNumber);            // NEVER
```

**JavaScript — secure patterns:**
```javascript
// Client-side: log security-relevant events to the server, not just the console
async function reportSecurityEvent(eventType, detail) {
    await fetch("/api/security-log", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
            event: eventType,
            detail,
            timestamp: new Date().toISOString()
        })
    });
}

// Example: log suspicious activity
reportSecurityEvent("repeated-failed-login", { username: maskedUsername });
```

---

## A10 — Mishandling of Exceptional Conditions *(new in 2025)*

**What it is:** Systems that fail unsafely — exposing sensitive data in error messages, crashing in ways
that reveal internal state, or "failing open" (granting access when an error occurs instead of denying).
Covers 24 CWEs including improper error handling, null dereference crashes, and SSRF.

**Why it matters:** Errors are inevitable. How a system fails determines whether an error is an
inconvenience or a security incident.

**What to look for:**
- Stack traces or internal error details returned to clients
- `catch` blocks that swallow exceptions silently (fails open — system continues as if nothing happened)
- Default-to-grant behavior on error ("if the auth check throws, allow the request")
- Error responses that differ based on whether a user/resource exists (user enumeration)
- Unhandled promise rejections that leave the UI in an indeterminate state

**C# — vulnerable:**
```csharp
// Fails open — grants access if the permission check throws
public async Task<IActionResult> AdminAction()
{
    try
    {
        bool bIsAdmin = await _authService.IsAdminAsync(User);
        if (!bIsAdmin) return Forbid();
    }
    catch
    {
        // Swallowed — continues to admin action even on error
    }

    return await DoAdminWork();
}
```

**C# — secure:**
```csharp
// Fails closed — deny on error
public async Task<IActionResult> AdminAction()
{
    bool bIsAdmin;
    try
    {
        bIsAdmin = await _authService.IsAdminAsync(User);
    }
    catch (Exception ex)
    {
        _logger.LogError(ex, "Admin check failed for {User}", User.Identity?.Name);
        return StatusCode(503, "Service temporarily unavailable");
    }

    if (!bIsAdmin)
    {
        return Forbid();
    }

    return await DoAdminWork();
}
```

**JavaScript — vulnerable:**
```javascript
// Silent catch — fails open
async function checkPermission(action) {
    try {
        return await authService.can(action);
    } catch {
        return true; // dangerous default
    }
}
```

**JavaScript — secure:**
```javascript
// Fail closed — deny on error
async function checkPermission(action) {
    try {
        return await authService.can(action);
    } catch (error) {
        console.error("Permission check failed:", error);
        return false; // safe default — deny
    }
}

// Handle unhandled promise rejections globally
window.addEventListener("unhandledrejection", (event) => {
    console.error("Unhandled promise rejection:", event.reason);
    reportSecurityEvent("unhandled-rejection", { reason: String(event.reason) });
});
```
