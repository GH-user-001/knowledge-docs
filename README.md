# Persistent Wiki for Compounding Knowledge

This repository implements a three-layer knowledge workflow:

- `raw/`: immutable source material (articles, papers, transcripts, images).
- `wiki/`: LLM-maintained markdown wiki (summaries, entities, concepts, analyses).
- `AGENTS.md`: schema and operating contract for the LLM maintainer.

## Quick Start

1. Put new source files in `raw/sources/`.
2. Ask your coding agent to ingest one source at a time.
3. Review updated pages in `wiki/` (especially `wiki/index.md` and touched entity/concept pages).
4. Ask questions against the wiki and optionally file the output under `wiki/analyses/`.
5. Run `bash scripts/wiki-lint.sh` periodically to catch structural issues.

## Suggested Prompts

- `Ingest raw/sources/<file>.md into the wiki.`
- `Answer this question using wiki pages, then save the answer as a new analysis page.`
- `Run a wiki lint pass and fix broken links or missing cross-references.`

## Core Files

- `AGENTS.md`: wiki maintenance policy and workflows.
- `wiki/index.md`: content-oriented map of all pages.
- `wiki/log.md`: append-only chronological operations log.
- `wiki/_templates/`: templates for repeatable page structure.
