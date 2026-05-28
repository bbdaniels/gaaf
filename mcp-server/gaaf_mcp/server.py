"""GAAF MCP server entry point."""
from __future__ import annotations

import logging
from typing import Any

from mcp.server.fastmcp import FastMCP

from .tools.citations import crossref_lookup as _crossref_lookup
from .tools.validators import validate_bib as _validate_bib

logging.basicConfig(level=logging.INFO, format="[gaaf-mcp] %(message)s")
log = logging.getLogger("gaaf_mcp")

server = FastMCP("gaaf")


@server.tool()
async def crossref_lookup(query: str, by: str = "title") -> dict[str, Any]:
    """Look up a work in Crossref by title (default) or DOI.

    Args:
        query: The title string or DOI to resolve.
        by:    "title" or "doi".

    Returns the top match (or up to 3 matches for title queries) with title,
    authors, year, venue, DOI, and a Crossref confidence score where
    applicable.
    """
    return await _crossref_lookup(query, by=by)


@server.tool()
def validate_bib(path: str) -> dict[str, Any]:
    """Parse a BibTeX file and report broken or incomplete entries.

    Args:
        path: Absolute path to the .bib file.

    Returns a report listing entries missing required fields (title, author,
    year), duplicate keys, and malformed entries.
    """
    return _validate_bib(path)


def main() -> None:
    """Run the MCP server over stdio."""
    server.run()


if __name__ == "__main__":
    main()
