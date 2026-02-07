# 🏔️ Himal

**The mountain beneath the peaks.**

Himal (हिमाल, Nepali for "mountain") is a collection of skills and extensions for [Pi](https://github.com/nicholasgasior/pi-coding-agent) that turn a base AI agent into one that can orchestrate subagents, review diffs, search semantic memory, take screenshots, and more.

Named peaks — like [Annapurna](https://github.com/Aklaran) — are specific agent identities built on Himal's foundation.

## What's Inside

### Skills (agent behaviors)

Skills are markdown instructions loaded into agent context. They shape *how* the agent thinks and acts.

| Skill | Description |
|-------|-------------|
| [orchestrator](skills/orchestrator/) | Subagent delegation — tier selection, TDD requirements, beads integration, timeout guidance |
| [screenshot](skills/screenshot/) | Headless browser screenshots for visual UI verification |
| [memory-search](skills/memory-search/) | Semantic memory search across knowledge bases and session logs |

### Extensions (platform capabilities)

Extensions add tools, commands, and UI to Pi. They give the platform new powers.

| Extension | Repo | Description |
|-----------|------|-------------|
| Sirdar | [Aklaran/sirdar](https://github.com/Aklaran/sirdar) | Multi-agent orchestration — spawn_agent, check_agents, budget tracking, git worktree isolation |
| Diff Review | [Aklaran/pi-diff](https://github.com/Aklaran/pi-diff) | TUI overlay for reviewing file changes with vim-style navigation |
| Vim Editor | [annapurna-himal/pi-vim-editor](https://github.com/annapurna-himal/pi-vim-editor) | Vim input mode for Pi's editor |
| Memory Search | [annapurna-himal/pi-memory-search](https://github.com/annapurna-himal/pi-memory-search) | Semantic search tool (BM25 + optional vector embeddings) |
| Memory Awareness | (included) | Tracks memory usage, provides `/memory` command |

### Shared Packages

| Package | Description |
|---------|-------------|
| [pi-diff-ui](https://github.com/Aklaran/pi-diff-ui) | Framework-agnostic diff rendering — used by both Diff Review and Sirdar |

## Install

```bash
git clone https://github.com/Aklaran/himal.git
cd himal
./install.sh
```

This will:
1. Copy skills into `~/.pi/agent/skills/`
2. Clone extension repos into `~/repos/` (if not already present)
3. Symlink extensions into `~/.pi/agent/extensions/`
4. Install dependencies for extensions that need them

### Prerequisites

- [Pi](https://github.com/nicholasgasior/pi-coding-agent) installed and configured
- Node.js 20+
- Git
- `pnpm` (for extensions with dependencies)
- `puppeteer-core` + Chromium (for screenshot skill)

## Architecture

```
~/.pi/agent/
├── skills/           ← agent behaviors (markdown)
│   ├── orchestrator/
│   ├── screenshot/
│   └── memory-search/
└── extensions/       ← platform capabilities (TypeScript)
    ├── orchestrator  → ~/repos/orchestrator/
    ├── diff-review   → ~/repos/diff-review/
    ├── vim-editor    → ~/repos/pi-vim-editor/
    ├── memory-search → ~/repos/pi-memory-search/
    └── memory-awareness/
```

Skills are portable prompt instructions — they could work in any agent framework that supports system prompts. Extensions are Pi-specific and require the Pi SDK.

## Philosophy

Extensions give the **platform** new powers. Skills give the **agent** new patterns. Together they're the mountain.

## License

MIT
