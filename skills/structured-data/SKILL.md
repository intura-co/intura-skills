---
name: structured-data
description: Generates and validates schema.org JSON-LD structured data so search engines and AI answer engines (Google, ChatGPT, Perplexity, Gemini, Claude) correctly understand a page's entity. Use this when a user wants to add, fix, audit, or score structured data / rich-results markup — e.g. "add JSON-LD to this page", "generate schema.org markup", "add FAQ schema", "fix my structured data", "why isn't my rich result showing", "add Product/Article/Organization schema", "make my page eligible for rich snippets". It detects the page type, picks matching ready-to-fill templates (Organization, WebSite, Article/BlogPosting, FAQPage, QAPage, Product, BreadcrumbList, HowTo, Person, LocalBusiness), fills placeholders from the page's real visible content, combines types via @graph, checks required vs. recommended properties, flags fabricated review/rating data and wrong date formats, then inserts a <script type="application/ld+json"> block on confirmation.
---

# Structured Data (schema.org JSON-LD)

Add correct, non-fabricated schema.org JSON-LD to a page so search and AI engines
can identify the page's primary entity. Operate on local files only; require no
network or API. This skill pairs with sibling skills **seo-optimize** (on-page
fundamentals), **geo-optimize** (AI-answer visibility), and **aeo-optimize**
(FAQ/Q&A answer formatting).

## When to use

Use this skill when the user asks to:
- add, generate, or scaffold JSON-LD / schema.org / structured data / rich snippets;
- fix, audit, or validate existing structured data;
- diagnose why a rich result is not appearing;
- mark up a specific entity (article, product, FAQ, business, person, etc.).

Do not use it to write page copy or meta tags — route those to **seo-optimize**.
For authoring the visible FAQ/Q&A content itself, use **aeo-optimize**, then return
here to mark it up.

## Inputs

Detect these from the repo before asking the user anything:
1. **Target page.** The file the user named, the file currently open, or — if
   unspecified — ask which page (path or URL). Accept `.html`, `.jsx`/`.tsx`,
   `.vue`, `.astro`, `.md`/`.mdx` (front matter + body), or a templating layout.
2. **Visible content.** Read the page and extract real values: title/headline,
   author, publish/update dates, body text, prices, ratings, address, hours,
   images, breadcrumbs, FAQ pairs. JSON-LD must mirror what a human sees.
3. **Site-wide facts.** Canonical site URL, organization name, logo URL, social
   profile URLs. Look in existing JSON-LD, `<head>`, `sitemap.xml`, footer, or an
   `about`/`contact` page. Ask only for values you cannot find.
4. **Existing markup.** Grep for `application/ld+json` to avoid duplicating or
   conflicting with blocks already present.

If a required value genuinely cannot be found and cannot be inferred from visible
content, ask the user — never invent it.

## Workflow

1. **Locate the target page** and read its full content. Note the framework so you
   know where `<head>` is (raw HTML, a layout/partial, or a framework `<Head>`/
   metadata component).
2. **Classify the page intent** and pick the type(s) using the decision table
   below. A page often needs more than one type (e.g. an article page also has a
   breadcrumb; a homepage has Organization + WebSite).
3. **Load the matching template(s)** from `templates/` (see map below). Each is
   valid JSON with `<PLACEHOLDER>` tokens and example ISO dates.
4. **Fill placeholders from real, visible content.** Replace every token. Delete
   any property you cannot fill truthfully rather than leaving it blank or faked.
   Convert all dates to ISO 8601 and make all URLs absolute.
5. **Combine into one `@graph`** when the page needs multiple types. Give each
   node a stable `@id` and cross-reference by `@id` instead of duplicating data.
6. **Validate** with the checklist below (well-formed JSON, required properties,
   no fabrication, ISO formats, absolute URLs). For full per-type tables and the
   testing procedure, load `references/validation.md`.
7. **Score** the result 0-100 with the rubric below.
8. **Print the report** (see Output). On user confirmation, insert the
   `<script type="application/ld+json">` block into `<head>` of the target file.

## Choosing the type

| Page intent | Primary type | Template |
| --- | --- | --- |
| Homepage / brand identity | Organization (+ WebSite) | `organization.json`, `website.json` |
| Site root with on-site search | WebSite + SearchAction | `website.json` |
| Blog post / news / editorial | BlogPosting / Article / NewsArticle | `article.json` |
| Site-authored FAQ list | FAQPage | `faqpage.json` |
| User-generated single Q&A thread | QAPage | `qapage.json` |
| Product / pricing / e-commerce | Product (+ Offer, AggregateRating) | `product.json` |
| Any deep page (breadcrumb trail) | BreadcrumbList | `breadcrumblist.json` |
| Step-by-step tutorial / recipe-like guide | HowTo | `howto.json` |
| Author / team / bio page | Person | `person.json` |
| Physical location / local service | LocalBusiness (or subtype) | `localbusiness.json` |

Rules of thumb: use **FAQPage** only for Q&A the site authored; use **QAPage**
only for community/user Q&A (and never both on one page). Use a specific
**LocalBusiness** subtype (`Restaurant`, `Dentist`, `Store`...) when it applies.
Add **BreadcrumbList** to almost any non-home page.

Templates live in `skills/structured-data/templates/`. Load a template only when
the page needs that type.

## Validation checklist (run every time)

Mark each item pass/fail; any fail must be fixed or the offending property removed.

- [ ] **Well-formed JSON.** Parses with no errors (`JSON.parse` / `json.load`).
- [ ] **Correct `@context`** = `https://schema.org` and an appropriate `@type`.
- [ ] **Type matches page intent** (per the table above).
- [ ] **All required properties present** for each type (see `references/validation.md`).
- [ ] **No fabricated data.** Ratings, reviews, prices, dates, authors, and counts
      exist and are visible on the page. If reviews are not shown, omit
      `aggregateRating`/`review` entirely.
- [ ] **Values match visible content** word-for-word where applicable.
- [ ] **Dates/times are ISO 8601** (`2026-01-15`, `2026-01-15T08:00:00+00:00`,
      durations like `PT30M`). No "Jan 15, 2026", no "30 minutes".
- [ ] **URLs are absolute** (`https://...`) for `url`, `image`, `logo`, `item`, `@id`.
- [ ] **`headline` <= 110 characters** (Article/BlogPosting).
- [ ] **No placeholder tokens or template example values** remain (`<...>`, `4.6`,
      `37.7749`, `+1-555-555-0100`, etc.).
- [ ] **`@graph` wiring is sound** — every referenced `@id` exists; no duplicate or
      conflicting node definitions.
- [ ] **Single source of truth** — one JSON-LD block per page where practical; no
      conflict with pre-existing markup.

## Scoring rubric (0-100)

Score the proposed block by summing the weighted criteria. Report the total and
each line. Treat < 70 as "not ready — fix the flagged items before inserting".

| Criterion | Weight | How to score |
| --- | --- | --- |
| **Type correctness** | 20 | Full 20 if `@type` matches page intent and uses the most specific appropriate type; 0 if mismatched. |
| **Required properties** | 25 | Proportion of required properties present and non-empty across all types on the page. |
| **Recommended properties** | 15 | Proportion of recommended properties sensibly filled (don't pad with junk). |
| **Data integrity** | 20 | Full 20 only if every value is truthful and visible on the page. Any fabricated rating/review/price/date = 0 for this whole criterion. |
| **Syntax & formats** | 10 | Well-formed JSON, ISO 8601 dates/durations, absolute URLs, correct `@context`. Deduct per defect. |
| **Placement & graph wiring** | 10 | Correct `<head>` placement plan, valid `@id`s, working cross-references, no duplicate blocks. |

A block with any fabricated review/rating data is capped at 60 overall regardless
of other scores, and must be flagged as a spam risk.

## Output

Print this exact report, then wait for confirmation before editing files:

```
## Structured Data Report — <page path or URL>

Detected intent: <intent>
Types applied:   <Type1, Type2, ...>
Templates used:  <file1.json, file2.json, ...>

Score: <N>/100
- Type correctness ......... <x>/20
- Required properties ...... <x>/25
- Recommended properties ... <x>/15
- Data integrity ........... <x>/20
- Syntax & formats ......... <x>/10
- Placement & graph wiring . <x>/10

Required properties: <all present | missing: prop, prop>
Warnings:            <fabrication risks, content mismatches, format issues, or "none">

Proposed JSON-LD:
<the full <script type="application/ld+json"> block, formatted>

Placement: <head> of <file path>
Apply this change? (yes / no)
```

On **yes**: insert the `<script type="application/ld+json"> ... </script>` block
into the `<head>` of the target file (or the framework's head/metadata slot). If a
conflicting block exists, replace it rather than adding a second. For non-HTML
formats (MDX/front matter, JSX components), insert using that framework's standard
mechanism and tell the user exactly where it went. On **no**: make the requested
adjustments and reprint the report. Never edit files before the user confirms.

## Examples

### Example 1 — Blog post with no markup -> BlogPosting

Before (`/blog/geo-guide.html`, head has only title + meta description):
```html
<head>
  <title>The 2026 GEO Playbook</title>
  <meta name="description" content="How to get cited by AI answer engines.">
</head>
```
Visible on the page: H1 "The 2026 GEO Playbook", byline "By Maya Chen",
"Published Jan 15, 2026 · Updated Feb 2, 2026", ~1,200 words, hero image.

After (inserted into `<head>`):
```html
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "BlogPosting",
  "@id": "https://example.com/blog/geo-guide/#article",
  "headline": "The 2026 GEO Playbook",
  "description": "How to get cited by AI answer engines.",
  "image": ["https://example.com/img/geo-guide-hero.png"],
  "datePublished": "2026-01-15T08:00:00+00:00",
  "dateModified": "2026-02-02T10:30:00+00:00",
  "author": { "@type": "Person", "name": "Maya Chen", "url": "https://example.com/authors/maya-chen" },
  "publisher": {
    "@type": "Organization",
    "name": "Example Co",
    "logo": { "@type": "ImageObject", "url": "https://example.com/img/logo.png" }
  },
  "mainEntityOfPage": { "@type": "WebPage", "@id": "https://example.com/blog/geo-guide/" },
  "wordCount": 1200,
  "inLanguage": "en"
}
</script>
```
Note how "Jan 15, 2026" became ISO `2026-01-15T08:00:00+00:00`, the relative logo
path became absolute, and no rating/review was invented.

### Example 2 — Fixing a fabricated Product rating

Before (existing block, but the page shows no reviews anywhere):
```json
{ "@context": "https://schema.org", "@type": "Product", "name": "Acme Widget",
  "aggregateRating": { "@type": "AggregateRating", "ratingValue": "5", "reviewCount": "999" } }
```
Report finding: `Data integrity 0/20 — aggregateRating present but no visible
reviews. Spam risk; overall score capped at 60.` After: remove `aggregateRating`
and add the real `offers` (price, priceCurrency, availability) that the page shows.

---
Part of **Intura Skills** — the self-service AI-visibility toolkit by [Intura](https://intura.co). Standalone; no account or API key required.
