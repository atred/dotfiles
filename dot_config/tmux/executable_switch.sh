#!/usr/bin/env bash

TMUX_BIN="${TMUX_BIN:-tmux}"
FZF_BIN="${FZF_BIN:-fzf}"

CURRENT="$($TMUX_BIN display-message -p '#S')"

LIST_SESSIONS="$TMUX_BIN list-sessions -F '#{session_last_attached} #{session_name}' | sort -rn | cut -d' ' -f2- | grep -Fxv -e $(printf %q "$CURRENT")"

RENAME_EXEC='bash -c '\''printf >&2 "New name: "; read -r name; '"$TMUX_BIN"' rename-session -t "=$1" "$name" || { printf >&2 "Press any key..."; read -rsn1; }'\'' _ {}'

RESULT=$(eval "$LIST_SESSIONS" | $FZF_BIN --tmux "50%,50%" \
  --with-shell 'bash -c' \
  --prompt "> " \
  --print-query \
  --bind "ctrl-r:execute($RENAME_EXEC)+reload($LIST_SESSIONS)+clear-query+first" \
  --bind "ctrl-n:execute-silent($TMUX_BIN new-session -ds {q})+print-query+abort" \
  --header "enter=switch  ctrl-n=new  ctrl-r=rename" \
  | tail -n1)

[[ -z "$RESULT" ]] && exit 0

RESULT="${RESULT//[.:]/_}"

if ! $TMUX_BIN has-session -t="$RESULT" 2>/dev/null; then
  $TMUX_BIN new-session -ds "$RESULT"
fi

$TMUX_BIN switch-client -t="$RESULT"
