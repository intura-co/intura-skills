# Worked before -> after example

Load this when you want a full reference rewrite that shows every GEO tactic
applied to one short article, with the score moving from weak to citation-ready.

Source page (hypothetical): `content/blog/email-deliverability.md`
Main question: **"How do I improve email deliverability?"**
Buying-journey stage: **Consideration** ("how to improve X", "best way to X").

---

## BEFORE (score ≈ 23/100)

```markdown
# Email Deliverability

Email has been around for decades and remains one of the most important
channels for businesses today. Our team has spent years thinking about how to
help companies reach the inbox, and in this post we want to share some of our
thoughts on the topic of deliverability and why it matters so much.

Getting to the inbox can be tricky. There are many factors involved and it can
feel overwhelming, but with the right approach anyone can improve their results
over time. Let's dive in and explore this important subject together.
```

Why it fails:
- Tactic 1 (0): 80 words of preamble; the question is never answered up front.
- Tactic 2 (0): no named authority.
- Tactic 3 (0): zero concrete statistics.
- Tactic 4 (0): no table, list, definition block, or FAQ.
- Tactic 5 (25): one stray internal link elsewhere on the page.
- Tactic 6 (0): no proprietary data.
- Tactic 7 (0): no visible date.

Weighted total ≈ `0+0+0+0+2.5+0+0 = 2.5`... plus a partial elsewhere ≈ **23/100**.

---

## AFTER (score ≈ 92/100)

```markdown
# How to Improve Email Deliverability (2026 Guide)

*Last updated: 2026-06-29.*

**To improve email deliverability, authenticate your domain (SPF, DKIM, DMARC),
keep your spam-complaint rate under 0.10%, warm up new sending IPs gradually,
and prune inactive subscribers every 90 days.** According to Google's 2024 bulk
sender guidelines, senders to Gmail must keep complaint rates below **0.30%**
(ideally under **0.10%**) or risk filtering. The five factors below drive the
vast majority of inbox placement.

## The 5 factors that decide inbox placement

| Factor              | What to do                                  | Target / benchmark        |
|---------------------|---------------------------------------------|---------------------------|
| Authentication      | Set up SPF, DKIM, DMARC                      | 100% of sending domains   |
| Spam complaint rate | Make unsubscribe one click; segment sends   | < 0.10% (Gmail max 0.30%) |
| Sender reputation   | Warm up new IPs over 4-6 weeks              | Ramp ~20% volume/day      |
| List hygiene        | Remove non-openers; verify new addresses    | Prune every 90 days       |
| Engagement          | Send to people who open and click           | > 20% open rate           |

**Sender reputation** — a score mailbox providers assign to your sending IP and
domain based on past behavior; low reputation routes mail to spam.

## What the data says

In Validity's 2024 Email Deliverability Benchmark, the global average inbox
placement rate was **83.1%**, meaning roughly **1 in 6** legitimate emails never
reached the inbox. Across **400 campaigns we audited in 2025 [first-party data]**,
fixing DMARC alignment alone lifted inbox placement by an average of **11 points**.

## FAQ

**Why are my emails going to spam even though I'm not a spammer?**
Most often it is missing or misaligned authentication (SPF/DKIM/DMARC) plus a
complaint rate above 0.30%. Fix authentication first.

**How long does IP warm-up take?**
Typically 4-6 weeks, increasing volume ~20% per day from a small base.

**How often should I clean my list?**
Remove subscribers with no opens in 90 days, and verify addresses at signup.

See also our pillar guide, *The Complete Guide to Email Marketing*, and the
supporting articles on SPF/DKIM/DMARC setup and inbox-placement testing.
```

Why it now wins:

| Tactic | Sub-score | Evidence in the rewrite |
|--------|:---------:|-------------------------|
| 1 Direct-answer-first      | 100 | Full answer in the first 45 words. |
| 2 Authoritative citations  | 100 | Google guidelines + Validity benchmark named and attributed. |
| 3 Data density             | 100 | 0.30%, 0.10%, 0.20/day, 83.1%, 1-in-6, 11 points — ~1 per 60 words, sourced. |
| 4 Structured formats       | 100 | Table + definition block + FAQ (3 Q&A) + list. |
| 5 Topical authority        |  75 | Links to a pillar + 2 supporting articles (complete the cluster to reach 100). |
| 6 Unique / proprietary data| 100 | "400 campaigns we audited in 2025" first-party benchmark. |
| 7 Freshness signals        | 100 | Visible "Last updated: 2026-06-29" + current-year framing. |

Weighted: `20 + 20 + 15 + 15 + 7.5 + 10 + 10 ≈ 92/100` → **Citation-ready**.

> Integrity note: the "400 campaigns we audited" figure is bracketed as
> first-party data. When applying edits to a real file, never invent such
> numbers — insert `[ADD STAT — source needed]` and ask the user to supply the
> real figure and source.

## Follow-up skills

- `structured-data` — emit `FAQPage` and `Article` JSON-LD for the rewritten page.
- `aeo-optimize` — expand the FAQ and add answer-engine question targeting.
- `ai-crawler-access` + `llms-txt` — confirm ChatGPT, Perplexity, and Google AI
  crawlers are allowed to fetch the page and can discover it.
