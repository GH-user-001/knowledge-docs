---
title: "Wiki Overview"
type: overview
status: active
updated_at: 2026-04-05
tags:
  - overview
  - meta
---

# Scope

Persistent, LLM-maintained knowledge wiki built from curated raw sources.

# Current Thesis

The wiki should become more useful over time by accumulating synthesis, cross-links, and contradiction tracking instead of re-deriving context per query.

# Working Principles

- `raw/` is immutable source of truth.
- `wiki/` is continuously maintained synthesis.
- `index.md` and `log.md` are always updated as part of operations.

# Next Steps

- Add first source to `raw/sources/`.
- Run an ingest pass to create the first `wiki/sources/` page.
- Expand entities and concepts from that ingest.
