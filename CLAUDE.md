# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

My resume. `README.md` is the resume itself, in Markdown; the flake renders it to `resume.pdf` with pandoc (`packages.resume`, LaTeX from `texliveSmall`), using `meta.yml` for pandoc metadata (margins, no page numbers).

## Commands

```bash
just build   # nix build .#resume; the PDF is ./result
nix fmt      # alejandra, through the pre-commit hooks
```

## Publishing

Every push to `main` publishes: `release.yml` builds the PDF, tags `v0.0.<run number>`, creates that release, and replaces the `latest` release and tag. `zx.dev/resume` redirects to `latest`'s `resume.pdf`, so a merge is live within minutes. There's no preview; build locally and look at the PDF before opening a PR, especially for page breaks after content changes.

## Writing

- The content is about me and is public. Don't invent or embellish: no new metrics, technologies, titles or dates. Rewording what's there is fine; new facts come from me.
- Don't add personal details beyond what's there (phone number, address).
- Keep the existing structure: a summary, then sections with `###` entries and bullets.

## Repo and GitHub

Managed by stackptr/ops: settings, rulesets and environments are changed there, not in the UI. PRs are squash-merged with the PR title as the commit subject; merged branches are deleted.

- My PRs: `approve.yml` (stackptr/actions's reusable workflow, from the main-only `approve` environment) approves them as teleoid; turn on auto-merge and they merge.
- Agents' PRs (teleomycete, from `agents/**` only): they need my approval of the latest push.
- `release.yml` pins its actions by SHA; it has `contents: write`, so keep them pinned. Agents can't change `.github/workflows/`.
- No repository-level secrets: stackptr/ops's daily check fails if one appears. A workflow that needs a secret gets a main-only environment in ops.

## Branching

- Short-lived branches off `main`, named `type-short-slug`: `type` is `feat`, `fix`, `chore` or `refactor`, the slug 2 to 4 words (e.g. `fix-date-format`). Cloud sessions name branches this way, not `claude/…`.
- PR title: `type: short description`. PR description: what changed and what to check in the PDF.

## Committing

- My git config requires signing, which you can't do (it needs an interactive GPG unlock). For commands that create commits, use `git -c commit.gpgsign=false …`, and never change git config to disable signing. Add a `Co-Authored-By:` trailer identifying yourself.
- Don't merge a PR, or create or move a tag, unless asked: a merge publishes.

## Code style

- All files end with a newline.
