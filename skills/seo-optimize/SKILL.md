---
name: seo-optimize
description: >-
  Audits and fixes classic on-page and technical SEO on a web page, template, or
  markdown file: <title> and meta description length, exactly one <h1> and a
  logical heading hierarchy, descriptive lowercase-hyphen URL slugs, internal
  links with meaningful anchor text, image alt text, rel=canonical, Open Graph
  and Twitter Card tags, sitemap.xml and robots.txt basics, keyword placement
  without stuffing, readability, and Core Web Vitals (LCP, CLS, INP). Scores the
  page 0-100, prints a prioritized report, and applies safe edits to the user's
  files on confirmation. Use when the user says "SEO audit this page",
  "optimize on-page SEO", "fix my title and meta tags", "check my headings",
  "improve my Core Web Vitals", "add Open Graph tags", "why isn't this ranking",
  or "make this page Google-friendly". This is the on-page foundation that the
  geo-optimize and aeo-optimize skills build on.
---

# seo-optimize

Imperative instructions for the agent. You audit a page against classic on-page
and technical SEO rules, score it 0-100, print a prioritized report, and apply
safe edits only after the user confirms.

## When to use

Use this skill when the user wants to:

- Run an on-page or technical SEO audit on a page, template, or markdown file.
- Fix `<title>`, meta description, headings, slugs, alt text, canonical, or
  social-share (Open Graph / Twitter Card) tags.
- Improve Core Web Vitals or diagnose why a page ranks poorly in Google/Bing.
- Establish the SEO baseline before layering generative-engine optimization.

This skill is the foundation. For sibling concerns, hand off:

- **ai-crawler-access** — robots.txt rules for AI bots (GPTBot, ClaudeBot,
  Google-Extended, PerplexityBot), llms.txt allow/deny. Do NOT write AI-bot
  rules here; only cover classic crawler basics.
- **structured-data** — JSON-LD schema for rich results (Article, FAQ, Product,
  Breadcrumb). If the page needs schema, recommend it and stop there.
- **aeo-optimize** — answer-engine formatting (direct answers, Q&A, snippets).
- **geo-optimize** — generative-engine visibility (citations in ChatGPT,
  Perplexity, Google AI Overviews).

## Inputs

Detect these automatically before asking the user anything:

1. **Page files** — `.html`, `.htm`, `.jsx/.tsx`, `.vue`, `.svelte`, `.astro`,
   `.md/.mdx`, or templating files (`.liquid`, `.njk`, `.hbs`, `.ejs`, `.erb`,
   `.php`). Look in `src/`, `pages/`, `app/`, `content/`, `posts/`, `_posts/`,
   `public/`, repo root.
2. **Head partials / layouts** — shared `<head>` in `layout.*`, `_head.*`,
   `head.*`, `BaseHead.*`, `app/layout.tsx`, `_document.tsx`, `Seo.*`,
   `components/seo*`. Tags may be set here, not in the page.
3. **Site config** — `sitemap.xml`, `robots.txt`, `next-sitemap.config.*`,
   `astro.config.*`, `_config.yml`, `gatsby-config.*`, framework SEO plugins.
4. **The target keyword / topic** — infer from the H1, URL, and first paragraph.

If you cannot identify the target file or the primary keyword, ask the user for
exactly that — nothing else. If the page is server-rendered from a framework
(Next.js metadata API, Astro frontmatter, Nuxt `useHead`), edit the
metadata source, not the compiled HTML.

## Workflow

1. **Detect** the target page(s), the head partial/layout that owns the meta
   tags, and the site config files (sitemap, robots). State which files you
   found and which one owns each tag.
2. **Extract** the current values: title, meta description, all headings (in
   order), URL slug, canonical, OG/Twitter tags, image `alt` attributes,
   internal links + anchor text, and the inferred primary keyword.
3. **Audit** every item against the checklist below. For deep rules, limits, and
   good/bad snippets, load `references/on-page-checklist.md`.
4. **Score** the page 0-100 with the rubric below. Record per-category points.
5. **Print** the prioritized report in the exact Output format. Order findings
   P0 (critical) -> P1 (important) -> P2 (polish).
6. **Confirm, then edit.** Ask the user to approve. On a yes, apply only the
   safe edits to the correct source files. Re-state the new score. Never invent
   facts to fill a meta description — if copy is needed, draft it and flag it
   `[DRAFT — verify]`.

## Audit checklist

Each item is PASS / WARN / FAIL. Exact limits (the same ones the rubric scores):

**Head & metadata**
- [ ] Exactly one `<title>`, <= 60 chars (hard cap ~580px). Primary keyword in
  the first ~30 chars. Brand last: `Primary Keyword - Topic | Brand`.
- [ ] One meta description, 120-155 chars, action-oriented, contains the keyword
  naturally, unique across the site. Not auto-truncated mid-word.
- [ ] `rel=canonical` present, absolute HTTPS URL, self-referential by default;
  no conflicting/duplicate canonicals.
- [ ] Open Graph: `og:title`, `og:description`, `og:type`, `og:url`, `og:image`
  (absolute URL, >= 1200x630, < 5MB). `og:image:alt` present.
- [ ] Twitter Card: `twitter:card` (`summary_large_image`), `twitter:title`,
  `twitter:description`, `twitter:image`.
- [ ] `<meta name="viewport" content="width=device-width, initial-scale=1">`
  and `<html lang="...">` set.

**Content structure**
- [ ] Exactly one `<h1>`, contains the primary keyword, distinct from `<title>`.
- [ ] Heading hierarchy descends without skipping a level (no `<h2>` -> `<h4>`).
- [ ] Primary keyword appears in the `<h1>`, in the first 100 words, and in at
  least one subheading — read naturally, never stuffed (keyword density ~0.5-2%).
- [ ] Body is readable: short paragraphs (<= 3-4 sentences), descriptive
  subheadings, lists/tables where useful, target ~grade 8-10 reading level.

**Links, media, URLs**
- [ ] URL slug is lowercase, hyphen-separated, descriptive, no stop-word noise,
  no dates/IDs unless meaningful, <= ~60 chars.
- [ ] Internal links use descriptive anchor text (never "click here"/"read
  more"); page links to >= 2-3 relevant internal pages.
- [ ] Every meaningful `<img>` has descriptive `alt`; decorative images use
  `alt=""`. Filenames are descriptive. Below-fold images use `loading="lazy"`.

**Site config**
- [ ] `robots.txt` exists, does not block CSS/JS, references the sitemap
  (`Sitemap: https://.../sitemap.xml`). (AI-bot rules -> ai-crawler-access.)
- [ ] `sitemap.xml` exists, lists canonical URLs only, valid `<lastmod>`, no
  noindex/redirected URLs.
- [ ] Page is indexable: no accidental `noindex` meta or `X-Robots-Tag`.

**Core Web Vitals (guidance — flag likely issues from the markup)**
- [ ] LCP < 2.5s: preload the hero image/font, avoid render-blocking CSS/JS, set
  explicit `width`/`height`, serve modern formats (WebP/AVIF).
- [ ] CLS < 0.1: set dimensions on images/embeds/ads, reserve space, use
  `font-display: swap` with metric-adjusted fallbacks.
- [ ] INP < 200ms: minimize long main-thread tasks, defer non-critical JS, break
  up heavy event handlers.

## Scoring rubric (0-100)

Award each category from 0 to its max. Full = PASS, ~half = WARN, 0 = FAIL.

| # | Category | Max | What earns full points |
|---|----------|-----|------------------------|
| 1 | Title tag | 12 | One `<title>`, <= 60 chars, keyword front-loaded, brand last |
| 2 | Meta description | 8 | 120-155 chars, action-oriented, unique, keyword present |
| 3 | H1 + heading hierarchy | 12 | Exactly one `<h1>`; no skipped levels; keyword in H1 |
| 4 | Keyword placement | 12 | Keyword in title, H1, first 100 words, a subheading; no stuffing |
| 5 | URL slug | 6 | Lowercase, hyphenated, descriptive, concise |
| 6 | Internal linking | 10 | >= 2-3 relevant links, all descriptive anchor text |
| 7 | Image alt text | 8 | All meaningful imgs have alt; decorative `alt=""` |
| 8 | Canonical | 6 | Valid self-referential absolute HTTPS canonical |
| 9 | Open Graph + Twitter Card | 8 | All required OG + Twitter tags with valid image |
| 10 | Sitemap + robots.txt | 6 | Both present, valid, sitemap referenced, CSS/JS not blocked |
| 11 | Core Web Vitals | 12 | No markup-level LCP/CLS/INP red flags |

**Total = 100.** Bands: **90-100** excellent, **75-89** solid (ship after P0/P1),
**50-74** needs work, **< 50** failing foundation — fix before any GEO/AEO work.

For the full itemized rubric with point-by-point deductions and copy-paste head
snippets, load `references/on-page-checklist.md`.

## Output

Print the report in exactly this structure, then wait for confirmation:

```
# SEO Audit — <page path or URL>
Primary keyword (inferred): "<keyword>"
Score: <N>/100 — <band>

## Category scores
1. Title tag .............. 9/12
2. Meta description ....... 4/8
... (all 11 categories)

## Findings (prioritized)
### P0 — Critical
- [Title] 78 chars, truncates in SERP. Keyword "<kw>" buried at char 52.
  Fix: "<proposed title>" (54 chars)  [file: src/pages/post.html]

### P1 — Important
- [Headings] Two <h1> tags. Demote the second to <h2>.  [file: ...]

### P2 — Polish
- [Alt text] 3 of 11 images missing alt. Suggested alts below.

## Proposed edits
<for each fix: file path, the exact old -> new snippet>

Apply these edits? (yes / pick numbers / no)
```

After the user confirms, apply only the approved edits to the correct source
files (page or head partial/layout, never compiled output). Then reprint the new
score. For any copy you authored (titles, descriptions, alt text), label it
`[DRAFT — verify]` so the user reviews wording and facts before publishing.

Never apply edits before the user confirms. Never block CSS/JS, change
canonicals to a different page, or remove existing tags without flagging why.

## Examples

**Before -> after: title + meta (a SaaS blog post)**

Before:
```html
<title>Blog Post About How To Reduce Customer Churn For Your SaaS Company</title>
<meta name="description" content="Read our blog.">
```
- Title: 67 chars, keyword "reduce churn" not front-loaded, no brand.
- Description: 11 chars, not action-oriented, no keyword. FAIL.

After:
```html
<title>Reduce SaaS Churn: 7 Proven Tactics | Acme</title>
<meta name="description" content="Cut SaaS churn with 7 proven retention tactics — onboarding, usage alerts, and win-back flows you can ship this quarter.">
```
- Title: 44 chars, keyword first, brand last. Description: 133 chars,
  action-oriented, keyword present. PASS. Score +14.

**Before -> after: heading hierarchy**

Before: `<h1>Pricing</h1>` then `<h3>Team plan</h3>` (skips `<h2>`), plus a
second `<h1>` in the footer logo.
After: footer logo uses `<p class="logo">`; section uses `<h2>Team plan</h2>`.
One `<h1>`, no skipped levels. PASS.

**Before -> after: internal link anchor**

Before: `Learn more <a href="/geo">here</a>.`
After: `Learn how to <a href="/geo">optimize for generative engines</a>.`
Descriptive anchor passes; cross-links the geo-optimize topic.

---
Part of **Intura Skills** — the self-service AI-visibility toolkit by [Intura](https://intura.co). Standalone; no account or API key required.
