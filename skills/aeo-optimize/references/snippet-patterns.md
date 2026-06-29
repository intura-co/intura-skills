# Snippet patterns & templates

Load this when you need ready-to-paste snippet structures, question-heading
phrasings, PAA expansion sets, or the FAQ block. Used by the **aeo-optimize**
skill. All targets are calibrated to how answer engines extract content as of
2026 — they are guidance, not hard API limits.

---

## 1. The three featured-snippet shapes

### 1a. Paragraph snippet

**Wins for:** definitions and what / why / who / how long / how much / can I /
should I questions.

**Spec:** one self-contained block, **40-60 words (~300 characters / ~3-4
sentences)**. No "as mentioned above". Front-load the answer in sentence one;
add nuance in sentences 2-4. Start definitions with an "**X is...**" opener.

**Template:**

```markdown
## <Natural question heading>?

<Term> is <one-sentence direct answer that resolves the question>. <Sentence 2:
the most important qualifier or number.> <Sentence 3: a second key fact or
condition.> <Optional sentence 4: scope or exception.>
```

**Filled example:**

```markdown
## What is answer engine optimization?

Answer engine optimization (AEO) is the practice of structuring content so
answer engines and AI assistants can extract a short, correct answer directly
from the page. It focuses on question-framed headings, 40-60 word lead answers,
FAQ schema, and addressable sections — optimizing the extracted answer, not just
the ranking position.
```

### 1b. List snippet

**Wins for:** how to / steps / ways to / best / types of / checklist / examples
/ ingredients / requirements questions.

**Spec:** **ordered list** for sequences, processes, and rankings; **unordered
list** for sets with no order. Keep **5-8 items** (engines often truncate after
~8 and show "More items..."). Front-load each item with the key phrase in the
first 2-4 words. Optionally precede with a one-sentence 40-60 word lead so the
section also qualifies for a paragraph pull.

**Ordered template:**

```markdown
## How do I <do the task>?

To <do the task>, follow these <N> steps:

1. **<Action verb + object>** — <short clarifier>.
2. **<Action verb + object>** — <short clarifier>.
3. **<Action verb + object>** — <short clarifier>.
4. **<Action verb + object>** — <short clarifier>.
5. **<Action verb + object>** — <short clarifier>.
```

**Unordered template:**

```markdown
## What are the types of <X>?

The main types of <X> are:

- **<Type one>** — <one-line definition>.
- **<Type two>** — <one-line definition>.
- **<Type three>** — <one-line definition>.
```

### 1c. Table snippet

**Wins for:** comparisons, pricing tiers, specs, schedules, dimensions, "X vs
Y", and any answer with 2+ attributes per item.

**Spec:** keep it small — **2-3 columns, a handful of rows**. Put the entity or
comparison axis in the **first column**; keep cells terse (a value or short
phrase, not sentences). Add a 40-60 word lead sentence above the table for a
paragraph pull.

**Template:**

```markdown
## <Option A> vs <Option B>: what's the difference?

<40-60 word lead that states the headline difference and the bottom-line
recommendation.>

| <Axis> | <Option A> | <Option B> |
|--------|------------|------------|
| <Attribute 1> | <value> | <value> |
| <Attribute 2> | <value> | <value> |
| <Attribute 3> | <value> | <value> |
```

---

## 2. Question-heading patterns

Rewrite noun headings as the question a user types or speaks. Keep the answer's
keyword in the heading.

| Noun heading (before) | Question heading (after) |
|-----------------------|--------------------------|
| Pricing | How much does <product> cost? |
| Overview / About | What is <product>? |
| Setup | How do I set up <product>? |
| Benefits | Why use <product>? |
| Requirements | What do I need to use <product>? |
| Comparison | <product> vs <competitor>: which is better? |
| Timeline | How long does <process> take? |
| Eligibility | Who can use <product>? |
| Troubleshooting | Why isn't <feature> working? |
| Refunds | Can I get a refund? |

If house style forbids question headings, keep a noun H2 but ensure the exact
question appears verbatim in the FAQ section.

---

## 3. People Also Ask (PAA) expansion sets

For each primary question, generate the natural follow-ups. Pick the 4-8 most
relevant and answer them in the body or FAQ. Generic expansion frame:

- **Definition:** What is <X>? What does <X> mean?
- **Reason:** Why <X>? Why does <X> matter?
- **Method:** How do I <X>? What's the best way to <X>?
- **Time:** How long does <X> take? When should I <X>?
- **Cost:** How much does <X> cost? Is <X> free?
- **Comparison:** <X> vs <Y>? Is <X> better than <Y>?
- **Eligibility/scope:** Who needs <X>? Can I <X> without <Z>?
- **Examples:** What are examples of <X>? What are the types of <X>?

**Voice-search variants:** rephrase the top questions the way people speak —
longer, conversational, first person. Voice answers are typically read aloud as
one ~29-word sentence, so make the lead answer a clean single statement.

- "what's the best way to <task>"
- "how do I <task> on <platform>"
- "is it worth <doing X>"
- "do I really need <X>"

---

## 4. FAQ block template

Place near the end of the page. Each answer is a **self-contained 40-60 word**
response. Use real, full-sentence questions (PAA phrasing), not keyword
fragments. This block is the source the **structured-data** skill reads to emit
FAQPage / QAPage JSON-LD, so keep the text in the DOM — never hide answers
inside images, tabs, or collapsed accordions that strip text.

**Markdown:**

```markdown
## Frequently asked questions

### <Full natural question 1>?
<40-60 word self-contained answer. First sentence resolves the question; the
rest adds the key number, condition, or exception.>

### <Full natural question 2>?
<40-60 word self-contained answer.>

### <Full natural question 3>?
<40-60 word self-contained answer.>
```

**HTML (anchored, schema-friendly):**

```html
<section id="faq">
  <h2>Frequently asked questions</h2>

  <h3 id="faq-pricing">How much does Acme cost?</h3>
  <p>Acme costs $0 to $49 per user per month across three plans...</p>

  <h3 id="faq-free">Is there a free version?</h3>
  <p>Yes. Acme's Free plan costs $0 forever for a single user...</p>
</section>
```

After the FAQ exists, hand off to **structured-data** for the JSON-LD. A minimal
FAQPage shape (the structured-data skill produces the full, validated version):

```json
{
  "@context": "https://schema.org",
  "@type": "FAQPage",
  "mainEntity": [
    {
      "@type": "Question",
      "name": "How much does Acme cost?",
      "acceptedAnswer": { "@type": "Answer", "text": "Acme costs $0 to $49..." }
    }
  ]
}
```

---

## 5. Addressability: ToC, jump links, anchors

Make every answer linkable so it can be cited and deep-linked.

- Give each H2/H3 a stable, lowercase-hyphen anchor. Markdown auto-slugs
  headings; for HTML add an explicit `id`. Don't let slugs change once published.
- Add a table of contents / jump-link list near the top for pages with 4+
  sections so users (and crawlers) can reach each answer directly.

**Markdown ToC:**

```markdown
## On this page
- [How much does it cost?](#how-much-does-it-cost)
- [How do I set it up?](#how-do-i-set-it-up)
- [FAQ](#frequently-asked-questions)
```

**HTML anchored heading:**

```html
<h2 id="how-much-does-it-cost">How much does it cost?</h2>
```

---

## 6. Quick reference: shape by question type

| Question starts with... | Best shape |
|-------------------------|------------|
| What is / Who is / Define | Paragraph (X is...) |
| How much / How long / Why / Can I | Paragraph |
| How to / Steps to / Ways to | Ordered list |
| Best / Types of / Examples / Checklist | Unordered list |
| X vs Y / Compare / Pricing tiers / Specs | Table |
