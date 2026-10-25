# Power Platform Security Rules (`PP-n`)

Power Apps (canvas and model-driven), Power Automate, Dataverse, Power Pages and environment
administration. Applies to code (Power Fx, flow JSON), exported solutions and design descriptions. Cite a
rule as `[A0N][PP-n]`.

For flow limits and design gotchas that are not security issues, see the `power-automate-constraints` skill.

## Rules

### Environments and governance
- **PP-1** `[A02]` Keep separate Dev, Test and Prod environments. Makers do not build in Prod, and the default
  environment is not used for business apps.
- **PP-2** `[A02]` Every environment has a DLP policy that separates business and non-business connectors and
  blocks connectors that are not needed.
- **PP-3** `[A01]` Use security groups to limit who can access each environment.

### Data access (Dataverse)
- **PP-4** `[A01]` Security roles grant the lowest access level (User, then Business Unit, then
  Organization) that the task needs.
- **PP-5** `[A01]` Use column security profiles for sensitive columns.
- **PP-6** `[A01]` A canvas app hiding a control or filtering a gallery is not access control. Enforce
  access in Dataverse or the data source.

### Connections and flows
- **PP-7** `[A01]` Know whose identity each connection uses. Do not share a maker's or admin's connection
  with users who should not have that access.
- **PP-8** `[A04]` Store secrets in Key Vault–backed (secret) environment variables. Never put them in flow
  actions, Power Fx or plain environment variables.
- **PP-9** `[A09]` Turn on secure inputs and outputs for actions that handle secrets or personal data, so the
  values do not appear in run history.
- **PP-10** `[A01]` HTTP-triggered flows check the caller (OAuth or limited trigger access). Never rely on a
  secret URL alone.
- **PP-11** `[A05]` Do not build FetchXML, OData filters or SQL from user input without encoding the values.
- **PP-12** `[A07]` Run flows and solution connections under service accounts or service principals, not
  personal accounts.

### Power Pages
- **PP-13** `[A01]` Table permissions are on and scoped (Global, Contact, Account, Parent). Never grant
  Global access to anonymous users.
- **PP-14** `[A01]` Web API and list settings expose only the columns that are needed.

### Monitoring
- **PP-15** `[A09]` Turn on Dataverse auditing for sensitive tables. Review the admin center and Purview
  audit logs.
- **PP-16** `[A06]` Review each Copilot Studio agent's knowledge sources, actions and authentication before
  you publish it.
