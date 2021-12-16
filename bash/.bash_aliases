alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

alias f='find . -iname'
alias fif='find . -type f -iname'
alias fid='find . -type d -iname'

alias df='df -h'

alias du1='du -h -d1'
alias du0='du -h -d0'
alias grn='grep -rn'
alias grni='grep -rni'

alias xo='xdg-open'

alias rsyncp='rsync --info=progress2 -ah'

alias manc='PAGER="most" man'
alias y='yank'
alias cb='xclip -sel clip'
alias vou='setxkbmap de koy && xkbcomp ~/bin/vou.xkb $DISPLAY'

alias acs='apt-cache search'
alias sai='sudo apt install'
alias ali='apt list --installed'
alias nh='sudo nethogs wlp2s0 -v 3'
alias hg='history | grep'
alias titlecase=$'rename \'s/(\S+)/\u\L$1/g\''

alias rr='ranger'
alias batp='bat --style=plain'

# git
alias g='git status'
alias gd='git diff'
alias gp='git pull'
# gh = "git home" (go to the toplevel of the current repo)
alias gh='cd $(git rev-parse --show-toplevel)'
# git log
alias gl='git log'
# git log compact
alias glc='git log --pretty="%C(Yellow)%h   %C(reset)%ai (%C(Green)%cr%C(reset))%x09 %C(reset)%s %C(Red)%d%C(reset)" --decorate=full'
alias glch='git --no-pager log --pretty="%C(Yellow)%h   %C(reset)%ai (%C(Green)%cr%C(reset))%x09 %C(reset)%s %C(Red)%d%C(reset)" --decorate=full -n 10'
# git log compact [with] names
alias glcn='git log --pretty="%C(Yellow)%h  %C(reset)%ai (%C(Green)%cr%C(reset))%x09 %C(Cyan)%an: %C(reset)%s"'
alias glcnh='git --no-pager log --pretty="%C(Yellow)%h  %C(reset)%ai (%C(Green)%cr%C(reset))%x09 %C(Cyan)%an: %C(reset)%s" -n 10'
alias gitlog='git log --oneline --graph --decorate'
alias gitlogs='git log --oneline --graph --decorate --stat'
alias gitloga='git log --oneline --graph --decorate --all'
alias gitlogc='git log --pretty="%C(Yellow)%h  %C(reset)%ad (%C(Green)%cr%C(reset))%x09 %C(Cyan)%an: %C(reset)%s"'
alias gitunpushed='git log ..@{u}'
alias gitunmerged='git branch --no-merged master'

alias caei='xhost &> /dev/null && setxkbmap de -option || sudo loadkeys de'
alias asdf='xhost &> /dev/null && setxkbmap de koy && xkbcomp -w 0 ~/bin/vou-tabwin.xkb $DISPLAY || sudo loadkeys ~/bin/vou.map'

if [ "$TERM" = cygwin ]; then
  alias nvim='~/Downloads/Neovim/bin/nvim-qt.exe'
  alias nvimdiff='~/Downloads/Neovim/bin/nvim-qt.exe -- -d'
fi
