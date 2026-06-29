#!/bin/sh
set -eu

# validate.sh — assert each skill source is well-formed.
# For every skills/<name>/SKILL.md: it must exist, start with YAML frontmatter,
# have a frontmatter name: equal to <name>, and a non-empty description:.
# Prints one OK/FAIL line per skill and exits nonzero if any fail.

SELF="$0"
SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$SELF")" && pwd -P)
REPO_ROOT=$(CDPATH= cd -- "$SCRIPT_DIR/.." && pwd -P)

ALL_SKILLS="geo-optimize aeo-optimize seo-optimize structured-data llms-txt ai-crawler-access"

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

rc=0
for name in $ALL_SKILLS; do
  f="$REPO_ROOT/skills/$name/SKILL.md"
  if [ ! -f "$f" ]; then
    printf 'FAIL %-20s missing SKILL.md\n' "$name"
    rc=1
    continue
  fi
  first=$(head -n 1 "$f")
  if [ "$first" != "---" ]; then
    printf 'FAIL %-20s no YAML frontmatter (first line is not "---")\n' "$name"
    rc=1
    continue
  fi
  nm=$(extract_name "$f")
  ds=$(extract_desc "$f")
  if [ "$nm" != "$name" ]; then
    printf 'FAIL %-20s name mismatch (frontmatter name: "%s")\n' "$name" "$nm"
    rc=1
    continue
  fi
  if [ -z "$ds" ]; then
    printf 'FAIL %-20s empty description\n' "$name"
    rc=1
    continue
  fi
  printf 'OK   %-20s\n' "$name"
done

exit "$rc"
