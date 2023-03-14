exists() {
  command -v "$1" > /dev/null 2>&1 ;
}
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

alias la='ls -A'
alias ll='ls -alF'
if exists exa; then
  alias l='exa -alF --color-scale'
  alias lll='exa -l -s age --color=always | head -n 10'
else
  alias l='ls -CF'
  alias lll='ll -t | head -n 10'
fi
alias lg='exa -alF --color-scale --git'

alias f='find . -iname'
alias fif='find . -type f -iname'
alias fid='find . -type d -iname'
exists fd || { exists fdfind && alias fd='fdfind'; }
alias fda='fd -HI'

alias du1='du -h -d1'
alias du0='du -h -d0'
alias grn='grep -rn'
alias grni='grep -rni'
alias wlan='nmcli d wifi'
alias ncdu='ncdu --color=dark'
alias rgf='rg --fixed-strings'

alias path='echo $PATH | tr : "\n"'
alias pypath='echo $PYTHONPATH | tr : "\n"'

alias xo='xdg-open'

exists ncal && alias cal='ncal -bwM3' || alias cal='cal -3'

alias rsyncp='rsync --info=progress2 -ah'

exists most && alias manc='PAGER=most man'
alias y='yank'
alias cb='xclip -sel clip'
alias vou='setxkbmap de koy && xkbcomp ~/bin/vou.xkb $DISPLAY'

alias acs='apt-cache search'
alias sai='sudo apt install'
alias sau='sudo apt update'
alias saU='sudo apt upgrade'
alias alu='apt list --upgradable'
alias ali='apt list --installed'
alias ap='apt policy'

alias sps='sudo pacman -S'
alias spss='sudo pacman -Ss'
alias syu='sudo pacman -Syu'

alias nh='sudo nethogs wlp2s0 -v 3'
alias hg='history | grep'
alias titlecase='perl-rename "s/(\S+)/\u\L\$1/g"'

alias pl='patool list'
alias pe='patool extract'
alias px='patool extract'
alias pc='patool create'
alias pd='patool diff'

exists nvim && VIM='nvim' || VIM='vim'
alias v=$VIM
alias vv="$VIM -c \"normal '0\""
alias n='nvim'
# start vim and open vim-fugitive's git status
# (and close the empty buffer and jump to the first unstaged file)
alias vg="$VIM +G +'silent %bd|e#' +'norm gU'"

alias rr='ranger'
alias batp='bat --style=plain'

alias cv="$VIM ~/.vimrc"
alias cn="$VIM ~/.config/nvim/init.vim"
alias cf="$VIM ~/.config/fish/config.fish"
alias ca="$VIM ~/.config/fish/aliases.fish"
alias cs="$VIM ~/.config/sxhkd/sxhkdrc"
alias ct="$VIM ~/.tmux.conf"
alias ck="$VIM ~/.config/kmonad/vou-linux-de-rctrl.kbd"
alias td="$VIM ~/dev/gta_local/max/todo/todo.md"

alias akku='upower -i /org/freedesktop/UPower/devices/battery_BAT0 | grep -E "power|updated|state|energy|time to|perc|capa" | grep -v design'

# git
alias g='git status'
alias gd='git diff'
alias gp='git pull'
alias gps='git push'
# gh = "git home" (go to the toplevel of the current repo)
alias gh='cd $(git rev-parse --show-toplevel)'
# git log
alias gl='git log'

hash_date_reldate='%C(Yellow)%h   %C(reset)%ai %<(14)(%C(Green)%cr%C(reset))%x09 %C(reset)'
author='%C(Cyan)%an: %C(reset)'
message_refs='%s %C(Red)%d%C(reset)'
format_short="${hash_date_reldate}${message_refs}"
format_names="${hash_date_reldate}${author}${message_refs}"
# git log compact
alias glc="git log --pretty=\"${format_short}\" --decorate"
alias glch="git --no-pager log --pretty=\"${format_short}\" --decorate -n 10"
# git log compact [with] names
alias glcn="git log --pretty=\"${format_names}\" --decorate"
alias glcnh="git --no-pager log --pretty=\"${format_names}\" --decorate -n 10"

alias gitlog='git log --oneline --graph --decorate'
alias gitlogs='git log --oneline --graph --decorate --stat'
alias gitloga='git log --oneline --graph --decorate --all'
alias gitunpushed='git log ..@{u}'
alias gitunmerged='git branch --no-merged master'

# copy current branch name into clipboard
alias cpbr='git rev-parse --abbrev-ref HEAD | tr -d \n | xclip -sel clip'

alias cr='crontab -l | grep --color=never "^[^#]"'

alias disp='. ~/bin/update-DISPLAY.sh'

alias caei='xhost > /dev/null 2>&1 && setxkbmap de -option || sudo loadkeys de'
alias asdf='xhost > /dev/null 2>&1 && setxkbmap de koy && xkbcomp -w 0 ~/bin/vou-tabwin.xkb $DISPLAY || sudo loadkeys ~/bin/vou.map'

if [ "$TERM" = cygwin ]; then
  alias nvim='~/Downloads/Neovim/bin/nvim-qt.exe'
  alias nvimdiff='~/Downloads/Neovim/bin/nvim-qt.exe -- -d'
fi

unset -f exists
