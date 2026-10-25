# Dynamics 365 Customer Engagement Security Rules (`D365-n`)

Dynamics 365 Customer Engagement apps (Sales, Customer Service, Field Service and others) on Dataverse.
Covers security model design, plugins, custom APIs, web resources and integrations. Cite a rule as
`[A0N][D365-n]`.

Plugins are C#, so also read `csharp.md`. Web resources are JavaScript, so also read `javascript.md`.
General Dataverse rules (security roles, column security, environments, DLP) are in `power-platform.md`.

## Rules

### Security model
- **D365-1** `[A01]` Design business units, teams and roles before you build. Use owner teams or access
  teams, not one-off record sharing.
- **D365-2** `[A01]` Do not give users System Administrator or System Customizer as a workaround.
- **D365-3** `[A01]` Hierarchy security and record sharing are intentional and documented. They can widen
  access without anyone noticing.

### Plugins and custom APIs
- **D365-4** `[A01]` Plugins that run as SYSTEM, or that impersonate another user, check that the calling
  user (`InitiatingUserId`) is allowed to do the action.
- **D365-5** `[A04]` Plugins read secrets from secure configuration or Key Vault–backed environment
  variables, never from unsecure configuration or code.
- **D365-6** `[A10]` Throw `InvalidPluginExecutionException` with a generic message. Trace the details with
  `ITracingService` and never show them to users.
- **D365-7** `[A01]` Custom APIs and custom actions set an execute privilege, so not every user can call them.
- **D365-8** `[A05]` Build QueryExpression or FetchXML values safely. Never concatenate user input into FetchXML.

### Web resources and client script
- **D365-9** `[A01]` Form scripts that hide fields or tabs are not access control. Use field security
  and roles.
- **D365-10** `[A05]` Encode data before putting it into HTML web resources (see `JS-1`).

### Integrations
- **D365-11** `[A07]` Integrations use application users (service principals) with their own roles. They do
  not use named user accounts.
- **D365-12** `[A04]` Service endpoints and webhooks use authentication. Payloads with personal data go only
  to trusted endpoints.

### Monitoring
- **D365-13** `[A09]` Turn on auditing for sensitive tables and columns and for user access. Set a log
  retention period.
