---
name: aeo-optimize
description: >-
  Answer Engine Optimization. Restructures a page so answer engines and AI
  assistants extract it cleanly: phrases headings as natural questions, leads
  each section with a self-contained 40-60 word snippet-sized answer, picks the
  right featured-snippet shape (paragraph, list, or table), builds or repairs a
  real FAQ section, covers "People Also Ask" variants, adds jump links and
  anchored headings so answers are addressable, and uses definitional "X is..."
  openers and conversational voice-search phrasing. Scores the page 0-100 on
  "Answer Readiness", prints a report, and applies edits on confirmation. Use
  when the user says "AEO this page", "optimize for featured snippets", "get me
  in People Also Ask", "make this answer voice search", "win the position-zero
  box", "rank in the answer box", or "make my FAQ extractable". Pairs with the
  structured-data skill to emit FAQPage/QAPage JSON-LD.
---

# aeo-optimize

Restructure content so answer engines (Google's featured snippet / "position
zero", People Also Ask, Bing, voice assistants) and AI assistants can lift a
short, correct, self-contained answer straight off the page. You optimize the
*extracted answer*, not just the ranking.

## When to use

Use this skill when the user wants a page to win the answer box, appear in
People Also Ask, be quotable by voice assistants, or surface its FAQ in AI
answers. Trigger phrases include "AEO this page", "optimize for featured
snippets", "get into People Also Ask", "make this voice-search friendly",
"win position zero", or "make my FAQ extractable".

Scope and siblings:
- **aeo-optimize (this skill)** — the extractable answer: question headings,
  snippet-sized leads, FAQ, addressability.
- **geo-optimize** — broader AI-visibility (citation-worthiness, entity clarity,
  freshness) for generative engines. Run it for whole-page AI strategy.
- **seo-optimize** — classic ranking signals (titles, meta, internal links,
  Core Web Vitals). A page must rank before it can win the snippet.
- **structured-data** — emits the actual FAQPage/QAPage/HowTo JSON-LD. Hand off
  to it once your FAQ block exists.

## Inputs

Detect automatically; ask only if missing:
1. **Target file(s).** The content the user named. If none named, find content
   files in the repo: `*.md`, `*.mdx`, `*.html`, `*.njk`, `*.liquid`, or
   templates under `content/`, `pages/`, `posts/`, `src/`, `docs/`. Confirm the
   exact file before editing.
2. **Primary question / intent.** Infer from the H1, title, slug, and existing
   headings. If ambiguous, ask one question: "What is the main question this
   page should answer?"
3. **Format constraints.** Note whether the file is Markdown, MDX, or HTML so
   edits use the right syntax for headings, anchors, and lists.
4. **Existing FAQ / JSON-LD.** Grep for an FAQ section and for
   `application/ld+json` so you repair rather than duplicate.

## Workflow

1. **Read the target file** end to end. Note the H1, every H2/H3, the lead
   paragraph of each section, and any existing FAQ or jump links.
2. **Enumerate the questions** the page should answer. Pull them from: existing
   headings, the page's core intent, and PAA-style expansions — for each main
   question generate the natural follow-ups (what / why / how / when / how much
   / is it / vs / best). See `references/snippet-patterns.md` for the expansion
   patterns.
3. **Map each question to a snippet shape** (paragraph, list, or table) using
   the decision rules below.
4. **Restructure each section**: rewrite the heading as a natural question (or
   keep a noun heading but ensure a question variant exists in the FAQ); write a
   self-contained 40-60 word direct answer as the *first* paragraph; then add
   the supporting detail beneath it.
5. **Build or repair the FAQ block** near the end of the page using the template
   in the reference file. Each FAQ answer is 40-60 words and stands alone.
6. **Add addressability**: ensure every H2/H3 has a stable anchor/slug, and add
   a table-of-contents / jump-link list near the top if the page has 4+
   sections.
7. **Score** the page with the Answer Readiness rubric.
8. **Print the report** (format below) with the score, the checklist, and a
   concrete edit list. **Do not edit yet.**
9. **On user confirmation, apply the edits** to the file(s). Then suggest
   running **structured-data** to emit FAQPage/QAPage JSON-LD and
   **geo-optimize** for broader AI visibility.

## Method

### Snippet-shape decision rules

Pick ONE shape per answer. Load `references/snippet-patterns.md` for
copy-pasteable templates of each.

- **Paragraph snippet** — wins for definitions and "what is / why / who / how
  long / how much / can I" questions. One self-contained block of **40-60 words
  (~300 characters)**. Lead with a definitional "**X is...**" opener.
- **List snippet** — wins for "how to / steps / ways to / best / types of /
  checklist / examples" questions. Use an **ordered list** for sequences/ranking
  and an **unordered list** for sets. Keep **5-8 items**, each item front-loaded
  with the key phrase; engines truncate after ~8.
- **Table snippet** — wins for comparisons, pricing tiers, specs, schedules, or
  any answer with **2+ dimensions**. Keep it small: **2-3 columns** and a
  handful of rows; put the comparison axis in the first column.

### Answer Readiness checklist

Mark each item pass/fail in the report:

- [ ] H1 expresses (or directly implies) a single primary question.
- [ ] Every major section heading is a natural question, or has a matching
      question in the FAQ.
- [ ] Each section's **first** paragraph is a self-contained 40-60 word answer
      that makes sense with zero surrounding context.
- [ ] At least one answer uses the correct non-paragraph shape (list or table)
      where the question type calls for it.
- [ ] Key definitional answers start with an "**X is...**" opener.
- [ ] A real FAQ section exists with 3+ question/answer pairs, each answer
      40-60 words.
- [ ] FAQ questions mirror real PAA-style phrasing (full questions, natural
      language), not keyword fragments.
- [ ] Voice/conversational variants exist for the top question (e.g. "how do
      I...", "what's the best way to...").
- [ ] Every H2/H3 has a stable anchor; a ToC / jump-link list is present for
      pages with 4+ sections.
- [ ] The FAQ is structurally clean enough to feed the **structured-data** skill
      for FAQPage/QAPage JSON-LD (no answers buried in images, tabs, or accordions
      that hide text from the DOM).

### Answer Readiness rubric (0-100)

Score each criterion, sum the weighted points, report the total.

| # | Criterion | Weight | Full credit when... |
|---|-----------|-------:|---------------------|
| 1 | Snippet-ready lead answers | 25 | Most sections open with a standalone 40-60 word answer |
| 2 | Question-framed headings | 15 | Headings read as natural questions a user would type/say |
| 3 | Real FAQ section | 15 | 3+ Q/A pairs, snippet-sized, mirroring PAA phrasing |
| 4 | Correct snippet shape | 10 | List/table used where the question type wins; paragraph elsewhere |
| 5 | Addressability | 10 | Anchored headings + ToC/jump links; answers are linkable |
| 6 | Structured-data readiness | 10 | FAQ text is in the DOM and clean enough to emit JSON-LD |
| 7 | Voice & PAA coverage | 10 | Conversational variants + follow-up questions covered |
| 8 | Definitional openers | 5 | Definitions begin with "X is..." |

Bands: **0-49** not answer-ready (major restructure); **50-74** partially ready
(fix the lead answers and FAQ); **75-89** strong; **90-100** snippet-optimized.

Deduct full credit on criterion 1 if any "answer" paragraph depends on the
previous sentence to make sense — extractability is the whole game.

## Output

Print this report to the user. Do not modify files until they confirm.

```
# Answer Readiness Report — <file path>
Score: <N>/100  (<band>)

## Scorecard
| Criterion | Score | Notes |
|-----------|------:|-------|
| Snippet-ready lead answers (25) | <n>/25 | ... |
| Question-framed headings (15)   | <n>/15 | ... |
| Real FAQ section (15)           | <n>/15 | ... |
| Correct snippet shape (10)      | <n>/10 | ... |
| Addressability (10)             | <n>/10 | ... |
| Structured-data readiness (10)  | <n>/10 | ... |
| Voice & PAA coverage (10)       | <n>/10 | ... |
| Definitional openers (5)        | <n>/5  | ... |

## Checklist
<pass/fail list>

## Questions this page should own
- <question> -> shape: <paragraph|list|table>
- ...

## Proposed edits
1. <heading change> — before: "<old>" -> after: "<new>"
2. <new 40-60 word lead answer for section X>
3. <FAQ block to add/repair>
4. <ToC / anchors to add>

## Next steps
- Confirm to apply these edits.
- Then run `structured-data` to emit FAQPage/QAPage JSON-LD.
- Consider `geo-optimize` for broader AI visibility.
```

After the user confirms, apply every accepted edit directly to the target
file(s) using the file's native syntax (Markdown or HTML), preserving existing
front matter and components.

## Examples

**Before** (Markdown — buried, non-extractable):

```markdown
## Pricing

We have a few options depending on your team size and needs. Most customers
start on the lower tier and upgrade later once they see value, and there are
discounts if you pay annually instead of monthly.
```

**After** (question heading + 40-60 word paragraph lead + table snippet + FAQ):

```markdown
## How much does Acme cost?

Acme costs $0 to $49 per user per month across three plans: Free for solo use,
Pro at $19/user/month for small teams, and Business at $49/user/month for
advanced controls. Annual billing saves 20%. Every paid plan includes a 14-day
trial, and you can change tiers at any time.

| Plan | Price (monthly) | Best for |
|------|-----------------|----------|
| Free | $0 | Individuals |
| Pro | $19/user | Small teams |
| Business | $49/user | Growing companies |

## FAQ

### Is there a free version of Acme?
Yes. Acme's Free plan costs $0 forever for a single user and includes core
features with no credit card required. Upgrade to Pro ($19/user/month) when you
add teammates or need shared workspaces, automations, and priority email
support.
```

The "After" version leads with a definitional, self-contained answer, uses a
table for the multi-dimensional pricing question, phrases the heading as a real
query, and adds a PAA-style FAQ entry ready for FAQPage JSON-LD via the
**structured-data** skill.

For full templates (paragraph/list/table snippets, question-heading patterns,
PAA expansion sets, and the FAQ block), load
`references/snippet-patterns.md`.

---
Part of **Intura Skills** — the self-service AI-visibility toolkit by [Intura](https://intura.co). Standalone; no account or API key required.
