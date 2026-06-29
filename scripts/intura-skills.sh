#!/bin/sh
set -eu

# intura-skills.sh — manage Intura skills for Claude, Codex, and AGENTS.md.
# POSIX sh only. Runs on macOS (BSD) and Linux (GNU). No bashisms.

# --- locate the repo root (the dir that contains skills/) ---------------------
SELF="$0"
SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$SELF")" && pwd -P)
REPO_ROOT=$(CDPATH= cd -- "$SCRIPT_DIR/.." && pwd -P)

ALL_SKILLS="geo-optimize aeo-optimize seo-optimize structured-data llms-txt ai-crawler-access"

AGENTS_BEGIN='<!-- BEGIN INTURA SKILLS (managed by intura-skills — do not edit by hand) -->'
AGENTS_END='<!-- END INTURA SKILLS -->'

# --- small helpers ------------------------------------------------------------

# extract_name <SKILL.md> : print the frontmatter "name:" value (trimmed)
extract_name() {
  awk '
    BEGIN { infm = 0 }
    NR == 1 && $0 == "---" { infm = 1; next }
    infm && $0 == "---" { exit }
    infm && $0 ~ /^name:/ {
      v = $0
      sub(/^name:[ \t]*/, "", v)
      sub(/[ \t]+$/, "", v)
      print v
      exit
    }
  ' "$1"
}

# extract_desc <SKILL.md> : print the frontmatter "description:" collapsed to
# one line. Handles plain scalars and folded/literal block scalars (>- | etc).
extract_desc() {
  awk '
    BEGIN { infm = 0; indesc = 0; desc = "" }
    {
      if (NR == 1) {
        if ($0 == "---") { infm = 1; next }
        else { infm = 0 }
      }
      if (infm && $0 == "---") { exit }
      if (infm) {
        if (indesc) {
          if ($0 ~ /^[ \t]/) {
            line = $0
            sub(/^[ \t]+/, "", line)
            desc = (desc == "" ? line : desc " " line)
            next
          } else {
            indesc = 0
          }
        }
        if ($0 ~ /^description:/) {
          val = $0
          sub(/^description:[ \t]*/, "", val)
          sub(/[ \t]+$/, "", val)
          if (val == "" || val ~ /^[|>][+0-9-]*$/) {
            indesc = 1
          } else {
            desc = val
            indesc = 1
          }
        }
      }
    }
    END {
      gsub(/[ \t]+/, " ", desc)
      sub(/^ +/, "", desc)
      sub(/ +$/, "", desc)
      print desc
    }
  ' "$1"
}

# strip_frontmatter <SKILL.md> : print the body with the first YAML frontmatter
# block (--- ... ---) removed and leading blank lines trimmed.
strip_frontmatter() {
  awk '
    BEGIN { fm = 0; started = 0 }
    NR == 1 && $0 == "---" { fm = 1; next }
    fm == 1 && $0 == "---" { fm = 0; next }
    fm == 1 { next }
    started == 0 && $0 ~ /^[ \t]*$/ { next }
    { started = 1; print }
  ' "$1"
}

has_skill() {
  [ -f "$REPO_ROOT/skills/$1/SKILL.md" ]
}

# skills_list <args...> : echo the resolved skill list (all six, or the subset).
skills_list() {
  if [ "$#" -eq 0 ]; then
    printf '%s' "$ALL_SKILLS"
    return
  fi
  if [ "$1" = "all" ]; then
    printf '%s' "$ALL_SKILLS"
    return
  fi
  printf '%s' "$*"
}

# --- AGENTS.md managed block --------------------------------------------------

# generate_block <project> : print the managed block built from the skills
# currently vendored under <project>/.intura/skills/.
generate_block() {
  proj="$1"
  printf '%s\n' "$AGENTS_BEGIN"
  printf '%s\n\n' "Intura skills are vendored in this project under .intura/skills/. Use them when a task matches the table below."
  printf '%s\n' "| Skill | Use when |"
  printf '%s\n' "| --- | --- |"
  for d in "$proj/.intura/skills"/*/; do
    [ -d "$d" ] || continue
    f="${d%/}/SKILL.md"
    [ -f "$f" ] || continue
    nm=$(basename "$d")
    ds=$(extract_desc "$f")
    ds=$(printf '%s' "$ds" | sed 's/|/\\|/g')
    printf '| %s | %s |\n' "$nm" "$ds"
  done
  printf '\n%s\n' "When a task matches a skill above, read .intura/skills/<name>/SKILL.md and follow it."
  printf '%s\n' "$AGENTS_END"
}

# update_agents <project> : regenerate (or remove) the managed block to reflect
# whatever skills are currently vendored. Idempotent; leaves other content alone.
update_agents() {
  proj="$1"
  agents="$proj/AGENTS.md"

  count=0
  for d in "$proj/.intura/skills"/*/; do
    [ -d "$d" ] || continue
    [ -f "${d%/}/SKILL.md" ] || continue
    count=$((count + 1))
  done

  if [ "$count" -gt 0 ]; then
    blockfile=$(mktemp)
    generate_block "$proj" > "$blockfile"
    if [ -f "$agents" ]; then
      tmp=$(mktemp)
      awk -v bf="$blockfile" -v B="$AGENTS_BEGIN" -v E="$AGENTS_END" '
        function emit(   l) { while ((getline l < bf) > 0) print l; close(bf) }
        BEGIN { inb = 0; found = 0 }
        $0 == B { found = 1; inb = 1; emit(); next }
        inb == 1 { if ($0 == E) { inb = 0 } next }
        { print; last = $0 }
        END { if (found == 0) { if (NR > 0 && last != "") print ""; emit() } }
      ' "$agents" > "$tmp"
      mv "$tmp" "$agents"
    else
      cp "$blockfile" "$agents"
    fi
    rm -f "$blockfile"
    echo "updated AGENTS.md block: $agents"
  else
    if [ -f "$agents" ]; then
      tmp=$(mktemp)
      awk -v B="$AGENTS_BEGIN" -v E="$AGENTS_END" '
        BEGIN { inb = 0 }
        $0 == B { inb = 1; next }
        inb == 1 { if ($0 == E) { inb = 0 } next }
        { print }
      ' "$agents" > "$tmp"
      mv "$tmp" "$agents"
      echo "removed AGENTS.md block: $agents"
    fi
  fi
}

# --- codex prompt -------------------------------------------------------------

write_codex_prompt() {
  name="$1"
  f="$REPO_ROOT/skills/$name/SKILL.md"
  d=$(extract_desc "$f")
  printf '# %s (Intura skill)\n\nInvoke with /%s. %s\n\n' "$name" "$name" "$d"
  strip_frontmatter "$f"
}

# --- install ------------------------------------------------------------------

install_skill() {
  agent="$1"; scope="$2"; proj="$3"; name="$4"
  src="$REPO_ROOT/skills/$name"
  case "$agent:$scope" in
    claude:project)
      dest="$proj/.claude/skills/$name"
      rm -rf "$dest"; mkdir -p "$(dirname "$dest")"; cp -R "$src" "$dest"
      echo "installed claude(project): $dest" ;;
    claude:global)
      dest="$HOME/.claude/skills/$name"
      rm -rf "$dest"; mkdir -p "$(dirname "$dest")"; cp -R "$src" "$dest"
      echo "installed claude(global): $dest" ;;
    codex:global)
      dest="$HOME/.codex/prompts/$name.md"
      mkdir -p "$(dirname "$dest")"
      write_codex_prompt "$name" > "$dest"
      echo "installed codex(global): $dest" ;;
    codex:project|agents:project)
      dest="$proj/.intura/skills/$name"
      rm -rf "$dest"; mkdir -p "$(dirname "$dest")"; cp -R "$src" "$dest"
      echo "vendored: $dest" ;;
    *)
      echo "unknown target $agent:$scope" >&2; exit 2 ;;
  esac
}

install_one() {
  agent="$1"; scope="$2"; proj="$3"; shift 3
  if [ "$agent" = "agents" ] && [ "$scope" = "global" ]; then
    echo "note: agents + global has no universal standard; nothing to install (no-op)."
    return
  fi
  for name in "$@"; do
    if ! has_skill "$name"; then
      echo "skip: $name (no skills/$name/SKILL.md)" >&2
      continue
    fi
    install_skill "$agent" "$scope" "$proj" "$name"
  done
  case "$agent:$scope" in
    codex:project|agents:project) update_agents "$proj" ;;
  esac
}

cmd_install() {
  if [ "$#" -lt 3 ]; then
    echo "usage: install <agent> <scope> <project> [skills...]" >&2
    exit 2
  fi
  agent="$1"; scope="$2"; proj="$3"; shift 3
  SK=$(skills_list "$@")
  case "$agent" in
    all)
      install_one claude "$scope" "$proj" $SK
      install_one codex "$scope" "$proj" $SK
      install_one agents "$scope" "$proj" $SK ;;
    claude|codex|agents)
      install_one "$agent" "$scope" "$proj" $SK ;;
    *)
      echo "unknown agent: $agent" >&2; exit 2 ;;
  esac
}

# --- uninstall ----------------------------------------------------------------

uninstall_skill() {
  agent="$1"; scope="$2"; proj="$3"; name="$4"
  case "$agent:$scope" in
    claude:project)
      dest="$proj/.claude/skills/$name"
      rm -rf "$dest"; echo "removed claude(project): $dest" ;;
    claude:global)
      dest="$HOME/.claude/skills/$name"
      rm -rf "$dest"; echo "removed claude(global): $dest" ;;
    codex:global)
      dest="$HOME/.codex/prompts/$name.md"
      rm -f "$dest"; echo "removed codex(global): $dest" ;;
    codex:project|agents:project)
      dest="$proj/.intura/skills/$name"
      rm -rf "$dest"; echo "removed vendored: $dest" ;;
    *)
      echo "unknown target $agent:$scope" >&2; exit 2 ;;
  esac
}

uninstall_one() {
  agent="$1"; scope="$2"; proj="$3"; shift 3
  if [ "$agent" = "agents" ] && [ "$scope" = "global" ]; then
    echo "note: agents + global has no universal standard; nothing to uninstall (no-op)."
    return
  fi
  for name in "$@"; do
    uninstall_skill "$agent" "$scope" "$proj" "$name"
  done
  case "$agent:$scope" in
    codex:project|agents:project) update_agents "$proj" ;;
  esac
}

cmd_uninstall() {
  if [ "$#" -lt 3 ]; then
    echo "usage: uninstall <agent> <scope> <project> [skills...]" >&2
    exit 2
  fi
  agent="$1"; scope="$2"; proj="$3"; shift 3
  SK=$(skills_list "$@")
  case "$agent" in
    all)
      uninstall_one claude "$scope" "$proj" $SK
      uninstall_one codex "$scope" "$proj" $SK
      uninstall_one agents "$scope" "$proj" $SK ;;
    claude|codex|agents)
      uninstall_one "$agent" "$scope" "$proj" $SK ;;
    *)
      echo "unknown agent: $agent" >&2; exit 2 ;;
  esac
}

# --- list / check / validate --------------------------------------------------

cmd_list() {
  for name in $ALL_SKILLS; do
    f="$REPO_ROOT/skills/$name/SKILL.md"
    if [ -f "$f" ]; then
      d=$(extract_desc "$f")
      short=$(printf '%s' "$d" | cut -c1-100)
      if [ "${#d}" -gt 100 ]; then
        short="$short..."
      fi
      printf '  %-20s %s\n' "$name" "$short"
    else
      printf '  %-20s %s\n' "$name" "(SKILL.md missing)"
    fi
  done
}

cmd_check() {
  scope="${1:-project}"
  proj="${2:-$PWD}"
  echo "Intura skills — install status"
  echo "scope requested: $scope"
  echo "project: $proj"
  echo "home:    $HOME"
  echo ""
  for name in $ALL_SKILLS; do
    if [ -d "$proj/.claude/skills/$name" ]; then a=yes; else a=no; fi
    if [ -d "$HOME/.claude/skills/$name" ]; then b=yes; else b=no; fi
    if [ -f "$HOME/.codex/prompts/$name.md" ]; then c=yes; else c=no; fi
    if [ -d "$proj/.intura/skills/$name" ]; then e=yes; else e=no; fi
    printf '  %-20s claude-project=%-3s claude-global=%-3s codex-global=%-3s vendored-project=%-3s\n' \
      "$name" "$a" "$b" "$c" "$e"
  done
  echo ""
  if [ -f "$proj/AGENTS.md" ] && grep -q "BEGIN INTURA SKILLS" "$proj/AGENTS.md"; then
    echo "AGENTS.md managed block: present"
  else
    echo "AGENTS.md managed block: absent"
  fi
}

cmd_validate() {
  exec sh "$REPO_ROOT/scripts/validate.sh"
}

usage() {
  cat <<'EOF'
intura-skills.sh — manage Intura skills

Usage:
  intura-skills.sh list
  intura-skills.sh validate
  intura-skills.sh check     <scope> <project>
  intura-skills.sh install   <agent> <scope> <project> [skills...]
  intura-skills.sh uninstall <agent> <scope> <project> [skills...]

  agent: claude | codex | agents | all
  scope: project | global
  skills: omit or "all" for all six, or a space-separated subset.
EOF
}

# --- dispatch -----------------------------------------------------------------

cmd="${1:-help}"
if [ "$#" -gt 0 ]; then
  shift
fi

case "$cmd" in
  list)      cmd_list ;;
  validate)  cmd_validate ;;
  check)     cmd_check "$@" ;;
  install)   cmd_install "$@" ;;
  uninstall) cmd_uninstall "$@" ;;
  help|-h|--help) usage ;;
  *)         usage; exit 2 ;;
esac
