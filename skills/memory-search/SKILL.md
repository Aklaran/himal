---
name: memory-search
description: Search Annapurna's semantic memory (MEMORY.md, session logs, and Sanctuary knowledge base). Use when recalling past conversations, decisions, knowledge, or preferences.
---

# Memory Search

Search across Annapurna's knowledge base using the `memory_search` tool.

## Indexed Sources

1. **Core Memory** (`~/.openclaw/workspace/MEMORY.md`)
   - Identity, sacred boundaries, information about Aklaran

2. **Session Logs** (`~/.openclaw/workspace/memory/`)
   - Daily session logs (YYYY-MM-DD.md)
   - Discoveries, decisions, open threads

3. **Sanctuary** (`~/sanctuary/`)
   - `Atlas/` — knowledge maps and MOCs
   - `Calendar/` — time-bound notes
   - `Efforts/` — projects and active work
   - `Knowledge/` — learning domains

## When to Search

**Search memory before answering questions about:**
- Past conversations or decisions
- Aklaran's preferences or habits
- Prior work on projects
- Dates, events, or timelines
- People, places, or things previously discussed
- Technical knowledge captured in Sanctuary

## Usage

```
memory_search query:"<natural language or keywords>"
```

Optional: `maxResults:` (default 10)

Returns matching chunks with file paths, line numbers, and content.

### After Searching

If you need more context around a result:
```
read path:"<path from search result>" offset:<startLine>
```

## Commands

- `/memory-reindex` — Rebuild the search index
- `/memory-status` — Show index status and sources

## Search Tips

1. **Be specific** — "conversation about Bitwarden setup" > "passwords"
2. **Include context** — "decision about PKM structure" > "PKM"
3. **Check multiple results** — relevant info may span multiple files

## Search Mode

Currently using **keyword search** (BM25-style).

Set `OPENAI_API_KEY` environment variable to enable **hybrid semantic search** (70% vector similarity + 30% keyword matching).
