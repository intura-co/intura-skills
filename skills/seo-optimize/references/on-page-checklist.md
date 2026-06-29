# On-page SEO checklist — full reference

Load this when you need exact limits, per-point rubric deductions, or
copy-paste good/bad snippets for head tags. SKILL.md has the summary; this file
has the detail. All limits are current as of 2026.

---

## 1. Title tag — 12 pts

**Limits**
- Length: aim 50-60 chars; hard cap ~60 (Google truncates near ~580px /
  ~600px on desktop). Under 30 chars wastes the slot.
- Exactly one `<title>` per page.
- Primary keyword in the first ~30 characters (front-loaded).
- Pattern: `Primary Keyword - Secondary/Benefit | Brand`. Brand last (drop it on
  the homepage where the brand IS the keyword).
- Unique across every page. No keyword stuffing, no ALL CAPS, no clickbait.

**Scoring deductions (from 12)**
- More than one or zero `<title>`: 0.
- Over 60 chars (truncates): -4. Over 70: -7.
- Keyword absent: -6. Keyword present but not front-loaded: -3.
- Duplicated across pages: -3.

**Good**
```html
<title>Reduce SaaS Churn: 7 Proven Tactics | Acme</title>   <!-- 44 chars -->
```
**Bad**
```html
<title>Home</title>                                          <!-- no keyword/brand -->
<title>Churn Churn Reduction Reduce Customer Churn SaaS Churn Tool</title>  <!-- stuffed -->
<title>Blog Post About How To Reduce Customer Churn For Your SaaS Company</title> <!-- 67 chars, buried kw -->
```

---

## 2. Meta description — 8 pts

**Limits**
- Length: 120-155 chars (Google truncates ~155-160 on desktop, less on mobile).
- One per page, unique. Action-oriented (start with a verb where natural).
- Include the primary keyword once, naturally (Google bolds matched terms).
- It is a click magnet, not a ranking factor — write for the human in the SERP.
- No double quotes that break the HTML attribute; no leading/trailing spaces.

**Scoring deductions (from 8)**
- Missing: 0. Present but < 70 or > 165 chars: -3.
- Not action-oriented / generic ("Welcome to our site"): -3.
- Keyword absent: -2. Duplicated across pages: -2.

**Good**
```html
<meta name="description" content="Cut SaaS churn with 7 proven retention tactics — onboarding, usage alerts, and win-back flows you can ship this quarter."> <!-- 133 chars -->
```
**Bad**
```html
<meta name="description" content="Read our blog.">                <!-- generic, no kw -->
<meta name="description" content="churn, saas, retention, customer success, reduce churn, b2b">  <!-- keyword list -->
```

---

## 3. H1 + heading hierarchy — 12 pts

**Rules**
- Exactly one `<h1>` per page. It states the page topic and contains the primary
  keyword. It may differ from `<title>` (title targets SERP, H1 targets reader).
- Headings descend in order: `h1 -> h2 -> h3`. Never skip a level (no `h2 ->
  h4`). Don't pick a heading level for its default font size — style with CSS.
- Headings describe the section beneath them; the outline reads like a TOC.
- Common bug: a site logo, slogan, or card title wrapped in a second `<h1>`.

**Scoring deductions (from 12)**
- Zero or multiple `<h1>`: -6.
- Any skipped heading level: -3 per offense (cap -6).
- Keyword absent from `<h1>`: -3.

**Good**
```html
<h1>How to Reduce SaaS Churn</h1>
  <h2>Why customers churn</h2>
    <h3>Onboarding gaps</h3>
  <h2>7 tactics that work</h2>
```
**Bad**
```html
<h1>Acme</h1>          <!-- logo as h1 -->
<h1>How to Reduce Churn</h1>   <!-- second h1 -->
  <h4>Why customers churn</h4>  <!-- skipped h2 and h3 -->
```

---

## 4. Keyword placement & density — 12 pts

**Rules**
- Place the primary keyword in: `<title>`, `<h1>`, the first 100 words of body
  copy, and at least one `<h2>`/`<h3>`. Add 1-2 semantic variants / synonyms.
- Keyword density ~0.5-2% of body words. Above ~3% reads as stuffing and risks a
  spam signal. Write for humans; match search intent, not exact-match repetition.
- Cover the topic comprehensively (entities, related questions) rather than
  repeating one phrase — modern ranking rewards topical depth.

**Scoring deductions (from 12)**
- Keyword missing from first 100 words: -4. Missing from all subheadings: -3.
- Density > 3% (stuffing): -6. Exact-match anchor/keyword spam: -3.

**Good**: keyword appears once each in title, H1, intro sentence, one H2, then
synonyms throughout.
**Bad**: "Our churn tool reduces churn so your churn rate and SaaS churn drop —
best churn tool for churn." (stuffed).

---

## 5. URL slug — 6 pts

**Rules**
- Lowercase, hyphen-separated (`-`, never `_` or spaces/`%20`).
- Descriptive and concise (<= ~60 chars, 3-5 meaningful words). Include the
  keyword. Drop stop words (a, the, and, of) when they add no meaning.
- No dates, IDs, session params, or file extensions unless meaningful.
- Stable: don't change a live slug without a 301 redirect.

**Scoring deductions (from 6)**
- Underscores/uppercase/spaces: -2. Non-descriptive (`/p?id=123`): -3.
- Stop-word bloat or > 75 chars: -2.

**Good**: `/blog/reduce-saas-churn`
**Bad**: `/blog/2026/03/Post_About_How_To_Reduce_Your_Customer_Churn_Final_v2`

---

## 6. Internal linking & anchor text — 10 pts

**Rules**
- Link to >= 2-3 relevant internal pages from the body content.
- Anchor text is descriptive and reflects the destination. Never "click here",
  "read more", "this", or a bare URL for a content link.
- Vary anchors naturally; don't over-optimize the same exact-match anchor.
- Fix broken internal links and orphan pages (pages with no inbound links).

**Scoring deductions (from 10)**
- Fewer than 2 internal links: -4.
- Generic anchors ("click here"): -2 each (cap -6).
- Broken internal link found: -3.

**Good**: `Learn how to <a href="/geo">optimize for generative engines</a>.`
**Bad**: `Learn more <a href="/geo">here</a>.`

---

## 7. Image alt text — 8 pts

**Rules**
- Every meaningful `<img>` has descriptive `alt` (what it shows / its purpose,
  not "image of"). Include the keyword only when genuinely relevant.
- Decorative images use empty `alt=""` (so screen readers skip them).
- Descriptive filenames (`reduce-saas-churn-chart.webp`, not `IMG_2931.png`).
- Below-the-fold images: `loading="lazy"`. Hero/LCP image: NOT lazy.

**Scoring deductions (from 8)**
- Missing `alt` on meaningful images: -2 each (cap -6).
- Stuffed alt ("churn churn tool churn"): -3.
- Decorative images with verbose alt: -1.

**Good**
```html
<img src="reduce-saas-churn-chart.webp" width="800" height="450"
     alt="Line chart showing churn dropping from 6% to 3% after onboarding fixes"
     loading="lazy">
```
**Bad**
```html
<img src="IMG_2931.png" alt="image">
<img src="hero.jpg" alt="churn saas churn b2b churn reduce">
```

---

## 8. Canonical tag — 6 pts

**Rules**
- One `rel=canonical` in `<head>`, absolute HTTPS URL.
- Self-referential by default (page points to its own clean URL).
- Use it to consolidate duplicates (params, print views, pagination, syndicated
  copies point to the original). Don't canonicalize every page to the homepage.
- Canonical must match the URL in the sitemap and the OG `og:url`.

**Scoring deductions (from 6)**
- Missing: -3. Relative or HTTP URL: -2.
- Points to an unrelated/parent page incorrectly: -4.
- Conflicting multiple canonicals: -3.

**Good**
```html
<link rel="canonical" href="https://acme.com/blog/reduce-saas-churn">
```
**Bad**
```html
<link rel="canonical" href="/blog/reduce-saas-churn">     <!-- relative -->
<link rel="canonical" href="https://acme.com/">           <!-- all pages -> home -->
```

---

## 9. Open Graph + Twitter Card — 8 pts

**Required OG**: `og:title`, `og:description`, `og:type` (`website`/`article`),
`og:url` (= canonical), `og:image`, plus `og:image:alt`. Recommended:
`og:site_name`, `og:locale`, and for articles `article:published_time`.

**Image specs**: absolute HTTPS URL, 1200x630 (1.91:1), < 5MB, JPG/PNG/WebP.

**Required Twitter**: `twitter:card` = `summary_large_image`, `twitter:title`,
`twitter:description`, `twitter:image`. Optional `twitter:site`/`twitter:creator`.

**Scoring deductions (from 8)**
- No OG tags at all: 0. Missing `og:image`: -3.
- Relative `og:image`/`og:url`: -2. Missing Twitter card: -2.
- `og:url` != canonical: -2.

**Good (copy-paste skeleton)**
```html
<meta property="og:title" content="Reduce SaaS Churn: 7 Proven Tactics">
<meta property="og:description" content="Cut SaaS churn with 7 proven retention tactics you can ship this quarter.">
<meta property="og:type" content="article">
<meta property="og:url" content="https://acme.com/blog/reduce-saas-churn">
<meta property="og:image" content="https://acme.com/img/reduce-saas-churn-og.png">
<meta property="og:image:alt" content="Churn dropping from 6% to 3% on a line chart">
<meta property="og:site_name" content="Acme">
<meta name="twitter:card" content="summary_large_image">
<meta name="twitter:title" content="Reduce SaaS Churn: 7 Proven Tactics">
<meta name="twitter:description" content="Cut SaaS churn with 7 proven retention tactics you can ship this quarter.">
<meta name="twitter:image" content="https://acme.com/img/reduce-saas-churn-og.png">
```
**Bad**: no OG/Twitter tags (links share as a bare blue URL); or `og:image`
set to a relative path that won't render off-domain.

---

## 10. Sitemap.xml + robots.txt — 6 pts

**robots.txt** (site root, `/robots.txt`)
- Must exist and not block CSS/JS or important content.
- References the sitemap: `Sitemap: https://acme.com/sitemap.xml`.
- Keep classic crawler rules minimal. AI-bot rules (GPTBot, ClaudeBot,
  Google-Extended, PerplexityBot, CCBot) belong in **ai-crawler-access** — do
  not author them here.

```
User-agent: *
Allow: /
Disallow: /admin/
Sitemap: https://acme.com/sitemap.xml
```

**sitemap.xml** (site root)
- Valid XML, UTF-8, canonical URLs only (no noindex/redirected/duplicate URLs).
- Accurate `<lastmod>`. Split into a sitemap index if > 50,000 URLs or > 50MB.
- Submit in Google Search Console / Bing Webmaster Tools (note to user; offline).

```xml
<?xml version="1.0" encoding="UTF-8"?>
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
  <url>
    <loc>https://acme.com/blog/reduce-saas-churn</loc>
    <lastmod>2026-06-29</lastmod>
  </url>
</urlset>
```

**Scoring deductions (from 6)**
- robots.txt missing: -2. Blocks CSS/JS or whole site by mistake: -4.
- Sitemap missing: -2. Sitemap lists noindex/redirected URLs: -2.

**Indexability cross-check**: ensure the page has no accidental
`<meta name="robots" content="noindex">` or `X-Robots-Tag: noindex` header.

---

## 11. Core Web Vitals — 12 pts

Thresholds (75th percentile of real users, "good" bar):

| Metric | Good | Measures | Common markup-level fixes |
|--------|------|----------|----------------------------|
| LCP (Largest Contentful Paint) | < 2.5s | Load speed of main element | Preload hero image/font; `fetchpriority="high"` on hero; explicit `width`/`height`; WebP/AVIF; remove render-blocking CSS/JS; CDN |
| CLS (Cumulative Layout Shift) | < 0.1 | Visual stability | Set dimensions on images/iframes/ads/embeds; reserve ad/space slots; `font-display: swap` + size-adjust fallback; avoid inserting content above existing content |
| INP (Interaction to Next Paint) | < 200ms | Responsiveness | Break up long JS tasks; defer/`async` non-critical JS; debounce handlers; minimize third-party scripts; avoid huge DOM |

INP replaced FID as a Core Web Vital in March 2024 — score INP, not FID.

You assess these from the markup (you cannot run a lab test offline). Flag
likely regressions: hero image with no dimensions and lazy-loaded; multiple
render-blocking scripts in `<head>`; web fonts with no `font-display`; large
inline `<script>` blocks; missing `width`/`height` on images. Recommend the user
verify with PageSpeed Insights / Lighthouse / CrUX (optional, online).

**Scoring deductions (from 12)**
- LCP red flags (lazy hero, no preload, render-blocking head JS): -4.
- CLS red flags (images/embeds without dimensions, no font-display): -4.
- INP red flags (heavy synchronous third-party JS, no defer): -4.

---

## Priority mapping for the report

- **P0 (Critical)** — missing/duplicate `<title>` or `<h1>`, `noindex` on a page
  that should rank, broken canonical, blocked CSS/JS in robots.txt.
- **P1 (Important)** — title/description over limit, skipped heading levels,
  keyword missing from H1/first 100 words, missing OG image, missing alt on
  key images, missing sitemap reference.
- **P2 (Polish)** — anchor-text wording, minor density tuning, image
  filenames, `loading="lazy"` on below-fold images, OG niceties.

## Hand-offs

- AI-bot crawl rules / llms.txt -> **ai-crawler-access**
- JSON-LD / rich-result schema -> **structured-data**
- Direct-answer & Q&A formatting -> **aeo-optimize**
- Citations in ChatGPT / Perplexity / AI Overviews -> **geo-optimize**
