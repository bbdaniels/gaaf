# Replication Package Standards

GAAF projects target AEA Data and Code Availability Policy compliance from
day one. Building reproducibility in from the start is dramatically cheaper
than retrofitting it before submission.

## Repository layout

```
project/
├── data/
│   ├── raw/                    # immutable, with provenance README per source
│   └── clean/                  # produced by code/acquire/
├── code/
│   ├── acquire/                # downloads + cleaning
│   ├── analyze/                # main and robustness specifications
│   └── figures/                # figure scripts
├── outputs/
│   ├── tables/                 # .tex tables (regenerable)
│   ├── figures/                # .pdf/.png figures (regenerable)
│   └── results/                # .tex fragments for \input{}
├── manuscript/
│   ├── main.tex
│   ├── sections/
│   └── references.bib
├── logs/                       # script run logs
├── README.md                   # how to reproduce
├── reproot.yaml                # software environment spec
└── runall.{sh,do,R}            # one-command reproducer
```

## The reproducibility contract

A clone of the repo, plus the data archive, plus the documented software
environment, must produce **bit-identical or numerically equivalent** outputs
when `runall` is executed.

- Set random seeds in every script that uses randomness.
- Pin package versions (Python: `requirements.txt` or `pyproject.toml`; R:
  `renv.lock`; Stata: log the version, list packages with versions).
- Document OS-specific gotchas (Windows path separators, macOS vs Linux LaTeX
  font availability).

## Numbers in writeups — the hard rule

**NEVER type a numerical result into the manuscript.** Every coefficient,
SE, p-value, sample size, percentage, count, mean, median, or CI must be
auto-exported from code as a `.tex` fragment and pulled in via `\input{}`.

### Stata pattern

```stata
reg y x i.country, cluster(country)
local b = string(_b[x], "%4.2f")
local se = string(_se[x], "%4.2f")
local p = string(2*ttail(e(df_r), abs(_b[x]/_se[x])), "%4.2f")
file open f using "outputs/results/main-coef.tex", write replace
file write f "\(`b'\) (SE \(`se'\), p \(= `p'\))" _n
file close f
```

### R pattern

```r
m <- lm(y ~ x + factor(country), data = df)
b <- sprintf("%.2f", coef(m)["x"])
se <- sprintf("%.2f", sqrt(diag(vcov(m)))["x"])
writeLines(sprintf("$%s$ (SE $%s$)", b, se), "outputs/results/main-coef.tex")
```

### Python pattern

```python
import statsmodels.formula.api as smf
m = smf.ols("y ~ x + C(country)", data=df).fit(
    cov_type="cluster", cov_kwds={"groups": df["country"]}
)
b, se = m.params["x"], m.bse["x"]
with open("outputs/results/main-coef.tex", "w") as f:
    f.write(rf"${b:.2f}$ (SE ${se:.2f}$)")
```

### Manuscript

```latex
The main effect is \input{outputs/results/main-coef.tex}.
```

When the code changes, the manuscript number changes automatically. No more
silent staleness.

## Data archive expectations

For each raw data source under `data/raw/<source>/`:

- `README.md` — what is this, where did it come from, when downloaded, version,
  citation, license/usage terms.
- `LICENSE_NOTES.md` (if applicable) — describes redistribution constraints.
- `manifest.csv` or equivalent — file names and SHA-256 checksums.

For restricted data (RDC, administrative, licensed):

- Do NOT commit the raw data.
- Document exactly how an authorized researcher would obtain it.
- Provide a synthetic or public-subset version for code testing where
  feasible.

## The `runall` test

Before any milestone (cross-read, submission, revision):

1. Wipe `data/clean/`, `outputs/`, and `logs/` (or run on a fresh clone).
2. Run `./runall.sh` (or `runall.do`, `runall.R`).
3. Confirm every output is regenerated and every manuscript `\input{}`
   resolves.
4. Diff the rendered PDF against the previous version. Numbers should match
   exactly (or change in a documented way).

If `runall` does not work end-to-end, the project is not ready to ship —
regardless of what the prose says.

## Software environment

A `reproot.yaml` (or `environment.yml`, or Docker / devcontainer spec)
records:

- Language versions (Python 3.11, R 4.4, Stata 18 MP, …)
- Package versions
- OS + architecture
- LaTeX distribution (texlive 2024, …)

For the absolutely portable case, ship a `Dockerfile` or use the GAAF
`.devcontainer/`.
