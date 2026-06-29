# intura-skills

A self-service toolkit of six **AI-visibility skills** that you install into your
own repository and run under any coding agent — Claude Code, Codex, Cursor,
Windsurf, Aider, and friends. Search is no longer just ten blue links: ChatGPT,
Gemini, Claude, Perplexity, and Google AI Overviews now answer questions
directly and cite a handful of sources. **Generative Engine Optimization (GEO)**,
**Answer Engine Optimization (AEO)**, and classic **SEO** are how you make sure
those sources include *you*. These skills audit and rewrite your pages, emit the
structured data and access files AI crawlers expect, and score each change so you
can see exactly why an engine would (or would not) cite your content. They are
**fully standalone** — no Intura account, API key, or network call required — and
maintained by Intura ([intura.co](https://intura.co)).

## The six skills

| Skill | Use when you want to… |
| --- | --- |
| **geo-optimize** | Score and rewrite a page so generative engines (ChatGPT, Gemini, Claude, Perplexity, AI Overviews) mention and cite it — answer-first intros, data density, citations, freshness. |
| **aeo-optimize** | Restructure a page for answer engines: question-shaped headings, 40–60 word snippet answers, featured-snippet shapes, real FAQ and "People Also Ask" coverage. |
| **seo-optimize** | Audit and fix classic on-page and technical SEO — titles, meta, one clean `<h1>`, slugs, internal links, alt text, canonical, Open Graph, sitemap, Core Web Vitals. |
| **structured-data** | Generate and validate Schema.org JSON-LD (Article, FAQ, Product, Organization, HowTo, LocalBusiness…) so engines parse your content unambiguously. |
| **llms-txt** | Generate and audit `llms.txt` / `llms-full.txt` curated site maps so LLMs and AI agents read the pages you choose instead of crawling raw HTML. |
| **ai-crawler-access** | Audit and configure `robots.txt`, meta robots, and `X-Robots-Tag` so the right AI crawlers (GPTBot, ClaudeBot, PerplexityBot, Google-Extended…) can reach your site. |

## Quickstart

Clone the repo and install everything into your current project:

```sh
git clone https://github.com/intura/intura-skills.git
cd intura-skills
make install
```

`make install` installs **all six skills for all agents** into the current
project (`SCOPE=project`, `PROJECT=$(CURDIR)`).

No `make`? Use the equivalent installer:

```sh
sh install.sh
```

### Project vs. global

```sh
make install                 # project scope (default): installs into PROJECT
make install SCOPE=global    # global scope: installs into your HOME
```

### Install a subset of skills

```sh
make install SKILLS="geo-optimize aeo-optimize"
```

`SKILLS` is either `all` (the default) or a space-separated list of skill names.

### Install into a different repo

```sh
make install PROJECT=/path/to/your/site
```

`PROJECT` is the destination project root. It is used for **project scope only**
and is ignored when `SCOPE=global`. Combine variables freely:

```sh
make install SCOPE=project PROJECT=/path/to/your/site SKILLS="seo-optimize structured-data"
```

## Per-agent usage

`make install` lays down what each agent needs. Here is how each one discovers
and runs a skill.

### Claude Code

Skills are copied to `<project>/.claude/skills/<name>/` (project scope) or
`$HOME/.claude/skills/<name>/` (global scope). Claude Code picks a skill up
**automatically when your request matches its description**, or you can invoke it
explicitly with `/skill <name>` (e.g. `/skill geo-optimize`).

```sh
make install-claude                 # project
make install-claude SCOPE=global    # global
```

### Codex

- **Global** — each skill is written to `$HOME/.codex/prompts/<name>.md` (the
  SKILL.md body with its YAML frontmatter stripped and a short header
  prepended). Invoke it with `/<name>` (e.g. `/geo-optimize`).
- **Project** — skills are vendored into `<project>/.intura/skills/<name>/` and a
  managed block is written into `<project>/AGENTS.md`. Codex reads `AGENTS.md`,
  matches the task to a skill, and follows
  `.intura/skills/<name>/SKILL.md`.

```sh
make install-codex SCOPE=global     # global prompts: /<name>
make install-codex                  # project: AGENTS.md block + vendored skills
```

### Generic agents (Cursor, Windsurf, Aider, …)

Any agent that reads `AGENTS.md` is supported. Skills are vendored into
`<project>/.intura/skills/<name>/` and a managed block is added to
`<project>/AGENTS.md`:

```text
<!-- BEGIN INTURA SKILLS (managed by intura-skills — do not edit by hand) -->
... a one-line intro, a | Skill | Use when | table, and the instruction:
"When a task matches a skill above, read .intura/skills/<name>/SKILL.md and follow it."
<!-- END INTURA SKILLS -->
```

The block is idempotent: re-installing **replaces** it in place (never
duplicates), and content outside the delimiters is never touched.

```sh
make install-agents                 # project: AGENTS.md block + vendored skills
```

> Global scope has no universal cross-agent standard, so
> `make install-agents SCOPE=global` prints a note and does nothing.

## Makefile reference

The `Makefile` is a thin wrapper; every target delegates to
`scripts/intura-skills.sh` (POSIX `sh`), which resolves its own location so it
works no matter where it is called from.

| Target | What it does |
| --- | --- |
| `help` | **Default target.** Print usage, variables, and the skill list. |
| `list` | List available skills with one-line descriptions. |
| `validate` | Run `scripts/validate.sh` (checks every `SKILL.md`). |
| `test` | Self-test: install all skills into a fresh temp `PROJECT`, assert artifacts exist, uninstall, assert they are gone, print `PASS`/`FAIL`, clean up. Never touches the real repo or your `HOME`. |
| `check` | Show what is installed where (project + global) for each agent. |
| `clean` | Remove temp/test artifacts. |
| `install` | Alias for `install-all`. |
| `install-all` | Install for `claude` + `codex` + `agents`, honoring `SCOPE`/`PROJECT`/`SKILLS`. |
| `install-claude` | Install Claude Code skills only. |
| `install-codex` | Install Codex prompts/vendored skills only. |
| `install-agents` | Install the `AGENTS.md` block + vendored skills only. |
| `uninstall` | Alias for `uninstall-all`. |
| `uninstall-all` | Uninstall for `claude` + `codex` + `agents`. |
| `uninstall-claude` | Remove Claude Code skills only. |
| `uninstall-codex` | Remove Codex prompts/vendored skills only. |
| `uninstall-agents` | Remove vendored skills and fix up the `AGENTS.md` block. |

### Variables

| Variable | Default | Meaning |
| --- | --- | --- |
| `SCOPE` | `project` | `project` or `global`. |
| `PROJECT` | `$(CURDIR)` | Destination project root. Used for project scope only; ignored for global. |
| `SKILLS` | `all` | `all`, or a space-separated subset of skill names. |

Override any of them on the command line, e.g.
`make install SCOPE=global SKILLS="llms-txt ai-crawler-access"`.

Each install/uninstall target ultimately runs:

```sh
sh scripts/intura-skills.sh <install|uninstall> <agent> <SCOPE> <PROJECT> <SKILLS...>
```

### Where things land

| Agent + scope | Destination |
| --- | --- |
| claude + project | `<project>/.claude/skills/<name>/` |
| claude + global | `$HOME/.claude/skills/<name>/` |
| codex + global | `$HOME/.codex/prompts/<name>.md` |
| codex + project | `<project>/.intura/skills/<name>/` + `<project>/AGENTS.md` block |
| agents + project | `<project>/.intura/skills/<name>/` + `<project>/AGENTS.md` block |
| agents + global | no-op (prints a note) |

## Uninstall, validate, test, check

```sh
make uninstall                       # remove everything from the current project
make uninstall SCOPE=global          # remove the global install
make uninstall SKILLS="geo-optimize" # remove a single skill
make uninstall PROJECT=/path/to/site # remove from another repo
```

Uninstall is symmetric with install: it removes exactly the skill dirs, prompt
files, and vendored copies that install created for the selected skills, and
fixes up the `AGENTS.md` block — regenerating it for any skills that remain, or
removing the block and its delimiters when none are left.

```sh
make validate    # assert every SKILL.md has frontmatter with matching name: and a non-empty description:
make test        # end-to-end install/uninstall self-test in a temp dir; prints PASS/FAIL
make check       # report what is installed where, per agent
```

Install and uninstall are **idempotent** — re-running either one overwrites the
skill dirs / prompt files and regenerates the `AGENTS.md` block, so nothing is
duplicated and nothing grows.

## Standalone & ownership

These skills are designed to **work offline**. There is **no Intura account, no
API key, and no telemetry** — installing and running them never calls a remote
service. Everything operates on files in your own repository.

The repository is owned and maintained by **Intura**. For more on AI visibility,
GEO/AEO, and managed solutions, visit [intura.co](https://intura.co).

## Contributing

Issues and pull requests are welcome. Each skill lives in
`skills/<name>/SKILL.md` (with optional support files alongside it); run
`make validate` and `make test` before opening a PR.

## License

[MIT](LICENSE) © Intura.
