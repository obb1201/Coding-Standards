# Coding Standards

The team's coding standards, one set per programming language.

## Languages

| Language | Standard |
| --- | --- |
| C# | [C# Coding Standard](C%23%20Coding%20Standard/SKILL.md) |

Add a row here when you add a new language standard.

## Contributing

1. Put each language's standard in its own folder or file, named after the language (for example `csharp/` or `javascript.md`).
2. Add the language to the table above.
3. Back each rule with a short reason and a code example.

## Updating a skill on claude.ai

Each language folder is a Claude skill. After you change one:

1. Run `powershell -ExecutionPolicy Bypass -File scripts/package-skills.ps1`. This writes `dist/<skill-name>.zip`.
2. On claude.ai, open Settings → Capabilities → Skills. Remove or turn off the old version of the skill, then upload the new zip.
