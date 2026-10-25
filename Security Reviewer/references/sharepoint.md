# SharePoint Online Security Rules (`SP-n`)

Site permissions and sharing, SPFx solutions, PnP scripts and Microsoft Graph access. Cite a rule as
`[A0N][SP-n]`. SPFx front-end code also follows `javascript.md`.

## Rules

### Permissions and sharing
- **SP-1** `[A01]` Grant permissions to groups, not to individual users. Avoid breaking inheritance unless
  there is a documented reason.
- **SP-2** `[A01]` Do not grant access with "Everyone" or "Everyone except external users" on sites that
  hold sensitive data.
- **SP-3** `[A01]` Limit external and anonymous ("Anyone") sharing for each site. Sharing links expire.
- **SP-4** `[A04]` Apply sensitivity labels and DLP to sites and libraries that hold sensitive data.

### Apps and API access
- **SP-5** `[A01]` App registrations request the smallest Graph or SharePoint scope. Prefer
  `Sites.Selected` to `Sites.ReadWrite.All` or `Sites.FullControl.All`.
- **SP-6** `[A07]` App-only access uses certificates or managed identity, not client secrets. The
  retired ACS app-only model (`AppRegNew.aspx`) is not used.
- **SP-7** `[A01]` SPFx API permission requests (`webApiPermissionRequests`) list only what the solution needs.
- **SP-8** `[A03]` SPFx packages pin npm versions and pass `npm audit`. Do not deploy them tenant-wide unless
  they are needed everywhere.

### Code and content
- **SP-9** `[A05]` Encode list item values before rendering them in SPFx, Script Editor replacements or JSON
  column formatting.
- **SP-10** `[A05]` Encode user values before putting them into CAML, KQL or REST filter queries.
- **SP-11** `[A04]` PnP PowerShell scripts never contain passwords or secrets. Use certificates or
  managed identity.
- **SP-12** `[A02]` Keep custom script turned off on sites.

### Monitoring
- **SP-13** `[A09]` Review the Purview audit log for sharing, permission and admin changes.
