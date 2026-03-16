#!/usr/bin/env bash

TMUX_BIN="${TMUX_BIN:-tmux}"
FZF_BIN="${FZF_BIN:-fzf}"

CURRENT="$($TMUX_BIN display-message -p '#S')"

SESSIONS=$($TMUX_BIN list-sessions | sed -E 's/:.*$//' | grep -Fxv "$CURRENT")

RENAME_EXEC='bash -c '\''printf >&2 "New name: "; read name; '"$TMUX_BIN"' rename-session -t {1} "$name"'\'''
RENAME_RELOAD="$TMUX_BIN list-sessions | sed -E 's/:.*$//'"

RESULT=$(echo "$SESSIONS" | $FZF_BIN --tmux "50%,50%" \
  --prompt " " \
  --print-query \
  --bind "ctrl-r:execute($RENAME_EXEC)+reload($RENAME_RELOAD)" \
  --bind "ctrl-n:execute-silent($TMUX_BIN new-session -ds {q})+print-query+abort" \
  --header "enter=switch  ctrl-n=new  ctrl-r=rename" \
  | tail -n1)

[[ -z "$RESULT" ]] && exit 0

if ! $TMUX_BIN has-session -t="$RESULT" 2>/dev/null; then
  $TMUX_BIN new-session -ds "$RESULT"
fi

$TMUX_BIN switch-client -t "$RESULT"
