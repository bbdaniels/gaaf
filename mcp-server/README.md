# gaaf-mcp

Local MCP server for GAAF. Exposes deterministic research tools to Gemini CLI:

- `crossref_lookup` — resolve a title or DOI against the Crossref API
- `validate_bib` — parse a BibTeX file and report missing fields / malformed entries
- (more to come — see `gaaf_mcp/tools/`)

Installed by GAAF's `install.sh` / `install.ps1` via `pipx`. Registered in
`.gemini/settings.json` under `mcpServers.gaaf`.

## Manual install

```bash
pipx install /path/to/gaaf/mcp-server
gaaf-mcp --help   # sanity check
```

## Smoke test

```bash
echo '{"jsonrpc":"2.0","method":"initialize","id":1,"params":{"protocolVersion":"2024-11-05","capabilities":{},"clientInfo":{"name":"test","version":"0"}}}' | gaaf-mcp
```

Should return a JSON-RPC `result` with server info.

## Adding tools

1. Add a function in `gaaf_mcp/tools/your_tool.py` returning a dict.
2. Register it in `gaaf_mcp/server.py` with a `@server.tool()` decorator.
3. Reinstall: `pipx install --force /path/to/gaaf/mcp-server`.
4. Restart Gemini CLI.
