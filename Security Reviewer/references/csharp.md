# C# Security Rules (`CS-n`)

Language-level rules for C#. Framework and hosting rules are in `dotnet.md`. Cite a rule as `[A0N][CS-n]`.
Code examples for most rules are in `owasp-top-10-2025.md`.

Style rules (naming, braces, `var`) come from the `csharp-code-reviewer` skill. This file covers security only.

## Rules

- **CS-1** `[A05]` Never build SQL, LDAP, XPath or shell commands by concatenating strings. Use parameters or
  a safe API.
- **CS-2** `[A08]` Never deserialize untrusted data with `BinaryFormatter`, `NetDataContractSerializer`,
  `SoapFormatter` or Newtonsoft `TypeNameHandling` other than `None`. Use `System.Text.Json`.
- **CS-3** `[A04]` Hash passwords with `PasswordHasher<T>` or PBKDF2 (`Rfc2898DeriveBytes.Pbkdf2`). Never
  use MD5, SHA1 or plain SHA256 for passwords.
- **CS-4** `[A04]` Use `RandomNumberGenerator` for tokens, keys and reset codes. Never use `System.Random` or
  `Guid.NewGuid()` for security.
- **CS-5** `[A04]` Encrypt with `AesGcm`. Never use ECB mode, a fixed IV, DES or 3DES.
- **CS-6** `[A01]` Build file paths with `Path.GetFullPath` and confirm the result stays inside the allowed
  folder. This blocks path traversal (`..\`).
- **CS-7** `[A05]` Do not start processes (`Process.Start`) with user input in the file name or arguments.
- **CS-8** `[A05]` Turn off DTD processing in XML readers (`DtdProcessing.Prohibit`). This blocks XXE.
- **CS-9** `[A04]` Compare secrets and MACs with `CryptographicOperations.FixedTimeEquals`, not `==`.
- **CS-10** `[A10]` Catch specific exceptions. A failed security check must deny, never fall through to allow.
- **CS-11** `[A04]` Never hardcode secrets or connection strings. Read them from configuration (see `NET-3`).
- **CS-12** `[A05]` Validate regex input lengths and set a match timeout. This prevents ReDoS.
