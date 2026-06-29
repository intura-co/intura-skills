# llms.txt format spec, llms-full.txt build, and hosting

Load this when you need the precise format rules, the procedure for building
`llms-full.txt`, or hosting/maintenance guidance. Source: the llmstxt.org
proposal (Answer.AI, 2024-2025), current as of 2026. It is a community
convention, not an IETF/W3C standard — follow it exactly so that the growing
set of tools and agents that read `llms.txt` can parse the file.

## 1. The exact structure of `llms.txt`

The file is **markdown**, parsed in a fixed order. Emit elements in this order:

1. **H1 — required, exactly one.** The name of the site or project.
   `# Project Name`
2. **Blockquote summary — required.** A single `>` line giving a one-sentence
   description. Keep it <= ~160 characters. Plain text only.
   `> A short, information-dense summary of what this is.`
3. **Context prose — optional.** Zero or more short markdown paragraphs after
   the blockquote, giving extra context (what the file covers, how sections are
   ordered, any notes for agents). No headings here, but inline emphasis,
   links, and lists are allowed. Keep it tight.
4. **H2 sections — one or more.** Each `## Section` is followed by a markdown
   bullet list. Section names are free-form and descriptive; common ones are
   `Docs`, `Guides`, `API`, `Examples`, `Product`, `Blog`, `Company`,
   and the special `Optional`.
5. Each bullet is a **link with an optional note**, in this exact shape:

   ```
   - [Human Title](https://absolute.url/path): one-line note about the page.
   ```

   - The link text is the page title.
   - The URL must be **absolute** and should be `https://`.
   - The note is everything after `): ` — keep it <= ~100 characters, one line.
   - A bullet with no note (`- [Title](https://url)`) is valid but discouraged.

### The `Optional` section

A section literally named `## Optional` has special meaning: its links are
**lower priority**, and an agent **may skip them** when its context window is
tight. Put it **last**. Use it for changelogs, deep blog archives, legal/policy
pages, status pages, and secondary content.

### Hard rules (a parser-valid file)

- Exactly one H1; it is the first non-blank line.
- The blockquote immediately follows the H1 (after at most one blank line).
- Only H1 and H2 headings. No H3+ inside the link sections.
- Links are markdown links with absolute URLs. No bare URLs, no relative paths.
- No YAML front matter, no HTML tags, no code fences around the whole file.
- UTF-8, Unix newlines. Served as `text/plain` or `text/markdown`.

### Minimal valid skeleton

```markdown
# Project Name

> One-sentence summary of what this project or site is.

Optional context paragraph describing what these links cover.

## Docs

- [Quickstart](https://example.com/start): get running in five minutes.
- [API reference](https://example.com/api): full endpoint and type docs.

## Optional

- [Changelog](https://example.com/changelog): release notes.
```

## 2. `llms-full.txt`

`llms-full.txt` serves the same purpose but **inlines the full content** of the
key pages so an agent can read everything in one fetch, without following
links. It is larger and is meant to be consumed whole.

### How to build it

1. Start from the curated link list in `llms.txt` (skip most `## Optional`
   links unless the user wants maximum coverage).
2. Keep the same header block: H1, blockquote summary, and any context prose.
3. For **each** selected page, append a section:

   ```markdown
   ## <Page Title>

   Source: https://absolute.url/path

   <full body content of the page as clean markdown>
   ```

4. Convert each page body to clean markdown: keep headings (demote so they sit
   below the page's H2 — i.e. the page's own H1 becomes H2 or H3), paragraphs,
   lists, tables, and code blocks. **Strip** site navigation, headers/footers,
   cookie banners, ads, share widgets, and other chrome.
5. Preserve reading order and section structure of each page.

### Size discipline

- Warn the user if the result exceeds **~1 MB or ~250k tokens**. Very large
  files defeat the purpose and may exceed context windows.
- If too large: trim to the highest-value pages, drop `## Optional` content, or
  produce per-section files (e.g. `llms-full-docs.txt`). `llms.txt` stays the
  small index either way.

### Skeleton

```markdown
# Project Name

> One-sentence summary.

## Quickstart

Source: https://example.com/start

Install the package with `npm i example`. Then…
(full cleaned body of the page)

## API reference

Source: https://example.com/api

The API exposes the following endpoints…
(full cleaned body of the page)
```

## 3. Hosting

- The canonical location is the **domain root**: `https://yourdomain.com/llms.txt`
  (and `https://yourdomain.com/llms-full.txt`). Agents look there first.
- Place the file where the site generator publishes root-level static assets:
  - Static/Jamstack (Next.js, Astro, Docusaurus, VitePress, Gatsby): `public/`
    or `static/` → served at root.
  - Plain HTML site: the web root directory.
  - Reverse proxy / framework backends: add a route that returns the file with
    `Content-Type: text/plain; charset=utf-8`.
- It must return **HTTP 200** as text. Do not gate it behind auth or a paywall.
- Subdomains and large doc sites may host their own `llms.txt` at their root
  (e.g. `https://docs.yourdomain.com/llms.txt`).

### Crawler access (important)

A perfect `llms.txt` is worthless if bots cannot fetch it. Confirm:

- `robots.txt` does not `Disallow: /llms.txt` (or the directory it lives in).
- CDN/WAF/bot-management (Cloudflare, Fastly, Akamai) does not block AI user
  agents from the file.
- Run the **ai-crawler-access** sibling skill to audit `robots.txt`, AI-bot
  allow/deny rules, and CDN settings end to end.

## 4. Maintenance

- **Regenerate when structure changes:** new docs sections, renamed/removed
  pages, new top-level products. Stale links lower trust and the Coverage and
  Freshness rubric scores.
- **Re-validate links** periodically; remove anything returning 404/redirects.
- **Keep `llms-full.txt` in sync** with `llms.txt` — if a page is added to the
  index and matters, inline it; if removed, drop its inlined section.
- Treat both files as **build artifacts**: re-run this skill in CI or on each
  significant content release rather than hand-editing.

## 5. How `llms.txt` fits the AI-visibility stack

- **structured-data** — JSON-LD/schema.org makes each individual page
  machine-readable. `llms.txt` curates *which* pages matter site-wide. Use both.
- **geo-optimize / aeo-optimize** — improve the page bodies themselves for
  generative and answer engines once agents can discover them.
- **seo-optimize** — `sitemap.xml` is the input for discovery; `llms.txt` is the
  curated, LLM-facing complement to it.

## 6. Validation aids (optional, online)

These public tools can help eyeball a file but are **not required** — this skill
validates fully offline against the checklist above:

- `https://llmstxt.org` — the proposal and examples.
- `https://directory.llmstxt.cloud` — a public directory of real `llms.txt`
  files to compare structure against.

Do not depend on any network call for the core function; treat these as
reference only.
