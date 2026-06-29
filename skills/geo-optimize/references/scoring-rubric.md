# GEO Readiness Score — full rubric

Load this when you need exact band thresholds, counting rules, or edge-case
guidance to compute the 0-100 GEO Readiness Score in `SKILL.md`.

## How the score is computed

1. Score each of the 7 tactic families on a **0-100 sub-scale** using the bands
   below.
2. Multiply each sub-score by the tactic's **weight fraction** (weight / 100).
3. **Sum** the 7 weighted results. The total is the GEO Readiness Score (0-100).

```
final = Σ ( subscore_i × weight_i / 100 )   for i = 1..7
weights: 20 + 20 + 15 + 15 + 10 + 10 + 10 = 100
```

Round the final score to a whole number. Show each tactic's **weighted** points
(subscore × weight / 100) in the report table's "Score" column, not the raw
sub-score.

## Counting rules (apply consistently)

- **Word count:** body text only — exclude frontmatter, code blocks, nav, and
  HTML boilerplate. Use it to derive the per-150-200-word targets (use 175 as the
  midpoint divisor).
- **A "concrete statistic":** any specific number carrying meaning — percentage,
  currency amount, count, ratio, sample size, year, or measured quantity.
  "Many users" is not a stat; "62% of users" is.
- **"Sourced":** the stat names or links its origin within the same paragraph or
  via an inline citation. An unsourced number still counts toward density but
  caps tactic 3 at 50.
- **A "named authority":** a specific, checkable source — a named study, report,
  institution, dataset, or expert ("According to Gartner...", "the Princeton GEO
  study found..."). "Experts say" / "studies show" do **not** count.
- **A "definition block":** a bolded or H-tagged term immediately followed by a
  one- or two-sentence definition (or an HTML `<dl>`). Great for Discovery
  queries because engines lift definitions whole.
- **An "FAQ section":** >= 3 explicit question headings (or `<details>`/FAQ
  block) each with a direct answer. Pairs well with `aeo-optimize` and a
  `structured-data` FAQPage JSON-LD emit.
- **"Internal link":** a link to another page on the same site/repo. Outbound
  links to authorities count for tactic 4, not tactic 5.

## Per-tactic band tables

### 1. Direct-answer-first — weight 20

| Sub-score | Condition |
|:---------:|-----------|
| 100 | A self-contained answer to the main question appears in the first ~50 words, and the first 150-200 words stay focused on that answer. |
| 75  | Answer appears within the first 150-200 words but after >50 words of preamble. |
| 50  | Answer is present but only after ~200 words, or is hedged/partial. |
| 25  | Main question only implicitly addressed; reader must infer the answer. |
| 0   | First 200 words are history, brand story, or marketing with no direct answer. |

### 2. Authoritative citations — weight 20

| Sub-score | Condition |
|:---------:|-----------|
| 100 | >= 3 distinct named authorities, each attributed inline ("According to [Name]..."); most are linked. |
| 75  | 2 distinct named authorities, attributed inline. |
| 50  | Exactly 1 named authority, or several sources referenced only vaguely. |
| 25  | Only vague references ("studies show", "experts agree"). |
| 0   | No external authority cited. |

### 3. Data density — weight 15

Compute `ratio = sourced_stats / (words / 175)`.

| Sub-score | Condition |
|:---------:|-----------|
| 100 | ratio >= 1.0 **and** every stat is sourced. |
| 75  | ratio >= 1.0 but some stats unsourced, OR ratio 0.7-1.0 fully sourced. |
| 50  | ratio 0.4-0.7, OR ratio >= 0.7 with most stats unsourced. |
| 25  | ratio 0.1-0.4. |
| 0   | ratio < 0.1 (essentially no concrete numbers). |

### 4. Structured formats — weight 15

Four sub-elements, 25 sub-points each: table; numbered/bulleted list; definition
block; FAQ (>= 3 Q&A). Sub-score = 25 × (elements present).

| Elements present | Sub-score |
|:----------------:|:---------:|
| 4 | 100 |
| 3 | 75 |
| 2 | 50 |
| 1 | 25 |
| 0 | 0 |

### 5. Topical authority — weight 10

| Sub-score | Condition |
|:---------:|-----------|
| 100 | Page is part of a real cluster — a 2,500+ word pillar plus 5-10 supporting articles — and has >= 3 relevant internal links. |
| 75  | Clear cluster intent (pillar OR several supporters) with >= 3 internal links, but cluster incomplete. |
| 50  | 1-2 internal links; loose topical grouping. |
| 25  | A single internal link; otherwise isolated. |
| 0   | Orphan page, no internal links, no cluster. |

### 6. Unique / proprietary data — weight 10

| Sub-score | Condition |
|:---------:|-----------|
| 100 | >= 1 genuine first-party data point or exhibit (own survey, benchmark, dataset, original case-study numbers) not available elsewhere. |
| 50  | Original framing, analysis, or anecdote but no hard proprietary numbers. |
| 0   | Entirely aggregated third-party information. |

### 7. Freshness signals — weight 10

| Sub-score | Condition |
|:---------:|-----------|
| 100 | Visible "Last updated: <date>" within the current year **and** current-year stats where the topic is time-sensitive. |
| 75  | Visible current-year "Last updated" date, but some stats are stale. |
| 50  | A date is present but stale (prior year), or only a publish date. |
| 25  | Date buried in metadata only, not visible in body. |
| 0   | No date anywhere. |

## Score bands (for the report header)

| Score  | Band | Meaning |
|:------:|------|---------|
| 0-49   | Invisible to AI | Rebuild the intro answer-first, add named citations and stats before anything else. |
| 50-74  | Partially extractable | Structure exists but engines skip it; close structural, citation, and freshness gaps. |
| 75-89  | Strong | Frequently quotable; tighten proprietary data and cluster links to win more queries. |
| 90-100 | Citation-ready | Add `structured-data` JSON-LD and confirm `ai-crawler-access` so engines can fetch it. |

## Worked scoring example

A 1,200-word Consideration article: clear answer in first 40 words (tactic 1 =
100), 2 named authorities (tactic 2 = 75), 5 sourced stats -> ratio ≈ 0.73
fully sourced (tactic 3 = 75), has a table + list + FAQ but no definition block
(tactic 4 = 75), 2 internal links no pillar (tactic 5 = 50), one original
benchmark (tactic 6 = 100), publish date only (tactic 7 = 50).

```
1: 100×0.20 = 20.0
2:  75×0.20 = 15.0
3:  75×0.15 = 11.25
4:  75×0.15 = 11.25
5:  50×0.10 =  5.0
6: 100×0.10 = 10.0
7:  50×0.10 =  5.0
TOTAL ≈ 78 / 100  → "Strong"
```

Biggest recoverable points: tactic 2 (add a third named authority, +5) and
tactic 7 (add a visible "Last updated" date + current-year stats, +5).
