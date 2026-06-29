---
name: llms-txt
description: >-
  Generates and audits llms.txt and llms-full.txt files for a website or repo,
  following the llmstxt.org proposal, so LLMs and AI agents get a clean, curated
  map of the most useful pages instead of crawling raw HTML. Discovers site
  structure (sitemap.xml, docs/ or content/ folders, key marketing pages,
  README), selects and prioritizes URLs, then writes /llms.txt (a curated index
  with an H1 title, a blockquote summary, and H2 sections of annotated links)
  and optionally /llms-full.txt (the same pages inlined into one document).
  Scores existing files 0-100 against the spec and applies fixes. Use when the
  user says things like "create an llms.txt", "generate llms-full.txt", "give
  LLMs a map of my site", "make a curated index for AI crawlers / ChatGPT",
  "add an llms.txt to my docs", "audit my llms.txt", or "help AI tools find my
  best pages".
---

# llms-txt

Create, audit, and maintain `llms.txt` and `llms-full.txt` so large language
models receive a curated, token-efficient map of the user's site instead of
parsing navigation, ads, and boilerplate HTML.

`llms.txt` is a single markdown file hosted at the domain root (`/llms.txt`).
It is a **curated index of links**, not a dump of every URL. `llms-full.txt`
is the same idea but **inlines the full body content** of the key pages into
one long document an agent can read in a single fetch.

## When to use

Use this skill when the user wants to:

- Create a new `/llms.txt` for a site, docs, or repo.
- Generate `/llms-full.txt` (concatenated full content) for offline/agent use.
- Audit or improve an existing `llms.txt` (score it, fix structure, re-curate).
- Make their best pages discoverable to ChatGPT, Claude, Perplexity, and other
  AI agents.

Related sibling skills — suggest them when relevant:

- **ai-crawler-access** — `llms.txt` is useless if bots cannot fetch it; verify
  `robots.txt` and CDN/WAF rules allow AI crawlers to read it.
- **structured-data** — JSON-LD makes individual pages machine-readable;
  `llms.txt` maps which pages matter. They complement each other.
- **geo-optimize** — once agents can find your pages, optimize the page bodies
  for generative engines.

## Inputs

Detect these automatically before asking the user. Read, do not guess.

1. **Domain / base URL** — needed for absolute links. Check `package.json`
   `homepage`, `CNAME`, `<site>` in config (e.g. `astro.config`, `next.config`,
   `docusaurus.config`, `_config.yml`, `mkdocs.yml`), or ask if unknown.
2. **Sitemap** — `sitemap.xml`, `sitemap_index.xml`, or `public/sitemap.xml`.
   Best source of the canonical URL list.
3. **Content folders** — `docs/`, `content/`, `pages/`, `src/pages/`, `posts/`,
   `blog/`, `_posts/`. Markdown/MDX files map directly to pages.
4. **Key marketing pages** — home, product, pricing, about, contact, docs index.
5. **README / project description** — source of the H1 title and the one-line
   summary blockquote.
6. **Existing files** — `llms.txt`, `public/llms.txt`, `static/llms.txt`,
   `llms-full.txt`. If present, audit instead of overwrite blindly.

If the domain cannot be determined, ask once: "What is the site's root URL
(e.g. https://example.com)?" Everything else should be inferred from the repo.

## Workflow

1. **Discover.** Locate the inputs above. Build a candidate URL list from the
   sitemap and content folders. Map each source file to its public URL (strip
   `index.md`, `.md`/`.mdx` extensions, and content-root prefixes per the site
   generator's routing).
2. **Classify & prioritize.** Bucket candidates into sections (see Method).
   Rank by usefulness to someone answering questions about the project. Drop
   noise: tag pages, paginated archives, auth/checkout, duplicates, asset URLs.
3. **Curate.** Select the high-signal pages. Aim for **clarity over coverage** —
   a tight index of 10-40 links beats 300. Push lower-priority but legitimate
   pages into an `## Optional` section.
4. **Write a one-line note per link.** Each bullet is
   `- [Title](https://full/url): concise note`. The note says what the page is
   for, in <= ~100 characters.
5. **Generate `/llms.txt`.** Emit the file in the exact order: H1 → blockquote
   summary → optional context prose → H2 sections with bullet lists. See the
   filled example in `templates/llms.txt.example`.
6. **Optionally generate `/llms-full.txt`.** Ask if the user wants it. If yes,
   inline the full body text of the linked pages (strip nav/footer/HTML chrome,
   keep headings and prose) into one document, each page under an H2 with its
   source URL.
7. **Score & report.** Run the 0-100 rubric below. Print the report and the
   proposed file(s). Apply edits to the user's repo only after they confirm.
8. **Hosting & upkeep.** Tell the user the file must resolve at the domain root
   `https://domain/llms.txt` (place it where their generator publishes root
   static files — `public/`, `static/`, or site root) and must be re-generated
   when the site structure changes. Recommend running **ai-crawler-access** to
   confirm crawlers can fetch it.

For exact format rules, the `llms-full.txt` build process, and hosting/
maintenance details, load `references/format-spec.md`.

## Method

### Format checklist (must all pass to be valid)

- [ ] File is named `llms.txt` and is plain UTF-8 markdown (no front matter).
- [ ] Exactly **one H1** (`# Name`) at the top — the site/project name.
- [ ] Immediately after, a **blockquote summary** (`> one sentence`) of <= ~160
      characters describing what the site/project is.
- [ ] Optional context prose: zero or more short paragraphs (no headings).
      May include a "## " note only if it is plain emphasis, not a link list.
- [ ] One or more **H2 sections** (`## Docs`, `## Examples`, `## Optional`...).
- [ ] Every list item is a markdown link:
      `- [Title](absolute-https-url): note`. Note is optional but recommended.
- [ ] All URLs are **absolute** (`https://…`), not relative paths.
- [ ] An **`## Optional`** section, when present, is last and holds links an
      agent may skip when its context window is tight.
- [ ] No broken structure: no bare URLs, no nested headings deeper than H2 in
      the link sections, no HTML.
- [ ] File hosted at root `/llms.txt` and reachable (HTTP 200, `text/plain` or
      `text/markdown`).

### Curation rules

- **Include:** docs, guides, API reference, key product/feature pages, pricing,
  about, high-value blog posts, examples.
- **Demote to `## Optional`:** changelogs, deep blog archives, legal/policy,
  secondary landing pages.
- **Exclude:** tag/category indexes, pagination, search, login/checkout/account,
  duplicate canonicals, image/asset/file URLs, 404s.
- Group related links under descriptive H2 names. Common sections: `Docs`,
  `Guides`, `API`, `Examples`, `Blog`, `Company`, `Optional`.
- Keep titles human and specific ("Quickstart", not "Page 1").

### Scoring rubric (0-100, weighted)

Score an existing or proposed file. Report the total and per-criterion points.

| # | Criterion | Weight | What full marks looks like |
|---|-----------|-------:|----------------------------|
| 1 | Structural validity | 25 | Single H1, blockquote summary present, valid H2 sections, all links absolute markdown links, no HTML/bare URLs. |
| 2 | Curation & prioritization | 25 | High-signal pages only; noise excluded; sensible section grouping; `## Optional` used for low-priority links. |
| 3 | Link note quality | 20 | Most links carry a clear <= ~100-char note explaining the page; titles are specific and human. |
| 4 | Coverage of key content | 15 | The genuinely important pages (docs index, core guides, pricing/product, README equivalent) are all present. |
| 5 | Hosting & freshness | 15 | Resolves at `/llms.txt`, served as text, crawler-allowed, and reflects current site structure (no dead links). |

Scoring bands: **90-100** ship as-is; **70-89** minor fixes; **50-69** re-curate
sections and notes; **< 50** rebuild from discovery. Deduct the full criterion
weight when it fundamentally fails (e.g. no H1 → 0 on criterion 1).

For `llms-full.txt`, apply criteria 1-4 to its link/heading structure plus a
pass/fail check that each inlined page contains real body content with its
source URL, and that total size stays reasonable (warn if > ~1 MB / ~250k
tokens; split or trim if larger).

## Output

Print a report in this exact shape, then the file contents:

```
# llms.txt Report — <site name>

Score: <0-100>  (band: <ship / minor / re-curate / rebuild>)

Breakdown:
- Structural validity:        <n>/25
- Curation & prioritization:  <n>/25
- Link note quality:          <n>/20
- Coverage of key content:    <n>/15
- Hosting & freshness:        <n>/15

Discovered: <N> candidate URLs  →  Curated: <M> links across <K> sections
Issues found:
- <issue> → <fix>

Proposed files:
- /llms.txt        (curated index, <M> links)
- /llms-full.txt   (full content, <size>)   [only if requested]
```

Then output the proposed `llms.txt` (and `llms-full.txt` if requested) in a
fenced code block.

After the user confirms, **apply the edits**: write `llms.txt` (and
`llms-full.txt`) to the correct publish location in their repo (root static dir
such as `public/`, `static/`, or repo root — match where their generator serves
root files). Do not write files before the user confirms.

## Examples

A realistic, fully filled file lives in `templates/llms.txt.example`. Minimal
before -> after:

**Before** — `public/llms.txt` (invalid: no blockquote, relative URLs, no notes):

```
# Acme
Docs:
- /start
- /api
- /blog/post-1
- /tag/news
- /login
```

**After** — curated, valid `/llms.txt`:

```
# Acme

> Acme is an open-source rate-limiting library for Node.js and Python.

Acme ships a single dependency-free middleware. These docs cover setup,
configuration, and the full API.

## Docs

- [Quickstart](https://acme.dev/start): install Acme and protect a route in 5 minutes.
- [Configuration](https://acme.dev/config): every option, defaults, and tuning advice.
- [API reference](https://acme.dev/api): full method and type signatures.

## Examples

- [Express middleware](https://acme.dev/examples/express): drop-in rate limiter for Express.
- [FastAPI example](https://acme.dev/examples/fastapi): per-user limits in FastAPI.

## Optional

- [Changelog](https://acme.dev/changelog): release notes and migration guides.
- [Blog: scaling to 1M req/s](https://acme.dev/blog/post-1): architecture deep dive.
```

What changed: added the `> summary` blockquote and a context paragraph;
converted relative paths to absolute `https://` links; removed `/tag/news` and
`/login` (noise/auth); grouped links into `Docs` / `Examples`; demoted the
changelog and blog post to `## Optional`; gave every link a one-line note.

---
Part of **Intura Skills** — the self-service AI-visibility toolkit by [Intura](https://intura.co). Standalone; no account or API key required.
