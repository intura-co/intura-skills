---
name: ai-crawler-access
description: >-
  Audits and configures which AI crawlers and assistant bots can reach a
  website by reading and editing robots.txt, meta robots tags, and X-Robots-Tag
  headers, then verifying pages are readable without JS-only rendering or auth
  walls. Maps every major AI user-agent (OpenAI GPTBot/OAI-SearchBot/ChatGPT-User,
  Anthropic ClaudeBot/Claude-User/Claude-SearchBot, PerplexityBot/Perplexity-User,
  Google-Extended, Applebot-Extended, CCBot, Bytespider, Amazonbot,
  Meta-ExternalAgent, cohere-ai, Diffbot, Timpibot) to training vs search-index
  vs live-fetch purposes, scores current access 0-100, and generates allow-all-ai,
  allow-search-block-training, or block-all-ai robots.txt recipes. Use when a
  user says "let AI crawlers in", "make my site show up in ChatGPT or
  Perplexity", "block AI bots from scraping", "opt out of AI training", "audit
  my robots.txt for GPTBot", or "why isn't my content cited by AI". A
  prerequisite for GEO and AEO.
---

# AI Crawler Access

Make sure AI crawlers can (or, deliberately, cannot) reach the user's site.
Allowing the retrieval/search bots is a **prerequisite for GEO**: if a bot is
blocked at robots.txt or the content only renders in client-side JavaScript, no
amount of on-page optimization will get the site cited in ChatGPT, Perplexity,
Claude, Gemini, or AI Overviews.

## When to use

Use this skill when the user wants to:

- Confirm AI engines are allowed to crawl their site ("can ChatGPT see my
  site?", "let AI crawlers in", "make my content show up in Perplexity").
- Block or throttle AI bots ("stop AI from scraping me", "opt out of AI
  training", "block GPTBot/Bytespider").
- Audit an existing `robots.txt` for AI user-agents.
- Diagnose why content is not being cited by AI engines.

This is the access layer. For the content itself, hand off to **geo-optimize**
(answer-ready content), **aeo-optimize** (answer-engine formatting),
**structured-data** (schema), and **llms-txt** (machine-readable site summary).

## Inputs

Detect these in the repo; ask the user only for what you cannot find.

1. **`robots.txt`** — look in this order: `./robots.txt`, `./public/robots.txt`,
   `./static/robots.txt`, `./web/robots.txt`, `./src/robots.txt`,
   `./app/robots.txt`, `./assets/robots.txt`. Also detect framework-generated
   robots: `app/robots.ts|js` (Next.js), `src/routes/robots.txt` (SvelteKit),
   `gatsby-plugin-robots-txt`, `next-sitemap` config. If none exists, note that
   and plan to create one at the web root.
2. **Head meta robots** — grep templates/layouts for
   `<meta name="robots"`, `noindex`, `noai`, `noimageai`.
3. **`X-Robots-Tag`** — grep server/CDN config (`netlify.toml`, `vercel.json`,
   `next.config.*`, `.htaccess`, nginx confs) for `X-Robots-Tag`.
4. **Rendering mode** — is content server-rendered/static, or a JS-only SPA?
   Look for SSR/SSG (Next.js, Nuxt, Astro, Gatsby, Hugo, Jekyll, 11ty) vs a bare
   `<div id="root"></div>` SPA (CRA, Vite SPA, Angular) with no prerender.
5. **`llms.txt`** — check `./llms.txt` / `./public/llms.txt`.
6. **The user's goal** — if unstated, ask which of the three policies they want
   (see Decision guide). Default to **allow-search-block-training is optional;
   most sites seeking AI visibility want allow-all-ai**.

## Workflow

1. **Locate and read** `robots.txt` (and any framework robots generator), head
   meta robots, and `X-Robots-Tag` config. If multiple sources exist, note that
   the HTTP-served `/robots.txt` is the one that counts.
2. **Confirm the goal** with the user: maximize AI visibility (default), allow
   AI search but opt out of training, or block all AI. See Decision guide.
3. **Audit** every AI user-agent in `references/crawlers.md`: mark each
   Allowed / Blocked / Not mentioned (defaults to allowed). Flag the classic
   mistakes (see checklist). Check rendering and `llms.txt`.
4. **Score** the current state 0-100 with the rubric below.
5. **Recommend** changes for the chosen goal and pick a template from
   `templates/`. Print the proposed `robots.txt` as a diff against what exists.
6. **On the user's confirmation, apply the edit**: write or patch `robots.txt`
   (merge with — never clobber — existing `Disallow` rules for `/admin`,
   `/cart`, etc.), and fix any `Sitemap:` line. Then suggest the next skill
   (**llms-txt** to publish a summary; **geo-optimize** for the content).

## Decision guide

| User intent | Recipe | Net effect |
|---|---|---|
| Want to be found/cited by AI (most sites) | `allow-all-ai` | All AI bots + search engines welcome. Maximum GEO surface. |
| Want AI search visibility but no model training | `allow-search-block-training` | Cited live in ChatGPT/Perplexity/Claude; opted out of GPTBot/ClaudeBot/CCBot training and Google-Extended/Applebot-Extended. |
| Do not want AI to use the site at all | `block-all-ai` | Blocks AI crawl/index/fetch; keeps Googlebot + Applebot for normal search. |

Key facts to tell the user:

- **For GEO you want the search/retrieval bots** (`OAI-SearchBot`,
  `ChatGPT-User`, `PerplexityBot`, `Perplexity-User`, `Claude-User`,
  `Claude-SearchBot`, plus `Applebot`/`Googlebot`). Training opt-out is a
  **separate brand choice** and does not change search visibility.
- Blocking the **training** bot does not remove you from that vendor's AI
  **search**. Example: blocking `GPTBot` (training) does **not** remove you from
  ChatGPT search — that is `OAI-SearchBot`. Block the wrong one and you lose
  citations for no privacy gain.
- `Google-Extended` and `Applebot-Extended` are **robots.txt tokens only** (no
  bot fetches under them). They opt content **out of model training**
  (Gemini/Vertex, Apple Intelligence) **without** affecting Google Search or
  Apple/Siri indexing or ranking.
- **robots.txt is voluntary.** Reputable bots obey it; some (historically
  `Bytespider`) ignore it. For hard blocks, also enforce at the WAF/CDN/firewall
  by user-agent and published IP ranges.

## AI crawler audit checklist

Run every item; each maps to a fix.

- [ ] `robots.txt` exists and is served at the web root (`/robots.txt`,
      HTTP 200, `text/plain`). Not only in a subfolder.
- [ ] No blanket `User-agent: *` + `Disallow: /` that silently blocks every AI
      bot. (A bot obeys only its **most specific** matching group — see
      mechanics — so a stray global block is a common own-goal.)
- [ ] Retrieval/search bots are **allowed**: `OAI-SearchBot`, `ChatGPT-User`,
      `PerplexityBot`, `Perplexity-User`, `Claude-User`, `Claude-SearchBot`,
      `Applebot`, `Googlebot`. None of these should be `Disallow: /` if the goal
      is AI visibility.
- [ ] Training policy is **intentional and consistent** with the stated goal
      (GPTBot, ClaudeBot, anthropic-ai, CCBot, Bytespider, Google-Extended,
      Applebot-Extended all match the chosen recipe).
- [ ] No common mix-up: a training bot blocked while its search bot is also
      blocked "by accident", or vice versa.
- [ ] Key pages are **server-rendered or static HTML**. Most AI crawlers do
      **not** execute JavaScript — a JS-only SPA looks empty to them. Confirm
      SSR/SSG/prerender, or that the meaningful text is in the initial HTML.
- [ ] No **auth wall, hard paywall, or geo/IP gate** in front of content you
      want cited. Bots cannot log in.
- [ ] No accidental `noindex` / `X-Robots-Tag: noindex` on pages you want
      surfaced. (`noai`/`noimageai` have **limited adoption** — do not rely on
      them either to block or to assume they protect you.)
- [ ] `Sitemap:` line present in `robots.txt` and points to a live sitemap.
- [ ] `llms.txt` exists at the root (hand off to **llms-txt** if missing).

## Scoring rubric (0-100)

Score the site for the common goal — **discoverable by AI**. Weighted:

| # | Criterion | Weight | Full credit when... |
|---|---|---|---|
| 1 | robots.txt reachable | 10 | Served at `/robots.txt`, HTTP 200, valid syntax. |
| 2 | Retrieval/search bots allowed | 30 | None of OAI-SearchBot, ChatGPT-User, PerplexityBot, Perplexity-User, Claude-User, Claude-SearchBot, Applebot, Googlebot is `Disallow: /`. |
| 3 | No accidental global block | 15 | No `User-agent: *` `Disallow: /` (or it is intentional and AI bots are explicitly re-allowed). |
| 4 | Content crawlable without JS/auth | 20 | Key text is in server-rendered/static HTML; no auth/paywall on target pages. |
| 5 | No accidental noindex | 10 | No `noindex` meta or `X-Robots-Tag` on pages meant to be surfaced. |
| 6 | llms.txt present | 10 | Valid `llms.txt` at root (see **llms-txt**). |
| 7 | Intentional training policy | 5 | Training bots/tokens match the user's stated brand choice (either direction). |

Scoring notes:

- Award partial credit on #2 proportionally to how many of the 8 retrieval bots
  are reachable (e.g. 6/8 allowed = 22/30).
- **Invert the framing for a deliberate block goal**: when the user *wants*
  `block-all-ai`, criteria #2 is satisfied by the AI bots being *blocked* and
  #7 carries the intent — score against the user's actual objective, and say so.
- Bands: 90-100 ready; 70-89 minor fixes; 40-69 real gaps; <40 AI cannot
  meaningfully use the site.

## robots.txt mechanics & recipes

Mechanics you must apply when auditing or generating rules:

- A crawler reads `/robots.txt` and obeys **only one group** — the group whose
  `User-agent` token most specifically matches its name. It does **not** merge
  the `*` group with a named group. So `User-agent: *` `Disallow: /` plus a
  named `User-agent: OAI-SearchBot` group means OAI-SearchBot follows **its
  own** group and ignores the `*` block.
- Matching is case-insensitive on the product token (`GPTBot` ≈ `gptbot`).
- `Disallow:` (empty value) means **allow all**. `Disallow: /` blocks the whole
  site. `Allow:` can re-open paths within a disallowed area.
- Put one blank line between groups. Multiple `User-agent:` lines may stack
  above a shared set of rules.
- `Sitemap:` is global (not tied to a group); keep it at the file's end.

Three ready templates live in `templates/` — load and adapt the one that
matches the goal, then merge with the user's existing rules:

- `templates/robots.allow-all-ai.txt` — welcome every AI + search bot.
- `templates/robots.allow-search-block-training.txt` — allow retrieval/search;
  block pure training bots + Google-Extended/Applebot-Extended.
- `templates/robots.block-all-ai.txt` — block AI crawl/index/fetch; keep
  Googlebot + Applebot for traditional search.

For the full user-agent reference (vendor, purpose, exact token, how to
allow/block each), **load `references/crawlers.md`** when you need to look up or
classify a specific bot.

## Output

Print a single Markdown report, then apply edits only after the user confirms.

```
# AI Crawler Access Report — <domain or repo>

Goal: <allow-all-ai | allow-search-block-training | block-all-ai>
Score: <0-100> (<band>)

## Current access by bot
| Bot | Vendor | Purpose | Status |
|-----|--------|---------|--------|
| GPTBot | OpenAI | Training | Blocked |
| OAI-SearchBot | OpenAI | AI search index | Allowed |
| ChatGPT-User | OpenAI | Live user fetch | Allowed |
| ... | | | |

## Findings
- [PASS] robots.txt served at /robots.txt
- [FAIL] `User-agent: * / Disallow: /` blocks all retrieval bots  (-30)
- [WARN] Content is a client-rendered SPA; AI crawlers may see no text
- ...

## Recommended robots.txt (diff)
```diff
- User-agent: *
- Disallow: /
+ User-agent: *
+ Disallow:
+
+ User-agent: GPTBot
+ Disallow: /
+ ...
```

## Next steps
- Apply the robots.txt above (confirm to write the file)
- Publish an llms.txt  → run the **llms-txt** skill
- Make content answer-ready → run the **geo-optimize** skill
```

When the user confirms, **write or patch the actual `robots.txt`** at the
detected web root, preserving their existing `Disallow` rules and `Sitemap:`
line. Report the file path you changed.

## Examples

**Example A — accidental global block (the most common case).**

Before (`/public/robots.txt`) — every AI engine and search engine is blocked,
so the site can never be cited:

```
User-agent: *
Disallow: /
```

After (goal: allow-all-ai) — default-open, with explicit welcome and sitemap:

```
User-agent: *
Disallow:

User-agent: GPTBot
User-agent: OAI-SearchBot
User-agent: ChatGPT-User
User-agent: ClaudeBot
User-agent: Claude-User
User-agent: PerplexityBot
User-agent: Perplexity-User
User-agent: Applebot
Allow: /

Sitemap: https://example.com/sitemap.xml
```

**Example B — wrong-bot block (blocks training but loses search citations).**

Before — the owner blocked `GPTBot` thinking it removes them from ChatGPT, but
`GPTBot` is *training only*; their ChatGPT-search bot is left unmanaged and
their real intent (no training) is half-done:

```
User-agent: GPTBot
Disallow: /
```

After (goal: allow-search-block-training) — keep AI **search** visibility,
cleanly opt out of training across vendors:

```
User-agent: *
Disallow:

User-agent: GPTBot
Disallow: /

User-agent: ClaudeBot
Disallow: /

User-agent: CCBot
Disallow: /

User-agent: Google-Extended
Disallow: /

User-agent: Applebot-Extended
Disallow: /

# OAI-SearchBot, ChatGPT-User, PerplexityBot, Perplexity-User, Claude-User,
# Claude-SearchBot, Applebot, Googlebot remain allowed via "User-agent: *".

Sitemap: https://example.com/sitemap.xml
```

---
Part of **Intura Skills** — the self-service AI-visibility toolkit by [Intura](https://intura.co). Standalone; no account or API key required.
