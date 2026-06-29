# Makefile — thin wrapper around scripts/intura-skills.sh (POSIX sh).
# Every install/uninstall target delegates to the script:
#   sh scripts/intura-skills.sh <install|uninstall> <agent> <SCOPE> <PROJECT> <SKILLS...>

SHELL   := /bin/sh
SCRIPT  := scripts/intura-skills.sh

# --- variables (override on the command line) --------------------------------
SCOPE   ?= project        # project | global
PROJECT ?= $(CURDIR)      # destination project root (project scope only)
SKILLS  ?= all            # "all" or a space-separated subset of skill names

.PHONY: help list validate test check clean \
        install install-all install-claude install-codex install-agents \
        uninstall uninstall-all uninstall-claude uninstall-codex uninstall-agents

# --- help (default target) ---------------------------------------------------
help:
	@echo 'intura-skills — install AI-visibility skills into your project'
	@echo ''
	@echo 'Usage: make <target> [SCOPE=project|global] [PROJECT=/path] [SKILLS="a b"]'
	@echo ''
	@echo 'Targets:'
	@echo '  help               Print this help (default).'
	@echo '  list               List available skills with descriptions.'
	@echo '  validate           Check every SKILL.md is well-formed.'
	@echo '  test               End-to-end install/uninstall self-test in a temp dir.'
	@echo '  check              Show what is installed where, per agent.'
	@echo '  clean              Remove temp/test artifacts.'
	@echo '  install            Install all six skills for all agents (alias: install-all).'
	@echo '  install-claude     Install Claude Code skills only.'
	@echo '  install-codex      Install Codex prompts/vendored skills only.'
	@echo '  install-agents     Install the AGENTS.md block + vendored skills only.'
	@echo '  uninstall          Uninstall for all agents (alias: uninstall-all).'
	@echo '  uninstall-claude   Remove Claude Code skills only.'
	@echo '  uninstall-codex    Remove Codex prompts/vendored skills only.'
	@echo '  uninstall-agents   Remove vendored skills and fix up the AGENTS.md block.'
	@echo ''
	@echo 'Variables:'
	@echo '  SCOPE   = $(SCOPE)   (project | global)'
	@echo '  PROJECT = $(PROJECT)'
	@echo '  SKILLS  = $(SKILLS)  (all, or a space-separated subset)'
	@echo ''
	@echo 'Skills:'
	@$(SHELL) $(SCRIPT) list

list:
	@$(SHELL) $(SCRIPT) list

validate:
	@$(SHELL) $(SCRIPT) validate

check:
	@$(SHELL) $(SCRIPT) check $(SCOPE) "$(PROJECT)"

# --- install -----------------------------------------------------------------
install: install-all

install-all:
	@$(SHELL) $(SCRIPT) install all $(SCOPE) "$(PROJECT)" $(SKILLS)

install-claude:
	@$(SHELL) $(SCRIPT) install claude $(SCOPE) "$(PROJECT)" $(SKILLS)

install-codex:
	@$(SHELL) $(SCRIPT) install codex $(SCOPE) "$(PROJECT)" $(SKILLS)

install-agents:
	@$(SHELL) $(SCRIPT) install agents $(SCOPE) "$(PROJECT)" $(SKILLS)

# --- uninstall ---------------------------------------------------------------
uninstall: uninstall-all

uninstall-all:
	@$(SHELL) $(SCRIPT) uninstall all $(SCOPE) "$(PROJECT)" $(SKILLS)

uninstall-claude:
	@$(SHELL) $(SCRIPT) uninstall claude $(SCOPE) "$(PROJECT)" $(SKILLS)

uninstall-codex:
	@$(SHELL) $(SCRIPT) uninstall codex $(SCOPE) "$(PROJECT)" $(SKILLS)

uninstall-agents:
	@$(SHELL) $(SCRIPT) uninstall agents $(SCOPE) "$(PROJECT)" $(SKILLS)

# --- test / clean ------------------------------------------------------------
# Self-test: install all skills into a fresh temp PROJECT (project scope, so it
# never touches the real repo or your HOME), assert artifacts exist, uninstall,
# assert they are gone. Prints PASS/FAIL and cleans up.
test:
	@tmp=`mktemp -d 2>/dev/null || mktemp -d -t intura-skills`; \
	rc=0; \
	echo "test project: $$tmp"; \
	$(SHELL) $(SCRIPT) install all project "$$tmp" all >/dev/null; \
	for s in geo-optimize aeo-optimize seo-optimize structured-data llms-txt ai-crawler-access; do \
	  [ -d "$$tmp/.claude/skills/$$s" ] || { echo "FAIL missing claude skill $$s"; rc=1; }; \
	  [ -d "$$tmp/.intura/skills/$$s" ] || { echo "FAIL missing vendored skill $$s"; rc=1; }; \
	done; \
	grep -q "BEGIN INTURA SKILLS" "$$tmp/AGENTS.md" || { echo "FAIL missing AGENTS.md block"; rc=1; }; \
	$(SHELL) $(SCRIPT) uninstall all project "$$tmp" all >/dev/null; \
	for s in geo-optimize aeo-optimize seo-optimize structured-data llms-txt ai-crawler-access; do \
	  [ -d "$$tmp/.claude/skills/$$s" ] && { echo "FAIL leftover claude skill $$s"; rc=1; }; \
	  [ -d "$$tmp/.intura/skills/$$s" ] && { echo "FAIL leftover vendored skill $$s"; rc=1; }; \
	done; \
	[ -f "$$tmp/AGENTS.md" ] && grep -q "BEGIN INTURA SKILLS" "$$tmp/AGENTS.md" && { echo "FAIL leftover AGENTS.md block"; rc=1; }; \
	rm -rf "$$tmp"; \
	if [ "$$rc" -eq 0 ]; then echo PASS; else echo FAIL; fi; \
	exit $$rc

clean:
	@rm -rf .intura-test-* 2>/dev/null || true
	@echo "cleaned temp/test artifacts"
