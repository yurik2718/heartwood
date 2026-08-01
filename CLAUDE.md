# CLAUDE.md — Claude Code entry point for Heartwood

> Read [`AGENTS.md`](AGENTS.md) first — it has the non-negotiable TDD workflow, the vanilla
> Rails 8 stack constraints, and the full pointer map into [`docs/`](docs/index.md). This file
> exists alongside it only to keep the handful of strategic priorities below visible to every
> session without having to rediscover them — the actual design decisions live in the vault
> (`docs/`), not here. If this file and the vault ever disagree, the vault wins; fix this file.

## What Heartwood is betting on

Open-source, self-hostable family-tree platform, AGPL core + optional paid hosting. The bet:
a canonical, boring, vanilla Rails 8 app can out-UX the dated open-source genealogy tools
(webtrees, Gramps) while staying as open as they are. Full detail: [[vision]] and
[[positioning]] in the vault.

## Key strategic features & tasks — keep these front of mind

These three are the product's actual differentiation, not just items on a backlog — every
feature decision should be checked against them (per [[positioning]]'s own filter).

### 1. Bilingual from day one — a precondition, not a nicety
Shipping English + Russian now, on generic Rails I18n (`t()`, `config/locales/*.yml`), because
"popular open-source app worldwide" requires people who don't read English to use it
comfortably. Every new user-facing string goes through I18n; no hardcoded copy. See
[[vision]] principle 3, [[positioning]] "why we win" #5.

### 2. The Gramps round-trip — the flagship interop story
Not just generic GEDCOM support: **Heartwood cloud collaboration ↔ Gramps local power-tools**
is meant to feel like one workflow.

```
Family fills in the tree together in Heartwood (cloud, live, multiple relatives)
        → export GEDCOM 7.0 / GEDZIP
        → open in Gramps (free, local, offline — reports, DNA tools, custom filters)
        → edit further there
        → re-import into Heartwood, merges back into the shared cloud tree
```

We take Gramps' *mechanics* (evidence-first sources/citations, the domain depth) and rebuild
them in a canonical Rails 8 app that is more convenient and intuitive than Gramps' desktop UI
— but we deliberately do **not** chase feature-parity with Gramps' deep power-user tooling
(reports, DNA, plugins). We hand off to real Gramps for that instead of rebuilding it badly.
Full detail: [[gedcom]] "The Gramps round-trip", [[import-export]], [[positioning]].

### 3. Multi-person collaboration on one tree, two distinct mechanisms
- **Edit invites** (shipped — see [[collaboration]]): a per-tree `join_code` link;
  whoever joins through it gets an editor/viewer role and a real account.
- **Read-only share links** (not yet built — see [[privacy-access]] "Share links"): a
  *different* mechanism — no account, no membership, just a token that opens one person or
  branch as a view, for the relative who just wants to look. Don't conflate the two or
  overload `Tree#join_code` for this; it needs its own model.

## Where to actually go next
- Full vault map: [`docs/index.md`](docs/index.md)
- Workflow rules (TDD, stack constraints, how to run tests here): [`AGENTS.md`](AGENTS.md)
- What's shipped vs deferred on collaboration specifically: [`docs/features/collaboration.md`](docs/features/collaboration.md)
