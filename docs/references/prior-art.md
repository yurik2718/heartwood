---
title: Prior Art — what we learn & borrow
tags: [reference, research]
status: stable
---

# Prior Art — what we learn from, and exactly what we take

Honest map of who does what well. Ties into [[features-index]].

## The house style — build it as if DHH and 37signals made it

For Rails/Hotwire/CSS architecture specifically (not genealogy domain logic), the standard
isn't "get inspired by" — it's **read the actual source of the three reference apps and base
the code and the architectural decisions on it**, the same way a real 37signals app would be
built. Cloned locally at `~/dhh-references/`:

- **once-campfire** (MIT) and **Writebook** (MIT) — read their actual controllers, models,
  views, and CSS files, not just screenshots. Our `.btn`/`.input`/`.avatar`/icon primitives,
  the OKLCH color-token system, the member-row + invite-link shape on
  `/tree_memberships` — all adapted line-by-line from these two. Freely copy structure,
  naming, and CSS mechanics from them; both are MIT so this is straightforwardly fine.
- **fizzy** — reference for *style and technique only* (e.g. the mask-image icon system,
  reimplemented from scratch, not copy-pasted). Its license (37signals' "O'Saasy License")
  has a SaaS non-compete clause, so **no literal assets or code from fizzy ship in this
  repo** — see `app/assets/images/NOTICE.md` for exactly which icons came from campfire
  instead, and why.
- When the three references are silent on something (there's no "complex Writebook for
  genealogy"), extend their patterns in their own idiom rather than reaching for an
  unrelated convention — see the "Honest note" below.

## Genealogy domain & UX (study the model, not the code)
- **webtrees** (PHP) — the gold standard of web genealogy. **Take:** collaboration model,
  the excellent **privacy/living-person system** ([[privacy-access]]), full GEDCOM handling,
  statistics. The bar for features.
- **Gramps / Gramps Web** (Python) — best desktop data model. **Take:** evidence-first design —
  sources/citations/confidence as first-class ([[sources-evidence]], [[source-citation]]),
  events-over-columns ([[event]]).
- **GeneWeb** (OCaml) — **Take:** relationship-calculator / relationship-graph ideas
  ([[relationship]]).
- **Liberu Genealogy** (Laravel/PHP) — **Take:** sanity-check on a modern MVC implementation
  of the same domain.

## Tree rendering (the JS we'll wrap in Stimulus — see [[tree-rendering]])
- **donatso/family-chart** (d3, MIT, vanilla JS) — **Take:** interaction model (zoom/pan,
  node styling); closest to drop-in for our [[adr/0005-tree-rendering-svg-stimulus]] approach.
- **PeWu/topola** (d3, TS) — **Take:** the chart-type taxonomy (ancestors / descendants /
  hourglass / relatives) for [[family-tree-view]]; proven on real trees (webtrees addon).
- **BenPortner/js_family_tree** (d3-dag) — **Take:** handling genealogy as a true multi-parent
  DAG.

## Other Rails / Hotwire / SaaS patterns (lighter touch — take the idea, not the source)
- **Maybe** (`maybe-finance`, MIT) — **Take:** modern, complex Rails+Hotwire patterns. ⚠️ Uses
  Tailwind + Postgres — ignore those; we stay vanilla ([[stack]]).
- **Solidus / Spree** — **Take:** open-core **Rails Engine** modularity for our [[open-core]]
  split.
- **Bullet Train** — **Take:** SaaS infra patterns — teams, roles, billing, [[multi-tenancy]].

## Honest note
No single project is a "complex Writebook for genealogy" — the genealogy *domain* (tree
rendering, GEDCOM, sources/evidence) has no canonical Rails precedent, so that part is
trailblazed, borrowing *ideas* widely from webtrees/Gramps/GeneWeb rather than their code.
The Rails/Hotwire/CSS *architecture* is the opposite: it has a real canonical precedent
(once-campfire + Writebook), so that part is built directly from their source, per "The
house style" above — not reinvented.
