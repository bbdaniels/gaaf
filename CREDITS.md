# Credits and Attribution

## DAAF (parent project)

GAAF is an adaptation of the **Data Analyst Augmentation Framework (DAAF)**
for the Gemini ecosystem. DAAF is © Open Augments LLC and the DAAF
Contribution Community, released under LGPL-3.0-or-later.

- Upstream: https://github.com/DAAF-Contribution-Community/daaf
- Homepage: https://daaf.openaugments.org/

The following GAAF artifacts incorporate substantive content adapted from
DAAF:

- `GEMINI.md` — system-prompt identity and the Five Principles are adapted
  from DAAF's `CLAUDE.md`.
- `methodology/principles.md` — directly inspired by DAAF's principle
  framing.
- The `/discover`, `/plan`, `/acquire`, `/analyze`, `/synthesize`,
  `/disclose`, `/review` workflow arc mirrors DAAF's five-phase workflow.
- Citation-discipline and AI-disclosure conventions reflect DAAF's
  `agent_reference/CITATION_REFERENCE.md` and `AI_DISCLOSURE_REFERENCE.md`.

GAAF does not vendor or redistribute DAAF source code. Per LGPL-3.0
Section 5 (Combined Works), GAAF is an independent work that adapts DAAF's
research-discipline framework for a different runtime (Gemini CLI rather
than Claude Code). Users wanting the full DAAF experience on Claude Code
should install upstream DAAF directly.

## Gemini CLI

GAAF targets Google's open-source Gemini CLI:
https://github.com/google-gemini/gemini-cli (Apache-2.0).

## Other dependencies

- `mcp` (Python) — Anthropic, MIT
- `httpx` — Encode OSS, BSD-3-Clause
- `pybtex` — Andrey Golovizin, MIT

## Maintainer

Benjamin Daniels (bdaniels@g.harvard.edu).
