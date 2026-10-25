# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Purpose

This repository holds coding standards for different programming languages. It is documentation, not an application, so there are no build, lint or test commands.

## Working rules

- Write in clear, simple English, in code comments, docs and replies.
- If a requirement is unclear, ask the user key questions before proceeding.
- Record changes in the change log in the `docs/` folder (`docs/CHANGELOG.md`). Add an entry whenever you make a notable change.

## Layout

Each language has its own folder, such as `C# Coding Standard/`. A folder uses the Claude skill format: `SKILL.md`, which holds the frontmatter and the write/review workflow, plus `references/*.md` with the full numbered rules. Rules are cited by number (`§1.N`) or CodeQL rule ID, so renumbering a rule breaks citations in past reviews.

`C# Coding Standard/` is a copy of the synced `csharp-code-reviewer` skill. `JavaScript Coding Standard/` replaces the synced `javascript-code-reviewer` skill (same skill name). An edit here does not reach the live skill until it is uploaded again on claude.ai.

In `JavaScript Coding Standard/`, `references/core-rules.md` (§1–§24) holds the base rules and `references/team-rules.md` (§25 and up) holds the team's additions. A core rule wins over a team rule. Outdated core rules are marked **Retired** instead of deleted, so their numbers stay stable. Never name the outside guide the core rules came from, in any file.

## Syncing skills to claude.ai

Every skill folder must always be ready to upload. After any change to a skill folder:

1. Run `powershell -ExecutionPolicy Bypass -File scripts/package-skills.ps1`. It checks the frontmatter and writes `dist/<skill-name>.zip`.
2. Tell the user the zip path, so they can upload it on claude.ai (Settings → Capabilities → Skills). Do not upload it yourself.

Do not build the zip with Git Bash `tar`. It writes a tar archive with a `.zip` name, and claude.ai rejects it as "Invalid zip file".

## Related skills

This environment has user-level skills that encode the team's standards: `csharp-code-reviewer` (C#), `javascript-code-reviewer` (browser JS/jQuery) and `security-reviewer` (OWASP Top 10:2025 for C# and JS). When writing or editing a standard for one of those languages, read the matching skill and keep the two consistent. If they disagree, flag it rather than silently picking one.
