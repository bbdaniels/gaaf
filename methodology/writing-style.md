# Writing Style — Economics Conventions

GAAF prose targets the standards of leading applied-economics journals:
direct, structured, claim-evidence aligned, and stingy with hedges.

## Anti-hedging

Hedging in empirical writing dilutes claims that have specific evidence
behind them. If you have a coefficient and a standard error, write them.

- ✗ "The effect could potentially be around 0.10."
- ✓ "The effect is 0.10 (SE 0.03)."

- ✗ "Our results suggest that ..."
- ✓ "We estimate that ..."  (or)  "Table 3 shows that ..."

- ✗ "It may be the case that ..."
- ✓ "We find that ..."  (state the finding; add bounds separately)

Hedges are appropriate when:

- The estimate genuinely has wide CIs (state the CI).
- The interpretation depends on an assumption you cannot test (name the
  assumption).
- The result is from a robustness exercise that is suggestive but not
  primary (label it as such).

Otherwise, write directly.

## Effect sizes carry units, percentages carry baselines

- ✗ "The coefficient on X is 0.12."
- ✓ "A one-SD increase in X raises Y by 0.12 SD, or 8 percent relative to the
  control-group mean of 1.5."

- ✗ "Treatment increased revenue by 15 percent."
- ✓ "Treatment increased revenue by 15 percent, from a control-group mean
  of $1,200 per month."

## Notation consistency

- Define each symbol on first use: $Y_{it}$ is outcome for unit $i$ in period
  $t$.
- Reuse the same symbol throughout — don't drift between $X_i$, $x_i$, and
  $x$ for the same object.
- Subscripts indicate the indexing set: $_{it}$ (unit × time), $_g$ (group),
  etc.
- Population vs sample: $E[\cdot]$ vs $\hat{E}[\cdot]$; $\beta$ vs
  $\hat{\beta}$.

## Section structure

A typical applied-economics empirical paper:

1. **Introduction** (4–6 pages)
   - Hook (motivation, stakes)
   - Question (one sentence)
   - Setting and data (one paragraph)
   - Identification (one paragraph)
   - Main result (with effect size)
   - Mechanism / interpretation
   - **Contribution statement** — must be in the first 2 pages
   - Roadmap (one short paragraph)

2. **Setting and data**
   - Institutional context relevant to identification
   - Data sources, sample, variable construction
   - Descriptives (Table 1)

3. **Empirical strategy**
   - Estimating equation in display math
   - Identifying assumption named explicitly
   - Threats and falsification plan

4. **Results**
   - Main effect
   - Robustness
   - Mechanism / heterogeneity

5. **Conclusion**
   - One paragraph restating finding
   - One paragraph on what it does NOT say
   - One paragraph on implication / next questions

## Topic sentences

Every paragraph's first sentence should state the paragraph's claim. A
reader skimming only topic sentences should get the paper's argument.

- ✗ "In this section, we discuss our identification strategy."
- ✓ "Identification rests on the staggered timing of the policy across
  states, which provides plausibly exogenous variation conditional on
  state and year fixed effects."

## Claims must point to evidence

Every empirical claim in prose needs a specific pointer.

- ✓ "Treatment raises take-up by 12 percentage points (Table 3, Column 2)."
- ✓ "Pre-trends are flat (Figure 2)."
- ✗ "Our identification strategy is supported by the data." (vague — point
  to the test)

## Throat-clearing to delete

- "It is important to note that ..."
- "In what follows, we ..."
- "As we will show ..."
- "It should be emphasized ..."

Just say the thing.

## Dashes

In LaTeX, use ` -- ` (spaced en-dash) for parenthetical phrases. Never `---`
(em-dash) and never Unicode em-dashes inline.

- ✓ "the results -- while preliminary -- suggest ..."
- ✗ "the results---while preliminary---suggest ..."

## Hyperlinks

URLs are fine to include, but the URL itself must always be visible in the
text — never use overlay hyperlinks where display text hides the URL. This
is for print-friendliness and transparent sourcing.

- ✓ `See \texttt{https://example.org/data} for the data.`
- ✗ `See \href{https://example.org/data}{the data}.`
