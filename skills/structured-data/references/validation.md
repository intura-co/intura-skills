# Structured Data — Validation Reference

Load this when you need the exact required/recommended properties for a type, the
full pitfall list, or the step-by-step testing procedure. All rules below work
offline; the validator URLs are optional confirmation aids, not requirements.

---

## How to test (offline first, then optional online)

1. **Well-formed JSON (offline, always do this).** Parse the candidate block.
   - Node: `node -e "JSON.parse(require('fs').readFileSync('block.json','utf8'))"`
   - Python: `python3 -c "import json,sys; json.load(open('block.json'))"`
   - A parse error means the markup is invalid. Fix before anything else.
2. **Required-property check (offline).** Compare against the per-type tables
   below. Every required property must be present and non-empty.
3. **Data-integrity check (offline).** Confirm every value also appears in the
   page's visible content. No invented ratings, prices, dates, or authors.
4. **Optional online confirmation** (only if the user has network access and asks):
   - schema.org validator: https://validator.schema.org/ (syntax + vocabulary)
   - Google Rich Results Test: https://search.google.com/test/rich-results
     (eligibility for Google rich results)
   - Schema Markup Validator (paste the rendered HTML or the JSON-LD block)
   Do not block delivery on these; they require a network the skill must not assume.

---

## Required vs. recommended properties per type

"Required" = Google's rich-result minimum or the property without which the
entity is meaningless. "Recommended" = strongly improves coverage and AI
comprehension. Property names are case-sensitive.

### Organization
| Required | Recommended |
| --- | --- |
| `name`, `url` | `logo`, `description`, `sameAs`, `contactPoint`, `email`, `telephone`, `foundingDate`, `@id` |

### WebSite
| Required | Recommended |
| --- | --- |
| `name`, `url` | `potentialAction` (SearchAction), `publisher` (`@id` of Organization), `inLanguage`, `description`, `@id` |
- SearchAction `query-input` must be exactly `required name=search_term_string`
  and the `urlTemplate` must contain `{search_term_string}`.

### Article / BlogPosting / NewsArticle
| Required | Recommended |
| --- | --- |
| `headline`, `image`, `datePublished`, `author` (`@type` + `name`) | `dateModified`, `publisher` (with `logo`), `mainEntityOfPage`, `description`, `articleSection`, `keywords`, `wordCount`, `inLanguage`, `@id` |
- `headline` <= 110 characters (longer is truncated/ignored).
- `author.name` must be a real person or organization, not "Admin".

### FAQPage
| Required | Recommended |
| --- | --- |
| `mainEntity` (array of `Question`), each `Question.name`, each `Question.acceptedAnswer.text` | `@id`, `inLanguage` |
- Use FAQPage ONLY when the Q&A is authored by the site (not user-submitted).
- Every Q and A must be visible on the page. See sibling skill **aeo-optimize**.

### QAPage
| Required | Recommended |
| --- | --- |
| `mainEntity` (single `Question`), `Question.name`, `Question.answerCount`, at least one `acceptedAnswer` OR `suggestedAnswer` with `text` | `author`, `dateCreated`, `upvoteCount`, `url` on answers, `@id` |
- Use QAPage for user-generated Q&A (one question per page with community answers).
- Do not use both FAQPage and QAPage on the same page.

### Product
| Required | Recommended |
| --- | --- |
| `name`, `image`, plus at least one of `offers` / `review` / `aggregateRating` | `description`, `sku`, `mpn`, `brand`, `gtin`, `@id` |
- `offers.Offer` required when present: `price`, `priceCurrency`, `availability`.
  Recommended: `priceValidUntil`, `itemCondition`, `url`, `seller`.
- `aggregateRating` required when present: `ratingValue`, plus `reviewCount` OR
  `ratingCount`. Recommended: `bestRating`, `worstRating`.
- `price` as a string with a dot decimal ("49.00"); no currency symbol, no commas.

### BreadcrumbList
| Required | Recommended |
| --- | --- |
| `itemListElement` (array of `ListItem`), each `position`, each `name`, `item` (URL) for every crumb except the last | `@id` |
- `position` is 1-based and contiguous (1, 2, 3 ...).
- The final breadcrumb (current page) may omit `item`.

### HowTo
| Required | Recommended |
| --- | --- |
| `name`, `step` (array of `HowToStep`), each `HowToStep.text` | `description`, `image`, `totalTime`, `estimatedCost`, `supply`, `tool`, per-step `name`/`image`/`url`, `@id` |
- `totalTime` is an ISO 8601 duration (e.g. `PT30M`, `PT1H30M`), not "30 minutes".

### Person
| Required | Recommended |
| --- | --- |
| `name` | `url`, `image`, `jobTitle`, `description`, `worksFor`, `sameAs`, `knowsAbout`, `givenName`, `familyName`, `alumniOf`, `@id` |
- `sameAs` to authoritative profiles strengthens entity disambiguation for AI
  engines. See sibling skill **geo-optimize**.

### LocalBusiness
| Required | Recommended |
| --- | --- |
| `name`, `address` (`PostalAddress` with `streetAddress`, `addressLocality`, `addressCountry`) | `telephone`, `geo`, `openingHoursSpecification`, `priceRange`, `image`, `url`, `sameAs`, `email`, `@id` |
- Use a more specific subtype where it applies (`Restaurant`, `Dentist`,
  `Store`, etc.) — it inherits all LocalBusiness properties.
- `opens`/`closes` use 24-hour `HH:MM`; `dayOfWeek` uses full English day names.

---

## Common pitfalls (reject the block if any apply)

1. **Fabricated review / rating data.** Never invent `aggregateRating`,
   `reviewCount`, `ratingValue`, `review`, or `upvoteCount`. Include them ONLY
   when matching, visible reviews exist on the page. Fake ratings are a manual
   spam action and can remove the whole site from rich results.
2. **Mismatched visible content.** Every value in JSON-LD must be present and
   visible to a human on the page. Markup-only content (hidden prices, hidden
   FAQs, authors not shown) is a violation.
3. **Missing required properties.** A block missing any required property is
   ineligible. Check the tables above before output.
4. **Wrong date/time formats.** Use ISO 8601 only.
   - Date: `2026-01-15`
   - Date-time with offset: `2026-01-15T08:00:00+00:00` (preferred for
     `datePublished`/`dateModified`).
   - Duration: `PT30M`, `PT1H30M`, `P2D`. Never "Jan 15, 2026" or "30 min".
5. **Relative URLs.** `url`, `image`, `logo`, `item`, and `@id` must be absolute
   (`https://example.com/...`), never `/about` or `img/logo.png`.
6. **Type/intent mismatch.** Don't mark a category listing as `Product`, or a
   site-authored FAQ as `QAPage`. Match type to page intent.
7. **Multiple conflicting blocks.** Prefer one `<script type="application/ld+json">`
   per page containing an `@graph` array. If separate blocks exist, ensure they
   don't redefine the same `@id` differently.
8. **Broken `@id` references.** When one node references another (e.g. WebSite
   `publisher` -> Organization), the referenced `@id` must exist on the page.
9. **HTML in the wrong place.** FAQ/QA `Answer.text` may contain limited HTML
   (`<p>`, `<a>`, `<ul>`, `<li>`, `<b>`); other text properties should be plain.
10. **Placeholder leakage.** Never ship `<...>` placeholder tokens or example
    values (e.g. `4.6`, `37.7749`) from a template. Replace every one or delete
    the property.
11. **Empty / null values.** Remove properties you cannot fill rather than
    leaving `""`, `null`, or `0`.

---

## @graph wiring quick rules

- One top-level object: `{ "@context": "https://schema.org", "@graph": [ ... ] }`.
- Give each node a stable `@id` using a URL + fragment (`<url>/#organization`,
  `<url>/#website`, `<page>/#article`).
- Reference, don't duplicate: a node points to another with `{ "@id": "<url>/#organization" }`.
- Typical homepage graph: `Organization` + `WebSite` (+ `BreadcrumbList`).
- Typical article page graph: `BlogPosting` + `BreadcrumbList` (+ `Organization`
  as `publisher` by `@id`).
