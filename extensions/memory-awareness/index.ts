import type { ExtensionAPI } from "@mariozechner/pi-coding-agent";

/**
 * Memory Awareness Extension for Annapurna
 * 
 * Enhances memory integration:
 * - Tracks memory_search usage and results
 * - Logs memory operations to session for debugging
 * - Provides /memory command for quick status
 */

interface MemoryStats {
  searches: number;
  lastQuery: string | null;
  lastResultCount: number;
  indexedPaths: string[];
}

export default function memoryAwareness(pi: ExtensionAPI) {
  const stats: MemoryStats = {
    searches: 0,
    lastQuery: null,
    lastResultCount: 0,
    indexedPaths: [
      "~/.openclaw/workspace/MEMORY.md",
      "~/.openclaw/workspace/memory/",
      "~/sanctuary/",
    ],
  };

  // Track memory search usage
  pi.on("tool_result", async (event, ctx) => {
    if (event.toolName === "memory_search") {
      stats.searches++;
      
      // Parse the result to get stats
      try {
        const content = event.result.content;
        if (content && content[0]?.type === "text") {
          const data = JSON.parse(content[0].text);
          stats.lastResultCount = data.results?.length ?? 0;
          
          // Log memory search for debugging (only in verbose mode)
          if (process.env.ANNAPURNA_MEMORY_DEBUG) {
            ctx.ui.notify(
              `Memory search: ${stats.lastResultCount} results`,
              "info"
            );
          }
        }
      } catch {
        // Ignore parse errors
      }
    }
  });

  // Track the query from tool_call
  pi.on("tool_call", async (event) => {
    if (event.toolName === "memory_search") {
      stats.lastQuery = event.input?.query ?? null;
    }
  });

  // Register /memory command for status
  pi.registerCommand("memory", {
    description: "Show memory search status and indexed paths",
    handler: async (_args, ctx) => {
      const lines = [
        "📚 Memory Search Status",
        "",
        `Searches this session: ${stats.searches}`,
        `Last query: ${stats.lastQuery ?? "(none)"}`,
        `Last result count: ${stats.lastResultCount}`,
        "",
        "Indexed paths:",
        ...stats.indexedPaths.map((p) => `  • ${p}`),
        "",
        "Tip: Use memory_search tool to query your knowledge base.",
      ];
      ctx.ui.notify(lines.join("\n"), "info");
    },
  });

  // Register /memory-sync command to trigger a sync
  pi.registerCommand("memory-sync", {
    description: "Trigger memory index sync (re-index changed files)",
    handler: async (_args, ctx) => {
      ctx.ui.notify(
        "Memory sync: OpenClaw handles this automatically via file watching.\n" +
        "Changes to Sanctuary and memory files are indexed within ~2 seconds.",
        "info"
      );
    },
  });

  // Notify on session start
  pi.on("session_start", async (_event, ctx) => {
    // Reset stats on new session
    stats.searches = 0;
    stats.lastQuery = null;
    stats.lastResultCount = 0;
    
    // Optional: show memory status on session start
    if (process.env.ANNAPURNA_MEMORY_DEBUG) {
      ctx.ui.setStatus("memory", "📚 Memory indexed");
    }
  });
}
