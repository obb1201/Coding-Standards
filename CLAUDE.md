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

`C# Coding Standard/` is a copy of the synced `csharp-code-reviewer` skill. An edit here does not reach the live skill until it is uploaded again on claude.ai.

## Related skills

This environment has user-level skills that encode the team's standards: `csharp-code-reviewer` (C#), `javascript-code-reviewer` (browser JS/jQuery) and `security-reviewer` (OWASP Top 10:2025 for C# and JS). When writing or editing a standard for one of those languages, read the matching skill and keep the two consistent. If they disagree, flag it rather than silently picking one.
