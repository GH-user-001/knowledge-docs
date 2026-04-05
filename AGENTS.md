# Wiki Maintenance Schema

This file defines how the LLM must maintain this repository as a persistent, compounding knowledge wiki.

## Mission

Maintain a high-signal markdown wiki that accumulates synthesized knowledge over time.  
Do not re-derive everything from raw sources on every query. Keep the wiki current instead.

## Layer Contract

1. `raw/` is immutable source-of-truth input.
2. `wiki/` is mutable, LLM-maintained synthesis output.
3. `AGENTS.md` is the operating schema and must be followed for every ingest, query, and lint task.

## Mutability Rules

- Never edit files in `raw/`.
- Create and update files in `wiki/`.
- Keep `wiki/log.md` append-only.
- Keep `wiki/index.md` current after every material wiki change.

## Directory Contract

- `raw/sources/`: source documents to ingest.
- `raw/assets/`: source images or binary attachments.
- `wiki/sources/`: one page per ingested source.
- `wiki/entities/`: pages for people, orgs, projects, places, etc.
- `wiki/concepts/`: pages for ideas, methods, frameworks, themes.
- `wiki/analyses/`: filed answers, comparisons, briefings, generated artifacts.
- `wiki/index.md`: catalog of wiki pages.
- `wiki/log.md`: chronological operations log.
- `wiki/_templates/`: page skeletons for consistent structure.

## Naming and Linking

- Use lowercase kebab-case filenames.
- Use Obsidian wikilinks for internal references.
- Use root-relative wiki links only, e.g. `[[entities/jane-doe]]`, `[[concepts/bayesian-updating]]`.
- Every substantive page should link to at least one other page and be linked from at least one page.

## Frontmatter Standard

All wiki content pages (except `index.md`, `log.md`, and directory `README.md` files) should have YAML frontmatter with:

- `title`
- `type` (`source`, `entity`, `concept`, `analysis`, `overview`)
- `status` (`draft`, `active`, `archived`)
- `updated_at` (`YYYY-MM-DD`)
- `tags` (list)

Optional but recommended:

- `sources` (list of source page links)
- `confidence` (`low`, `medium`, `high`)
- `supersedes` / `superseded_by`

## Operations

### Ingest

When asked to ingest a source:

1. Read the source from `raw/sources/` (and related `raw/assets/` when relevant).
2. Create or update a source page in `wiki/sources/`.
3. Update impacted `wiki/entities/` pages.
4. Update impacted `wiki/concepts/` pages.
5. Add contradictions/supersessions where new evidence conflicts with prior claims.
6. Update `wiki/index.md` with any new pages and revised one-line summaries.
7. Append a log entry to `wiki/log.md` using the required heading format.

Required log heading format:

`## [YYYY-MM-DD] ingest | <source-title>`

### Query

When asked a question:

1. Read `wiki/index.md` first to locate relevant pages.
2. Read only the needed wiki pages.
3. Synthesize an answer grounded in wiki content, citing wiki page links.
4. If requested (or clearly useful), save the answer as `wiki/analyses/<topic>.md`.
5. If a new analysis page is created, update `wiki/index.md` and append a log entry:
   `## [YYYY-MM-DD] query | <question-or-analysis-title>`

### Lint

When asked to lint the wiki:

1. Check for broken wikilinks.
2. Find orphan pages (no inbound links).
3. Flag stale or superseded claims.
4. Identify recurring terms that deserve dedicated concept/entity pages.
5. Propose high-value source gaps.
6. Record the lint result in `wiki/log.md`:
   `## [YYYY-MM-DD] lint | wiki health check`

## Contradiction Protocol

When newer evidence conflicts with existing claims:

1. Keep both claims visible with provenance.
2. Mark prior claim as superseded or contested.
3. Link both relevant source pages.
4. Update affected concept/entity summaries to reflect uncertainty explicitly.

## Quality Bar

- Prefer explicit traceability over polished prose.
- Keep sections concise and skimmable.
- Capture uncertainty and confidence level.
- Avoid duplicating long passages; synthesize and link instead.
- Keep cross-references up to date in the same edit pass.
