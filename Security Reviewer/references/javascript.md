# JavaScript Security Rules (`JS-n`)

Browser JavaScript and jQuery, including D365 web resources and the browser side of SPFx. Cite a rule as
`[A0N][JS-n]`. Code examples are in `owasp-top-10-2025.md`.

`JS-1` to `JS-6` match §29.1–§29.6 in the `javascript-code-reviewer` skill. Keep the two in step.

## Rules

- **JS-1** `[A05]` Put untrusted text into the page with `textContent` or `.text()`. If HTML is required,
  clean it with DOMPurify first. (§29.1)
- **JS-2** `[A04]` Never put secrets in client code. Use HTTPS for every request. (§29.2)
- **JS-3** `[A07]` Never store auth tokens in `localStorage` or `sessionStorage`. (§29.3)
- **JS-4** `[A01]` Browser validation helps the user. It is not security, so the server must check again. (§29.4)
- **JS-5** `[A03]` Scripts loaded from a CDN use an exact version, `integrity` and `crossorigin`. (§29.5)
- **JS-6** `[A10]` Fail closed. A failed permission check means "not allowed". (§29.6)
- **JS-7** `[A05]` Never pass strings to `eval`, `new Function`, `setTimeout` or `setInterval`.
- **JS-8** `[A05]` Check URLs before you use them in `href`, `src` or `location`. Allow only `https:` and
  relative URLs, never `javascript:`.
- **JS-9** `[A08]` Check `event.origin` in `postMessage` handlers. Send messages to a named target origin,
  never `'*'`.
- **JS-10** `[A08]` Do not merge untrusted objects into other objects (`$.extend(true, ...)`, deep merge). This
  causes prototype pollution.
- **JS-11** `[A09]` Do not log tokens, passwords or personal data to the console.
