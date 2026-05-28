# GAAF — Gemini Analyst Augmentation Framework

A research harness for students using Google Gemini in VSCode. GAAF gives a
quantitative-research scaffold (identification thinking, citation discipline,
reproducibility, AI disclosure) on top of Gemini CLI + the Gemini Code Assist
VSCode extension.

GAAF is an **adaptation** of the
[Data Analyst Augmentation Framework (DAAF)](https://daaf.openaugments.org/)
for the Gemini ecosystem. DAAF targets Claude Code; GAAF targets Gemini CLI
and Antigravity. See [`CREDITS.md`](CREDITS.md) for attribution.

## What you get

- `GEMINI.md` — research-grade system prompt loaded automatically
- `.gemini/commands/` — slash commands for the research workflow:
  `/discover`, `/plan`, `/acquire`, `/analyze`, `/synthesize`, `/cite-check`,
  `/disclose`, `/review`
- `.gemini/skills/` — agent skills (data-scientist, polars, statsmodels,
  pyfixest, plotnine, …) loaded on demand
- `mcp-server/` — local MCP server for deterministic checks (Crossref
  lookups, bibliography validation)
- `methodology/` — econ-flavored methodology references (identification,
  replication, citations, writing)
- `install.sh` / `install.ps1` — one-shot setup for macOS/Linux and Windows
- `.devcontainer/` — optional VSCode dev container for isolated environments

## Quick start (students)

### macOS / Linux

```bash
git clone https://github.com/bbdaniels/gaaf.git
cd gaaf
./install.sh
code .
```

### Windows (PowerShell)

```powershell
git clone https://github.com/bbdaniels/gaaf.git
cd gaaf
.\install.ps1
code .
```

The installer:

1. Checks Node 20+, Python 3.11+, git
2. Installs Gemini CLI (`npm i -g @google/gemini-cli`)
3. Installs the Gemini Code Assist VSCode extension
4. Installs the local MCP server via `pipx`
5. Prompts `gemini auth login`

After install, in VSCode press `Ctrl/Cmd+Shift+P` → "Gemini: Open Chat" or run
`gemini` in the integrated terminal.

## Verifying the install

```bash
./scripts/doctor.sh        # macOS/Linux
.\scripts\doctor.ps1       # Windows
```

Then in a `gemini` session: type `/help`. You should see GAAF commands
(`/discover`, `/plan`, …) and skills should list under `/skills list`.

## Project layout

```
gaaf/
├── GEMINI.md                  # system prompt (auto-loaded)
├── .gemini/
│   ├── settings.json          # MCP server registration
│   ├── commands/              # slash commands (TOML)
│   └── skills/                # agent skills (on-demand)
├── .vscode/
│   └── extensions.json        # pins Gemini Code Assist
├── .devcontainer/             # optional Docker isolation
├── methodology/               # markdown references
├── mcp-server/                # Python MCP server
└── scripts/                   # install, doctor, sync helpers
```

## Customizing for your project

GAAF is a **starter**. Copy the repo, then:

1. Edit `GEMINI.md` to add project-specific context (data sources, hypotheses)
2. Add commands in `.gemini/commands/your-team/foo.toml` (becomes `/your-team:foo`)
3. Add skills in `.gemini/skills/your-skill/SKILL.md`
4. Add MCP tools in `mcp-server/gaaf_mcp/tools/`

## License

LGPL-3.0 (inherited from DAAF). See [`LICENSE`](LICENSE).

## Credits

GAAF adapts DAAF (Open Augments LLC, LGPL-3.0). See [`CREDITS.md`](CREDITS.md)
for full attribution and a list of files derived from DAAF upstream.
