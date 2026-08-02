---
title: Feature Catalog
tags: [moc, features, planning]
status: draft
---

# Feature Catalog

Curated by studying the best open systems (see [[prior-art]]) and keeping what matters.
Prioritized **MoSCoW**. Sequencing lives in [[roadmap]].

## Must — the spine
- **[[gedcom|GEDCOM import/export]]** — the moat. Bring your tree, take it anywhere. (Borrowed: everyone; done best by webtrees/Gramps.)
- **[[person-profile|Person profile]]** — names, [[event|events]], facts, [[media]], [[source-citation|sources]] on one page.
- **[[family-tree-view|Interactive tree view]]** — pedigree, descendancy, hourglass. The signature UI. (Borrowed: Topola/family-chart rendering ideas — see [[tree-rendering]].)
- **[[sources-evidence|Sources & evidence]]** — citations as first-class. (Borrowed: Gramps.)
- **Add/edit relatives inline** — the core Hotwire loop; grandparent-simple.

## Should — makes it real
- **[[collaboration|Collaborative editing]]** — multiple family members, live updates. (Borrowed: webtrees collaboration.)
- **[[privacy-access|Privacy & access control]]** — living-person privacy, per-record visibility, share links. (Borrowed: webtrees privacy model — a standout feature.)
- **Search & discovery** — find a person fast; filter by place/date.
- **Relationship calculator** — "how am I related to X?" Pure traversal over [[relationship]]. (Borrowed: GeneWeb's relationship graphs.)
- **Timeline view** — a person's life events in order; a family's events interleaved.

## Could — delight & depth
- **Smart hints / matching** — suggest possible duplicates or matches across trees. (Borrowed: Ancestry's "shaky leaf," done privately/offline.) ✅ shipped as [[domain-model|DuplicateFinder/DuplicateHint]] + the `hints` review queue.
- **Reports & charts (PDF)** — printable pedigree/descendancy, family group sheets.
- **Place maps** — plot life events geographically (needs [[place]] coords).
- **Statistics dashboard** — "oldest ancestor", surname distribution, etc. (Borrowed: webtrees stats.)
- **Stories / narratives** — attach written stories to people (the "[[prior-art|Writebook]]"-style prose side).
- **[[note|Notes]] + a lightweight research log** — build the long-designed `Note` model
  (`notable` polymorphic) with one `research_task` flag standing in for Gramps' "To Do" note
  type; a tree-wide research-to-dos view is then just a filter, reusing the `hints`
  review-queue pattern. (Borrowed: Gramps' Notes + To Do gramplet.)
- **Place hierarchy** — a plain self-referential `parent_id` on [[place]] (single parent, no
  date-ranging) for grouping/drill-down by place. Deliberately lighter than Gramps' full
  `PlaceRef` model (parent + date range + hierarchy type) — see [[place]] "don't
  over-engineer a temporal gazetteer in v1". (Borrowed, simplified: Gramps' place hierarchy.)
- **"Verify the data" sanity checks** — non-blocking, configurable checks over the tree
  (implausible age at death, parent implausibly young/old at a child's birth, marriage
  before birth) that *suggest*, never enforce — a new hint type feeding the existing `hints`
  review queue, not a new UI paradigm. (Borrowed: Gramps' Tools → Utilities → Verify the Data.)
- **Tags** — free-form, color-coded tags attachable to any record ("DNA verified", "needs
  sourcing"). Lowest priority of this batch — not core evidence modeling. (Borrowed: Gramps'
  Tag system.)

## Won't-yet
- DNA matching, ethnicity estimates, native mobile apps, in-app chat. See [[roadmap]] Won't-yet.

## Guiding filter
A feature earns a place only if it serves [[vision]]: *own your roots*, *boringly solid*,
*for real people*, *honest about evidence*. When unsure, cut it.
