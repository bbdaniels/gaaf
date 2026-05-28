# Citation Discipline

Citations are load-bearing. A broken or misattributed cite silently degrades
the credibility of every adjacent claim and embarrasses the author when a
referee catches it. GAAF enforces a strict canonical-identity rule.

## Canonical-identity rule

Every citation must have:

1. **A canonical identifier** — DOI when available, ISBN for books, arXiv ID
   for working papers, or a stable URL for grey literature.
2. **Agreement across sources** — the title, authors, year, and venue must
   match across:
   - Your `.bib` entry
   - Crossref (`api.crossref.org/works/<DOI>`)
   - OpenAlex (`api.openalex.org/works/doi:<DOI>`)
   - Your local Zotero entry (if you use Zotero)
3. **Indexed full text** — for substantive claim verification, you should
   have the source's full text available locally (Zotero attachment, repo,
   or a clean PDF).

If any of these fail, mark the cite as unverified and fix it before
submission. The `/cite-check` slash command runs this verification
automatically.

## Looking up cites — never use Google Scholar

Google Scholar and other generic search engines block automated lookups and
return inconsistent metadata. **Use APIs:**

- Crossref: `https://api.crossref.org/works?query.bibliographic=ENCODED_TITLE&rows=3`
- Crossref by DOI: `https://api.crossref.org/works/<DOI>`
- OpenAlex: `https://api.openalex.org/works?search=ENCODED_TITLE&per_page=3`
- Semantic Scholar: `https://api.semanticscholar.org/graph/v1/paper/search?query=TITLE`
- ORCID (author-based): `https://pub.orcid.org/v3.0/<ORCID-ID>/works`

The GAAF MCP server's `crossref_lookup` tool wraps the Crossref API for
convenience.

## Claim alignment

A cite is only correct if the cited source actually supports the claim being
made.

- **If you quote**, the quoted string must appear verbatim in the source.
- **If you paraphrase**, the paraphrase must not change the source's meaning.
  Sources often say "in our sample" or "under our assumptions" — strip these
  qualifications at your peril.
- **If you summarize a literature**, cite the canonical reviews, not your
  own gloss. Reviews exist for a reason.

When you cannot verify a claim because you don't have the source text, mark
it `[CLAIM UNVERIFIED]` and flag it for the researcher rather than asserting
confidently.

## What NOT to do

- **Do not invent DOIs.** A wrong DOI is worse than no DOI — it routes
  readers to the wrong paper.
- **Do not "correct" author names.** A name that looks misspelled may be a
  legitimate transliteration variant or a previous publishing name. Flag,
  don't silently change.
- **Do not cite papers you have not at least skimmed.** Citation-by-title-only
  is how false claims propagate.
- **Do not cite a review when the original source exists and is short
  enough to engage with directly.**
- **Do not bury a critical citation in a footnote** to avoid stating its
  implications in the main text.

## Working paper handling

- Cite the canonical version. If a paper has been published in a journal,
  cite the journal version, not the NBER WP.
- If you cite a WP, include the WP series and number (NBER w12345, SSRN id,
  IZA DP 9876).
- Check the working paper for newer versions before submission — WP versions
  often differ substantively from the published version.

## Retraction check

Before submission, screen the bibliography against:

- Retraction Watch database (`retractiondatabase.org`)
- Crossref's `update-to` relations (returns retraction notices)

If any cited work has been retracted or expressed concern issued, decide
explicitly whether to keep the cite (with a note) or remove it.
