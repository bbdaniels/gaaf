"""Citation lookups via Crossref."""
from __future__ import annotations

from typing import Any

import httpx

CROSSREF = "https://api.crossref.org/works"
USER_AGENT = "gaaf-mcp/0.1 (https://github.com/bbdaniels/gaaf; mailto:research@example.org)"
TIMEOUT = httpx.Timeout(10.0, connect=5.0)


def _format_work(item: dict[str, Any]) -> dict[str, Any]:
    authors = [
        " ".join(filter(None, [a.get("given"), a.get("family")]))
        for a in item.get("author", [])
    ]
    year = None
    for key in ("published-print", "published-online", "issued", "created"):
        parts = item.get(key, {}).get("date-parts") or []
        if parts and parts[0]:
            year = parts[0][0]
            break
    return {
        "title": (item.get("title") or [""])[0],
        "authors": authors,
        "year": year,
        "venue": (item.get("container-title") or [""])[0],
        "doi": item.get("DOI"),
        "type": item.get("type"),
        "publisher": item.get("publisher"),
        "url": item.get("URL"),
    }


async def crossref_lookup(query: str, by: str = "title") -> dict[str, Any]:
    if by not in ("title", "doi"):
        return {"error": f"unsupported lookup mode {by!r}; expected 'title' or 'doi'"}

    headers = {"User-Agent": USER_AGENT}
    async with httpx.AsyncClient(timeout=TIMEOUT, headers=headers) as client:
        if by == "doi":
            doi = query.strip().removeprefix("https://doi.org/").removeprefix("doi:")
            r = await client.get(f"{CROSSREF}/{doi}")
            if r.status_code == 404:
                return {"query": query, "by": "doi", "matches": [], "note": "DOI not found"}
            r.raise_for_status()
            return {
                "query": query,
                "by": "doi",
                "matches": [_format_work(r.json()["message"])],
            }
        else:
            r = await client.get(
                CROSSREF,
                params={"query.bibliographic": query, "rows": 3},
            )
            r.raise_for_status()
            items = r.json().get("message", {}).get("items", [])
            return {
                "query": query,
                "by": "title",
                "matches": [_format_work(it) for it in items],
            }
