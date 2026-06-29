# AI Crawler User-Agent Reference (2026)

Load this when you need to classify, allow, or block a specific AI bot. The
**Token** column is the exact string to put after `User-agent:` in robots.txt
(matching is case-insensitive on this product token). "Purpose" buckets matter
for GEO: you almost always want **AI search index** and **Live user fetch**
allowed; **Training** is a separate brand choice.

Legend for the **allow-search / block-training** column:
- `ALLOW` = leave reachable (falls under `User-agent: *`) — needed for GEO.
- `BLOCK` = add a `Disallow: /` group — training/dataset use.

---

## OpenAI

| Bot (token) | Purpose | Executes JS? | allow-search/block-training | Notes |
|---|---|---|---|---|
| `GPTBot` | Training crawl | No | BLOCK | Feeds OpenAI model training. Blocking it does **not** remove you from ChatGPT search. |
| `OAI-SearchBot` | AI search index | No | ALLOW | Builds the ChatGPT search index. **Keep allowed for GEO.** |
| `ChatGPT-User` | Live user fetch | No | ALLOW | Fetches a page when a ChatGPT user/agent clicks or browses. Keep allowed. |

Docs: `https://platform.openai.com/docs/bots`. OpenAI publishes IP ranges for
each bot for firewall-level verification.

## Anthropic

| Bot (token) | Purpose | Executes JS? | allow-search/block-training | Notes |
|---|---|---|---|---|
| `ClaudeBot` | Training crawl | No | BLOCK | General/training crawler for Claude models. |
| `Claude-User` | Live user fetch | No | ALLOW | Retrieves pages when a Claude user asks (web access). Keep allowed. |
| `Claude-SearchBot` | AI search index | No | ALLOW | Indexes pages to answer Claude search queries. Keep allowed for GEO. |
| `anthropic-ai` | Legacy training | No | BLOCK | Older user-agent; include it when opting out of training for full coverage. |

Docs: `https://docs.anthropic.com` (search "crawler"/"user agents"). A legacy
`Claude-Web` token also appears on some older sites — treat as live fetch.

## Perplexity

| Bot (token) | Purpose | Executes JS? | allow-search/block-training | Notes |
|---|---|---|---|---|
| `PerplexityBot` | AI search index | No | ALLOW | Indexes pages so Perplexity can cite them. **Keep allowed for GEO.** |
| `Perplexity-User` | Live user fetch | Sometimes | ALLOW | Fetches a page for a specific user query. Perplexity states this user-action fetch may not always honor robots.txt; enforce at WAF if a hard block is required. |

## Google

| Token | Purpose | allow-search/block-training | Notes |
|---|---|---|---|
| `Google-Extended` | **Training opt-out token (not a bot)** | BLOCK to opt out | A robots.txt-only token. `Disallow: /` opts your content **out of Gemini/Vertex AI model training and grounding** with **no effect on Google Search** indexing or ranking, and no effect on AI Overviews eligibility derived from Search. |
| `Googlebot` | Search crawl (not AI-specific) | ALLOW | Standard web search. Do **not** block if you want any Google visibility, including AI Overviews. |

There is no separate "block AI Overviews" token; AI Overviews draw from the
normal Search index, so Search opt-out = Overviews opt-out, which is rarely
desirable.

## Apple

| Token | Purpose | allow-search/block-training | Notes |
|---|---|---|---|
| `Applebot-Extended` | **Training opt-out token (not a bot)** | BLOCK to opt out | robots.txt-only token. `Disallow: /` opts content **out of Apple Intelligence / Apple foundation-model training**. |
| `Applebot` | Search crawl (Siri/Spotlight) | ALLOW | Powers Siri Suggestions and Spotlight. Keeps working even when `Applebot-Extended` is disallowed. |

## Other AI crawlers

| Bot (token) | Vendor | Purpose | allow-search/block-training | Notes |
|---|---|---|---|---|
| `CCBot` | Common Crawl | Dataset crawl (feeds many AI training sets) | BLOCK | Open dataset widely used to train LLMs. Block to reduce indirect training exposure. |
| `Bytespider` | ByteDance | Training crawl | BLOCK | Aggressive; has historically **ignored robots.txt**. Enforce at WAF/CDN by UA + IP if a real block is needed. |
| `Amazonbot` | Amazon | Assistant/search retrieval (Alexa) + service improvement | ALLOW (borderline) | Powers Alexa answers and search-style retrieval. Allow for assistant visibility; block if you want zero Amazon AI use. |
| `Meta-ExternalAgent` | Meta | Meta AI training + product grounding | BLOCK | Meta AI crawler. (`Meta-ExternalFetcher` is the live user-fetch counterpart; allow that one if you want Meta AI to fetch on demand. `FacebookBot`/`facebookexternalhit` are link-preview/ads bots, not AI.) |
| `cohere-ai` | Cohere | Training/data crawl | BLOCK | Block to opt out of Cohere model data collection. |
| `Diffbot` | Diffbot | Knowledge-graph extraction (resold into AI training/RAG) | BLOCK | Structured-data scraper feeding third-party AI/knowledge products. |
| `Timpibot` | Timpi | Decentralized search index | ALLOW (borderline) | Search-engine crawler; allow for search visibility, block if undesired. |

## How to allow or block any bot

**Allow** (the default when a bot is not mentioned): either say nothing, or be
explicit —

```
User-agent: OAI-SearchBot
Allow: /
```

**Block** one bot —

```
User-agent: GPTBot
Disallow: /
```

**Block several** with shared rules (stack the `User-agent:` lines) —

```
User-agent: GPTBot
User-agent: CCBot
User-agent: Bytespider
Disallow: /
```

**Opt out of training only** (search unaffected) — use the vendor tokens —

```
User-agent: Google-Extended
Disallow: /

User-agent: Applebot-Extended
Disallow: /
```

**Remember:** a bot obeys only its single most-specific matching group, so a
named group fully overrides the `User-agent: *` group for that bot. robots.txt
is voluntary — for guaranteed blocks, also filter by user-agent and the
vendor's published IP ranges at your CDN/WAF/firewall.

## Non-robots controls (limited adoption)

- `<meta name="robots" content="noindex">` / `X-Robots-Tag: noindex` — removes
  a page from **search** indexes (Googlebot, Applebot, OAI-SearchBot,
  PerplexityBot respect indexing directives). Use only to hide a page entirely.
- `<meta name="robots" content="noai, noimageai">` — proposed AI-training
  opt-out. **Limited adoption**: not broadly honored by major AI crawlers as of
  2026. Do not rely on it to block training, and do not assume it protects you.
- The reliable, widely-respected training opt-out remains robots.txt
  `Disallow: /` for each training bot/token listed above.
