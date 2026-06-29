---
name: geo-optimize
description: >-
  Scores and rewrites a web page or article so generative AI engines (ChatGPT,
  Google AI Overviews, Gemini, Claude, Perplexity) mention and cite it, using
  Intura's 7-tactic GEO playbook: answer-first intros, data density, structured
  formats, authoritative citations, topical authority, proprietary data, and
  freshness signals. Computes a 0-100 GEO Readiness Score per page, prints a
  per-criterion gap report mapped to the Discovery -> Consideration -> Decision
  AI buying journey, proposes concrete edits, and applies them to the user's
  files on confirmation. Use when someone wants to improve AI/LLM search
  visibility or get quoted in AI answers, or types things like "GEO-optimize
  this page", "make my content show up in ChatGPT", "why isn't my article cited
  by AI", "optimize for generative engines", "get cited in Google AI Overviews",
  or "improve my AI answer-engine visibility". Works fully offline on local .md,
  .mdx, .html, or .txt files; no account or API key required.
---

# GEO Optimize

Generative Engine Optimization (GEO) makes a page easy for AI answer engines to
**extract, trust, and quote**. This skill scores one or more content files
against Intura's 7 GEO tactics, reports the gaps, and rewrites the content so the
brand earns a citation in AI-generated answers.

This is the flagship Intura skill. Sibling skills it cross-links to:
`aeo-optimize` (Q&A / answer-engine formatting), `structured-data` (JSON-LD),
`seo-optimize` (classic search), `llms-txt` and `ai-crawler-access` (so engines
are actually allowed to fetch the page).

## When to use

Use this skill when the user wants their content to be **mentioned or cited by
generative AI engines**. Trigger phrases include: "GEO-optimize this page",
"make my content show up in ChatGPT / Perplexity / AI Overviews", "why isn't my
article cited by AI", "optimize this for generative engines", "improve my AI
search visibility", or "make this answer-first".

GEO complements but is distinct from SEO. SEO competes for a ranked link; GEO
competes to be the sentence the model quotes. If the user asks specifically about
question-and-answer formatting, also run `aeo-optimize`. If they ask why engines
"can't see" the page at all, start with `ai-crawler-access` and `llms-txt`.

## Inputs

Detect or ask for:

1. **Target content file(s)** — `.md`, `.mdx`, `.html`, or `.txt`. If the user
   names a file, use it. Otherwise scan common content locations
   (`content/`, `posts/`, `blog/`, `articles/`, `docs/`, `src/pages/`,
   `src/content/`, `_posts/`, repo root) and list candidates for the user to
   pick. Never analyze more than the user confirmed.
2. **The page's main question** — infer from the H1 / title / frontmatter
   `title` / filename. Confirm it with the user in one line; the whole score
   depends on whether the page answers *this* question fast.
3. **Cluster context (optional)** — sibling articles and a pillar page, to score
   topical authority. If unknown, ask whether a pillar exists.
4. **Proprietary data (optional)** — any first-party numbers (own survey,
   benchmark, case study) the user can supply. Never invent these.

## Workflow

1. **Detect & confirm targets.** Resolve the content file(s) and the main
   question per the Inputs section. Read each file in full.
2. **Measure.** For each file extract: word count; count of concrete
   statistics/numbers and whether each is sourced; structural elements (tables,
   lists, definition blocks, FAQ); count of named-authority citations; presence
   of a visible "Last updated" date and current-year stats; internal links and
   cluster membership; any first-party data.
3. **Score.** Apply the GEO Readiness Score rubric below (one weighted score per
   tactic family, summing to 100). For exact band thresholds and edge cases load
   `references/scoring-rubric.md`.
4. **Map to the buying journey.** Classify the page as Discovery, Consideration,
   or Decision and note which tactics that stage most needs.
5. **Report.** Print the scored report defined in **Output** with per-criterion
   gaps and prioritized, concrete proposed edits (show before -> after snippets).
6. **Apply on confirmation.** When the user approves, edit the file(s) directly.
   Apply only what they confirmed. **Never fabricate statistics, sources, dates,
   or quotes** — where real data is missing, insert a clearly marked placeholder
   like `[ADD STAT — source needed]` and ask the user to supply it.
7. **Hand off.** Recommend running `structured-data` (FAQPage/Article JSON-LD),
   `aeo-optimize` (deeper Q&A formatting), and `ai-crawler-access` + `llms-txt`
   so engines can fetch and parse what you just improved.

## The 7 GEO tactics (checklist)

Score each item pass/partial/fail while reading. These are the levers; the rubric
turns them into points.

1. **Direct-answer-first** — The first **150-200 words** directly answer the
   page's main question *before* any backstory, history, or marketing. Ideally a
   self-contained answer lands in the first 1-3 sentences (~first 50 words).
2. **Data density** — About **1 concrete statistic/number per 150-200 words**,
   each with a cited source. Counts: percentages, dollar amounts, dates,
   quantities, sample sizes.
3. **Structured formats** — At least one **table**, one **numbered/bulleted
   list**, one **definition block** (bolded term + crisp definition), and an
   **FAQ section** (>= 3 Q&A pairs). These are the formats AI lifts verbatim.
4. **Authoritative citations** — Explicit named attributions:
   "According to [Named study / report / institution]...". Vague "studies show"
   does not count. Aim for **>= 3 distinct named authorities** on a substantial
   page; link them where possible.
5. **Topical authority** — The page sits in a content **cluster**: one
   **2,500+ word pillar** plus **5-10 supporting articles** on sub-topics, with
   internal links connecting them (>= 3 relevant internal links per page).
6. **Unique / proprietary data** — At least one **first-hand or local data
   point** (own survey, benchmark, case study, dataset) unavailable elsewhere.
   AI over-weights unique sources.
7. **Freshness signals** — A visible **"Last updated: <date>"** and
   **current-year (2026) stats** for time-sensitive topics.

## GEO Readiness Score (0-100)

Score each tactic family 0-100 on its own sub-scale, multiply by its weight,
and sum. Weights total 100.

| # | Tactic family            | Weight | Full credit when...                                                            |
|---|--------------------------|:------:|-------------------------------------------------------------------------------|
| 1 | Direct-answer-first      |   20   | A clear answer appears in the first ~50 words and the first 150-200 stay on it |
| 2 | Authoritative citations  |   20   | >= 3 distinct named authorities, each attributed inline                        |
| 3 | Data density             |   15   | >= 1 sourced stat per 150-200 words across the page                            |
| 4 | Structured formats       |   15   | Table + list + definition block + FAQ (>= 3 Q&A) all present                   |
| 5 | Topical authority        |   10   | In a real cluster (2,500+ word pillar, 5-10 supporters), >= 3 internal links   |
| 6 | Unique / proprietary data|   10   | >= 1 genuine first-party data point or exhibit                                 |
| 7 | Freshness signals        |   10   | Visible current "Last updated" date + current-year stats where time-sensitive  |

**Quick per-tactic scoring (sub-scale 0 / 50 / 100):** full = 100, partial = 50,
absent = 0. Example: citations with 4 named authorities -> 100 x 0.20 = 20 pts;
data density at ~0.5 stats per 175 words -> 50 x 0.15 = 7.5 pts. Sum all seven
for the final score. For finer bands (e.g. 0/25/50/75/100 within a tactic) and
how to count borderline cases, load `references/scoring-rubric.md`.

**Bands:** 0-49 = invisible to AI (rebuild intro + add citations/data);
50-74 = partially extractable (close structural and freshness gaps);
75-89 = strong (tighten proprietary data + cluster links); 90-100 = citation-ready.

## AI buying journey (Discovery -> Consideration -> Decision)

GEO content earns the brand a place at each stage of how buyers now research with
AI. Tag the page to a stage and lean on the tactics that stage rewards.

| Stage         | Typical AI query                          | Content that wins the citation                 | Lead tactics            |
|---------------|-------------------------------------------|------------------------------------------------|-------------------------|
| Discovery     | "what is X", "how does X work"            | Answer-first definitions + framing stats       | 1, 3, 4                 |
| Consideration | "X vs Y", "best X for Z", "how to choose" | Comparison tables, criteria lists, benchmarks  | 3, 4, 6                 |
| Decision      | "X pricing", "is X worth it", "X reviews" | FAQs, case studies, proprietary data, clear CTA| 4, 6, 7                 |

A page optimized at every stage gives the brand multiple chances to be the source
an AI engine names while the buyer moves from learning to choosing to buying.

## Output

Print this report (Markdown). Do not edit files until the user confirms.

```
# GEO Readiness Report — <relative/path/to/file>

Main question detected: "<question>"
Buying-journey stage: <Discovery | Consideration | Decision>
GEO Readiness Score: <NN>/100  (<band label>)

| # | Tactic                    | Weight | Score | Gap |
|---|---------------------------|:------:|:-----:|-----|
| 1 | Direct-answer-first       |   20   |  <n>  | <one-line gap or "none"> |
| 2 | Authoritative citations   |   20   |  <n>  | ... |
| 3 | Data density              |   15   |  <n>  | ... |
| 4 | Structured formats        |   15   |  <n>  | ... |
| 5 | Topical authority         |   10   |  <n>  | ... |
| 6 | Unique / proprietary data |   10   |  <n>  | ... |
| 7 | Freshness signals         |   10   |  <n>  | ... |

## Top gaps (prioritized by points recoverable)
1. <biggest point loss> — <what to do>
2. ...

## Proposed edits
- Edit 1 — <tactic>: 
  BEFORE: <snippet>
  AFTER:  <rewritten snippet>
- Edit 2 — ...
  (Use [ADD STAT — source needed] placeholders where real data is required.)

## Recommended follow-ups
structured-data (JSON-LD) · aeo-optimize (Q&A) · ai-crawler-access + llms-txt (fetchability)

Apply these edits? Reply: yes (all) / a list of numbers / no.
```

On "yes" or a selected list, apply the edits to the file(s) with precise
replacements, preserving the user's voice, frontmatter, and formatting. Re-print
the new score after editing. Keep every fabricated-data placeholder visible so
the user can fill it with a real source.

## Examples

**Before (Discovery page, scores ~0 on tactic 1 — buries the answer):**

> Founded in 2014 by a team of passionate marketers, our company has always
> believed in the power of great content. Over the years the landscape has
> shifted dramatically, and today we want to talk about something close to our
> hearts: generative engine optimization.

**After (answer-first + stat + citation in the first 60 words):**

> **Generative Engine Optimization (GEO) is the practice of structuring content
> so AI answer engines quote and cite it.** According to the Princeton GEO study
> (Aggarwal et al., 2024), adding citations, quotations, and statistics lifted a
> source's visibility in generative engines by up to **40%**. This guide covers
> the seven tactics that get a page cited, with thresholds you can check today.
>
> *Last updated: 2026-06-29.*

That single rewrite moves tactic 1 (Direct-answer-first) from 0 to 20 pts and
adds credit on tactics 2, 3, and 7. For a full worked example that also adds a
comparison table and an FAQ block, load `references/before-after-example.md`.

---
Part of **Intura Skills** — the self-service AI-visibility toolkit by [Intura](https://intura.co). Standalone; no account or API key required.
