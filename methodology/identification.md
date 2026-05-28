# Identification Strategy — Decision Tree

This is the canonical decision tree for choosing an identification strategy in
empirical microeconomics. Read it fully before drafting a `/plan` memo.

The goal of identification is to map a population estimand (ATE, ATT, LATE,
ITT, MTE, ...) to a feature of the data that the estimator recovers under
stated assumptions. **A research design is only as credible as its weakest
named assumption.**

## Step 1 — Name the estimand

State what causal or descriptive quantity you want to learn, as a
population-level object. Examples:

- ATE of treatment $D$ on $Y$ over the full population
- ATT of $D$ on $Y$ for compliers
- ITT of an offer on take-up and downstream outcomes
- Elasticity of $Y$ to $X$ in equilibrium

If you cannot state the estimand in one line, the research question is not
yet operational. Go back to `/discover`.

## Step 2 — What variation identifies it?

| Source of variation | Strategy |
|---|---|
| Random assignment by researcher | RCT |
| Random or quasi-random assignment by nature/policy | Natural experiment |
| Discontinuous change at a threshold | Regression discontinuity (RD) |
| Differential timing of a policy across units | Difference-in-differences (DiD), event study |
| Instrument predicting treatment but not outcome | Instrumental variables (IV) |
| Selection on observables (conditional independence) | OLS / matching / IPW / DR |
| Structural model + functional-form assumptions | Structural estimation |
| No variation; describing the world | Descriptive (own its limits) |

## Step 3 — State the assumption explicitly

Every strategy rests on assumptions. Write them down literally.

- **RCT:** randomization succeeded; compliance is observed; SUTVA holds.
- **DiD:** parallel trends in untreated potential outcomes; no anticipation;
  treatment is well-defined and stable.
- **RD:** continuity of potential outcomes at the cutoff; no manipulation of
  the running variable.
- **IV:** relevance (strong first stage); exclusion (instrument affects $Y$
  only through $D$); monotonicity (for LATE).
- **Selection on observables:** conditional independence (no unobserved
  confounders given $X$); overlap (common support).
- **Structural:** the model is correctly specified; functional-form and
  distributional assumptions hold.

## Step 4 — Name the threats

For each assumption, name the specific scenario that would invalidate it.
"Parallel trends" is not a plan; "parallel trends could fail if the policy
was rolled out in regions experiencing differential pre-trends from a
prior shock in 2018" is a plan.

## Step 5 — Plan the falsification tests

Before running the main estimation, plan tests that would surface a
violation:

- **RCT:** balance table on baseline covariates; attrition analysis.
- **DiD:** event-study pre-trends figure; placebo on never-treated units;
  placebo in pre-period.
- **RD:** McCrary density test; covariate balance at cutoff; donut RD;
  varying bandwidth.
- **IV:** first-stage F; over-identification test (if multiple instruments);
  reduced form; sensitivity to alternative instruments.
- **Selection on observables:** Oster bounds; sensitivity to omitted
  variables (e.g., Cinelli–Hazlett); leave-one-out.

## Step 6 — Estimator

Map the strategy to a specification:

- **DiD with staggered adoption:** use a heterogeneity-robust estimator
  (Callaway–Sant'Anna, de Chaisemartin–D'Haultfœuille, Borusyak et al.,
  Sun–Abraham), not vanilla two-way FE. Document the choice.
- **IV:** 2SLS for binary; LIML or weak-instrument-robust inference for weak
  instruments; AR confidence sets when first-stage F is small.
- **RD:** local linear with MSE-optimal bandwidth (Calonico–Cattaneo–Titiunik);
  robust bias-corrected SEs.
- **Panel with selection on observables:** fixed effects with clustered SEs
  at the unit level (or pairs/triples cluster for two-way effects).
- **OLS with high-dim FEs:** `pyfixest` or `fixest` (R); never demean by hand
  for >2 FE dims.

## Step 7 — Inference

- Cluster SEs at the level of treatment assignment (or coarser if spillovers
  are plausible).
- Use wild cluster bootstrap when the number of clusters is small (<30).
- Use randomization inference for RCTs with small N.
- Pre-register the inference choice. Switching to a more favorable SE
  formula post-hoc is a violation of Principle 2 (Rigorous).

## Anti-patterns to flag

- Running a regression and calling it identification without naming an
  assumption.
- Adding controls one by one and reporting the most favorable
  specification.
- "Robustness" that only varies cosmetic choices, not the identifying
  assumption.
- Claiming causal interpretation from a descriptive specification.
- Choosing the estimator post-hoc based on which gives the "right" sign.
