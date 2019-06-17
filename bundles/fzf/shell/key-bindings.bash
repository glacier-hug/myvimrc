# Key bindings
# ------------
__fzf_select__() {
  local cmd="${FZF_CTRL_T_COMMAND:-"command find -L . -mindepth 1 \\( -path '*/\\.*' -o -fstype 'sysfs' -o -fstype 'devfs' -o -fstype 'devtmpfs' -o -fstype 'proc' \\) -prune \
    -o -type f -print \
    -o -type d -print \
    -o -type l -print 2> /dev/null | cut -b3-"}"
  eval "$cmd" | FZF_DEFAULT_OPTS="--height ${FZF_TMUX_HEIGHT:-40%} --reverse $FZF_DEFAULT_OPTS $FZF_CTRL_T_OPTS" fzf -m "$@" | while read -r item; do
    printf '%q ' "$item"
  done
  echo
}

if [[ $- =~ i ]]; then

__fzf_use_tmux__() {
  [ -n "$TMUX_PANE" ] && [ "${FZF_TMUX:-0}" != 0 ] && [ ${LINES:-40} -gt 15 ]
}

__fzfcmd() {
  __fzf_use_tmux__ &&
    echo "fzf-tmux -d${FZF_TMUX_HEIGHT:-40%}" || echo "fzf"
}

__fzf_select_tmux__() {
  local height
  height=${FZF_TMUX_HEIGHT:-40%}
  if [[ $height =~ %$ ]]; then
    height="-p ${height%\%}"
  else
    height="-l $height"
  fi

  tmux split-window $height "cd $(printf %q "$PWD"); FZF_DEFAULT_OPTS=$(printf %q "$FZF_DEFAULT_OPTS") PATH=$(printf %q "$PATH") FZF_CTRL_T_COMMAND=$(printf %q "$FZF_CTRL_T_COMMAND") FZF_CTRL_T_OPTS=$(printf %q "$FZF_CTRL_T_OPTS") bash -c 'source \"${BASH_SOURCE[0]}\"; RESULT=\"\$(__fzf_select__ --no-height)\"; tmux setb -b fzf \"\$RESULT\" \\; pasteb -b fzf -t $TMUX_PANE \\; deleteb -b fzf || tmux send-keys -t $TMUX_PANE \"\$RESULT\"'"
}

fzf-file-widget() {
  if __fzf_use_tmux__; then
    __fzf_select_tmux__
  else
    local selected="$(__fzf_select__)"
    READLINE_LINE="${READLINE_LINE:0:$READLINE_POINT}$selected${READLINE_LINE:$READLINE_POINT}"
    READLINE_POINT=$(( READLINE_POINT + ${#selected} ))
  fi
}

__fzf_cd__() {
  local cmd dir
  cmd="${FZF_ALT_C_COMMAND:-"command find -L . -mindepth 1 \\( -path '*/\\.*' -o -fstype 'sysfs' -o -fstype 'devfs' -o -fstype 'devtmpfs' -o -fstype 'proc' \\) -prune \
    -o -type d -print 2> /dev/null | cut -b3-"}"
  dir=$(eval "$cmd" | FZF_DEFAULT_OPTS="--height ${FZF_TMUX_HEIGHT:-40%} --reverse $FZF_DEFAULT_OPTS $FZF_ALT_C_OPTS" $(__fzfcmd) +m) && printf 'cd %q' "$dir"
}

__fzf_history__() (
  local line
  shopt -u nocaseglob nocasematch
  line=$(
    HISTTIMEFORMAT= builtin history |
    FZF_DEFAULT_OPTS="--height ${FZF_TMUX_HEIGHT:-40%} $FZF_DEFAULT_OPTS --tac --sync -n2..,.. --tiebreak=index --bind=ctrl-r:toggle-sort $FZF_CTRL_R_OPTS +m" $(__fzfcmd) |
    command grep '^ *[0-9]') &&
    if [[ $- =~ H ]]; then
      sed 's/^ *\([0-9]*\)\** .*/!\1/' <<< "$line"
    else
      sed 's/^ *\([0-9]*\)\** *//' <<< "$line"
    fi
)

if [[ ! -o vi ]]; then
  # Required to refresh the prompt after fzf
  bind '"\er": redraw-current-line'
  bind '"\e^": history-expand-line'

  # CTRL-T - Paste the selected file path into the command line
  if [ $BASH_VERSINFO -gt 3 ]; then
    bind -x '"\C-t": "fzf-file-widget"'
  elif __fzf_use_tmux__; then
    bind '"\C-t": " \C-u \C-a\C-k`__fzf_select_tmux__`\e\C-e\C-y\C-a\C-d\C-y\ey\C-h"'
  else
    bind '"\C-t": " \C-u \C-a\C-k`__fzf_select__`\e\C-e\C-y\C-a\C-y\ey\C-h\C-e\er \C-h"'
  fi

  # CTRL-R - Paste the selected command from history into the command line
  bind '"\C-r": " \C-e\C-u\C-y\ey\C-u`__fzf_history__`\e\C-e\er\e^"'

  # ALT-C - cd into the selected directory
  bind '"\ec": " \C-e\C-u`__fzf_cd__`\e\C-e\er\C-m"'
else
  # We'd usually use "\e" to enter vi-movement-mode so we can do our magic,
  # but this incurs a very noticeable delay of a half second or so,
  # because many other commands start with "\e".
  # Instead, we bind an unused key, "\C-x\C-a",
  # to also enter vi-movement-mode,
  # and then use that thereafter.
  # (We imagine that "\C-x\C-a" is relatively unlikely to be in use.)
  bind '"\C-x\C-a": vi-movement-mode'

  bind '"\C-x\C-e": shell-expand-line'
  bind '"\C-x\C-r": redraw-current-line'
  bind '"\C-x^": history-expand-line'

  # CTRL-T - Paste the selected file path into the command line
  # - FIXME: Selected items are attached to the end regardless of cursor position
  if [ $BASH_VERSINFO -gt 3 ]; then
    bind -x '"\C-t": "fzf-file-widget"'
  elif __fzf_use_tmux__; then
    bind '"\C-t": "\C-x\C-a$a \C-x\C-addi`__fzf_select_tmux__`\C-x\C-e\C-x\C-a0P$xa"'
  else
    bind '"\C-t": "\C-x\C-a$a \C-x\C-addi`__fzf_select__`\C-x\C-e\C-x\C-a0Px$a \C-x\C-r\C-x\C-axa "'
  fi
  bind -m vi-command '"\C-t": "i\C-t"'

  # CTRL-R - Paste the selected command from history into the command line
  bind '"\C-r": "\C-x\C-addi`__fzf_history__`\C-x\C-e\C-x\C-r\C-x^\C-x\C-a$a"'
  bind -m vi-command '"\C-r": "i\C-r"'

  # ALT-C - cd into the selected directory
  bind '"\ec": "\C-x\C-addi`__fzf_cd__`\C-x\C-e\C-x\C-r\C-m"'
  bind -m vi-command '"\ec": "ddi`__fzf_cd__`\C-x\C-e\C-x\C-r\C-m"'
fi

fi


# GIT heart FZF
# -------------

is_in_git_repo() {
  git rev-parse HEAD > /dev/null 2>&1
}

fzf-down() {
  fzf --height 50% "$@" --border
}

gf() {
  is_in_git_repo || return
  git -c color.status=always status --short |
  fzf-down -m --ansi --nth 2..,.. \
    --preview '(git diff --color=always -- {-1} | sed 1,4d; cat {-1}) | head -500' |
  cut -c4- | sed 's/.* -> //'
}

gb() {
  is_in_git_repo || return
  git branch -a --color=always | grep -v '/HEAD\s' | sort |
  fzf-down --ansi --multi --tac --preview-window right:70% \
    --preview 'git log --oneline --graph --date=short --color=always --pretty="format:%C(auto)%cd %h%d %s" $(sed s/^..// <<< {} | cut -d" " -f1) | head -'$LINES |
  sed 's/^..//' | cut -d' ' -f1 |
  sed 's#^remotes/##'
}

gt() {
  is_in_git_repo || return
  git tag --sort -version:refname |
  fzf-down --multi --preview-window right:70% \
    --preview 'git show --color=always {} | head -'$LINES
}

gh() {
  is_in_git_repo || return
  git log --date=short --format="%C(green)%C(bold)%cd %C(auto)%h%d %s (%an)" --graph --color=always |
  fzf-down --ansi --no-sort --reverse --multi --bind 'ctrl-s:toggle-sort' \
    --header 'Press CTRL-S to toggle sort' \
    --preview 'grep -o "[a-f0-9]\{7,\}" <<< {} | xargs git show --color=always | head -'$LINES |
  grep -o "[a-f0-9]\{7,\}"
}

gr() {
  is_in_git_repo || return
  git remote -v | awk '{print $1 "\t" $2}' | uniq |
  fzf-down --tac \
    --preview 'git log --oneline --graph --date=short --pretty="format:%C(auto)%cd %h%d %s" {1} | head -200' |
  cut -d$'\t' -f1
}

bind '"\er": redraw-current-line'
bind '"\C-g\C-f": "$(gf)\e\C-e\er"'
bind '"\C-g\C-b": "$(gb)\e\C-e\er"'
bind '"\C-g\C-t": "$(gt)\e\C-e\er"'
bind '"\C-g\C-h": "$(gh)\e\C-e\er"'
bind '"\C-g\C-r": "$(gr)\e\C-e\er"'
