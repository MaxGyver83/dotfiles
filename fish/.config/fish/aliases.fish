# aliases
abbr ... 'cd ../..'
abbr .... 'cd ../../..'
abbr ..... 'cd ../../../..'

alias ll='ls -halF'
alias la='ls -A'
alias l='ls -CF'

abbr ff 'fzf'

abbr fi 'find . -iname'
abbr fif 'find . -type f -iname'
abbr fid 'find . -type d -iname'
alias fd='fdfind'

abbr df 'df -h'

abbr du1 'du -h -d1'
abbr du0 'du -h -d0'
abbr grn 'grep -rn'
abbr grni 'grep -rni'

abbr xo 'xdg-open'

abbr rsyncp 'rsync --info=progress2 -ah'

abbr manc 'set PAGER most; man'
abbr y 'yank'
abbr cb 'xclip -sel clip'

# lc = last command
abbr lc 'eval $history[1]'
# lcs = last command, select line
abbr lcs 'eval $history[1] | yank'

abbr acs 'apt-cache search'
abbr sai 'sudo apt install'
abbr ali 'apt list --installed'
abbr nh 'sudo nethogs wlp2s0 -v 3'
abbr hg 'history | grep'

alias notes='search_in_notes.sh'

abbr v 'vim'
if [ -f ~/install/nvim.appimage ]
    alias n='~/install/nvim.appimage'
end
abbr rr 'ranger'
alias feh='feh --scale-down --auto-zoom --auto-rotate'

# bat: default: line numbers, no pager
alias batp='bat -pp'
alias batl='bat --pager="less"'

# git
abbr g 'git status'
abbr gd 'git diff'
abbr gp 'git pull'
# gh = "git home" (go to the toplevel of the current repo)
abbr gh 'cd (git rev-parse --show-toplevel)'
# git log
alias gitlog='git log --oneline --graph --decorate'
alias gitlogs='git log --oneline --graph --decorate --stat'
alias gitloga='git log --oneline --graph --decorate --all'
alias gitlogc='git log --pretty="%C(Yellow)%h  %C(reset)%ai (%C(Green)%cr%C(reset))%x09 %C(Cyan)%an: %C(reset)%s"'
abbr gitunpushed 'git log ..@{u}'
abbr gitunmerged 'git branch --no-merged master'
alias gb "git for-each-ref --sort=committerdate refs/remotes/origin/ --format='%(HEAD) %(color:red)%(objectname:short)%(color:reset) %(color:yellow)%(refname:short)%(color:reset)  %(contents:subject)  %(color:cyan)%(authorname)%(color:reset) (%(color:green)%(committerdate:relative)%(color:reset))'"

# source work related / private stuff (not part of the dotfiles repo)
if [ -f $HOME/.config/fish/local.fish ]
  source $HOME/.config/fish/local.fish
end

