#!/bin/sh
set -eu

# install.sh — root bootstrap for users without make.
# Forwards all arguments to scripts/intura-skills.sh. With no arguments it
# defaults to: install all project "$PWD".

DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd -P)
SCRIPT="$DIR/scripts/intura-skills.sh"

if [ "$#" -eq 0 ]; then
  exec sh "$SCRIPT" install all project "$PWD"
fi

exec sh "$SCRIPT" "$@"
