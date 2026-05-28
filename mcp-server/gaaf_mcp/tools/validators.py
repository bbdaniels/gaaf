"""BibTeX validators."""
from __future__ import annotations

import os
from collections import Counter
from typing import Any

from pybtex.database.input import bibtex as bibtex_in
from pybtex.exceptions import PybtexError

REQUIRED_FIELDS = {
    "article":      ["author", "title", "journal", "year"],
    "book":         ["author", "title", "publisher", "year"],
    "incollection": ["author", "title", "booktitle", "year"],
    "inproceedings":["author", "title", "booktitle", "year"],
    "techreport":   ["author", "title", "institution", "year"],
    "unpublished":  ["author", "title", "note"],
    "misc":         ["title"],
}


def validate_bib(path: str) -> dict[str, Any]:
    if not os.path.isfile(path):
        return {"error": f"file not found: {path}"}

    parser = bibtex_in.Parser()
    try:
        bib_data = parser.parse_file(path)
    except PybtexError as e:
        return {"error": f"parse error: {e}", "file": path}

    entries = bib_data.entries
    issues: list[dict[str, Any]] = []

    keys = list(entries.keys())
    duplicates = [k for k, n in Counter(keys).items() if n > 1]

    for key, entry in entries.items():
        et = entry.type.lower()
        required = REQUIRED_FIELDS.get(et, ["title"])
        missing = [
            f for f in required
            if f not in entry.fields and f not in entry.persons
        ]
        if missing:
            issues.append({"key": key, "type": et, "missing_fields": missing})

    return {
        "file": path,
        "n_entries": len(entries),
        "duplicate_keys": duplicates,
        "issues": issues,
        "status": "OK" if not issues and not duplicates else "ISSUES_FOUND",
    }
