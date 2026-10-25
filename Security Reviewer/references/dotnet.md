# .NET / ASP.NET Core Security Rules (`NET-n`)

Framework, configuration and hosting rules. Language-level rules are in `csharp.md`. Cite a rule as
`[A0N][NET-n]`.

## Rules

### Authentication and sessions
- **NET-1** `[A07]` Use ASP.NET Core Identity or Microsoft Entra ID (Microsoft.Identity.Web). Do not write your
  own login or token logic.
- **NET-2** `[A07]` Cookies are `HttpOnly`, `Secure` and `SameSite=Strict` (or `Lax` when needed). Sessions
  end on logout and after an idle timeout.

### Secrets and configuration
- **NET-3** `[A04]` Secrets live in Key Vault or user secrets (development only). Never put them in
  `appsettings.json`, `web.config` or source control.
- **NET-4** `[A02]` Outside development, use `UseExceptionHandler` and turn off the developer exception page
  and detailed errors.
- **NET-5** `[A02]` Use HTTPS redirection and HSTS. Add `X-Content-Type-Options`, a Content Security Policy
  and `frame-ancestors`. Remove the `Server` and `X-Powered-By` headers.
- **NET-6** `[A02]` CORS allows only named origins. Never combine `AllowAnyOrigin` with credentials.

### Authorization and input
- **NET-7** `[A01]` Set a fallback policy that requires authentication. Use `[AllowAnonymous]` only where needed.
- **NET-8** `[A01]` Check resource ownership with policy-based or resource-based authorization (IDOR).
- **NET-9** `[A01]` Use antiforgery tokens on cookie-authenticated forms and state-changing endpoints.
- **NET-10** `[A05]` Bind input to DTOs, not entities. This prevents over-posting (mass assignment).
- **NET-11** `[A06]` Rate-limit login, reset, OTP and other costly endpoints with `AddRateLimiter`.
- **NET-12** `[A06]` For file uploads, check size, extension and content. Store files outside the web root
  under generated names.

### Dependencies, logging and hosting
- **NET-13** `[A03]` Pin NuGet versions, use a lock file and run `dotnet list package --vulnerable` in CI.
- **NET-14** `[A09]` Log auth failures and admin actions with `ILogger`. Never log secrets, tokens or personal data.
- **NET-15** `[A02]` Apps in Azure use managed identity to reach Azure resources, not stored keys.
