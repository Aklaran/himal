# Himal (हिमाल)

Skills and extensions for [Pi](https://github.com/badlogic/pi-mono) agents. One install script sets up multi-agent orchestration, diff review, semantic memory, vim editing, and more.

## Skills

Markdown instructions loaded into agent context. Portable to any framework that supports system prompts.

| Skill | Description |
|-------|-------------|
| [orchestrator](skills/orchestrator/) | Subagent delegation — tier selection, TDD requirements, timeout guidance |
| [screenshot](skills/screenshot/) | Headless browser screenshots for visual UI verification |
| [memory-search](skills/memory-search/) | Semantic memory search across knowledge bases and session logs |

## Extensions

TypeScript plugins that add tools, commands, and UI to Pi.

| Extension | Repo | Description |
|-----------|------|-------------|
| Sirdar | [Aklaran/sirdar](https://github.com/Aklaran/sirdar) | Multi-agent orchestration with budget tracking and git worktree isolation |
| Diff Review | [Aklaran/pi-diff](https://github.com/Aklaran/pi-diff) | TUI overlay for reviewing file changes with vim-style navigation |
| Vim Editor | [annapurna-himal/pi-vim-editor](https://github.com/annapurna-himal/pi-vim-editor) | Vim input mode for Pi's editor |
| Memory Search | [annapurna-himal/pi-memory-search](https://github.com/annapurna-himal/pi-memory-search) | Semantic search (BM25 + optional vector embeddings) |
| Memory Awareness | (included) | Tracks memory usage, provides `/memory` command |

## Shared Packages

| Package | Description |
|---------|-------------|
| [pi-diff-ui](https://github.com/Aklaran/pi-diff-ui) | Framework-agnostic diff rendering — used by both Diff Review and Sirdar |

## Install

```bash
git clone https://github.com/Aklaran/himal.git
cd himal
./install.sh
```

This copies skills into `~/.pi/agent/skills/`, clones extension repos, symlinks them into `~/.pi/agent/extensions/`, and installs dependencies.

### Prerequisites

- [Pi](https://github.com/badlogic/pi-mono)
- Node.js 20+
- Git, `pnpm`
- `puppeteer-core` + Chromium (for screenshot skill)

## Layout

```
~/.pi/agent/
├── skills/           ← markdown (agent behaviors)
│   ├── orchestrator/
│   ├── screenshot/
│   └── memory-search/
└── extensions/       ← TypeScript (platform capabilities)
    ├── orchestrator  → ~/repos/orchestrator/
    ├── diff-review   → ~/repos/diff-review/
    ├── vim-editor    → ~/repos/pi-vim-editor/
    ├── memory-search → ~/repos/pi-memory-search/
    └── memory-awareness/
```

## License

MIT
