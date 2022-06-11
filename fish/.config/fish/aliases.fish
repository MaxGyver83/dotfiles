# aliases
abbr ... 'cd ../..'
abbr .... 'cd ../../..'
abbr ..... 'cd ../../../..'

alias ll='ls -hAlF'
alias la='ls -A'
abbr lll 'll -t | head -n 10'
type -q exa && alias l='exa -alF --color-scale' || alias l='ls -CF'
alias lg='exa -alF --color-scale --git'

abbr ff 'fzf'

abbr fi 'find . -iname'
abbr fif 'find . -type f -iname'
abbr fid 'find . -type d -iname'
type -q fd || begin; type -q fdfind && alias fd='fdfind'; end
abbr fda 'fd -HI'

abbr du1 'du -h -d1'
abbr du0 'du -h -d0'
abbr grn 'grep -rn'
abbr grni 'grep -rni'
abbr wlan 'nmcli d wifi'
abbr ncdu 'ncdu --color=dark'
abbr rgf 'rg --fixed-strings'

abbr xo 'xdg-open'

abbr cal 'ncal -bwM3'

abbr rsyncp 'rsync --info=progress2 -ah'

abbr nw '(ls -Art | tail -n 1)'

abbr manc 'set PAGER most; man'
abbr y 'yank'
abbr cb 'xclip -sel clip'
# get last non-empty line from previous output and paste it into command line (in tmux/byobu)
alias out='tmux capture-pane -p | awk /./ | sed /▶/d | sed /\(ansi/d| tail -1 | tr "\n" " " | string trim | tmux load-buffer - && tmux paste-buffer -s " "'
# lc = last command
abbr lc 'eval $history[1] -- xsel -b'
# lcs = last command, select (word)
abbr lcs 'eval $history[1] | yank -- xsel -b'
# lcsl = last command, select line
abbr lcsl 'eval $history[1] | yank -l -- xsel -b'

# not escaped: rg -N 'Emit.*Press' ~/kmonad.log | sed 's/Emitting: Press //' | tr '\n' ' ' | sed 's/<\(.\)>/\1/g' | sed "s/<sft> '/\"/g" | sed 's/<spc>/\n/g' | sed '/pgup\|lft\|rght\|up/d' | sed 's/<ralt> " u/ü/' | sed 's/<ralt> " o/ö/' | sed 's/<ralt> " a/ä/' | sed 's/<sft> \([a-z]\)/\U\1/g' | sed 's/<sft> \(.\)/⇧\1/g' | rg '<bks>'
alias typos='rg -N \'Emit.*Press\' ~/kmonad.log | sed \'s/Emitting: Press //\' | tr \'\\n\' \' \' | sed \'s/<\\(.\\)>/\\1/g\' | sed "s/<sft> \'/\\"/g" | sed \'s/<spc>/\\n/g\' | sed \'/pgup\\|lft\\|rght\\|up/d\' | sed \'s/<ralt> " u/ü/g\' | sed \'s/<ralt> " o/ö/g\' | sed \'s/<ralt> " a/ä/g\' | sed \'s/<ralt> s s/ß/g\' | sed \'s/<sft> \\([a-z]\\)/\\U\\1/g\' | sed \'s/<sft> \\(.\\)/⇧\\1/g\' | rg \'<bks>\''
alias words='rg -N \'Emit.*Press\' ~/kmonad.log | sed \'s/Emitting: Press //\' | tr \'\\n\' \' \' | sed \'s/<\\(.\\)>/\\1/g\' | sed "s/<sft> \'/\\"/g" | sed \'s/<spc>/\\n/g\' | sed \'/pgup\\|lft\\|rght\\|up/d\' | sed \'s/<ralt> " u/ü/g\' | sed \'s/<ralt> " o/ö/g\' | sed \'s/<ralt> " a/ä/g\' | sed \'s/<ralt> s s/ß/g\' | sed \'s/<sft> \\([a-z]\\)/\\U\\1/g\' | sed \'s/<sft> \\(.\\)/⇧\\1/g\''

abbr acs 'apt-cache search'
abbr sai 'sudo apt install'
abbr sau 'sudo apt update'
abbr alu 'apt list --upgradable'
abbr ali 'apt list --installed'
abbr ap 'apt policy'

abbr sps 'sudo pacman -S'
abbr spss 'sudo pacman -Ss'
abbr syu 'sudo pacman -Syu'

abbr nh 'sudo nethogs wlp2s0 -v 3'
abbr hg 'history | grep'

alias notes='search_in_notes.sh'

abbr pl 'patool list'
abbr pe 'patool extract'
abbr px 'patool extract'
abbr pc 'patool create'
abbr pd 'patool diff'

set VIM 'nvim'
abbr v "$VIM"
abbr vim "$VIM"
abbr vimdiff "$VIM -d"
alias vv=$VIM' -c "normal '\''0"'
abbr n 'nvim'
# vr = open vim with last ripgrep search
alias vr='~/bin/vimrg.fish'
# start vim and open vim-fugitive's git status
# (and close the empty buffer and jump to the first unstaged file)
alias vg=$VIM' +G +"silent %bd|e#" +"norm gU"'

abbr rr 'ranger'
alias feh='feh --scale-down --auto-zoom --auto-rotate'

# bat: default: line numbers, no pager
# no decorations, no pager
alias batp='bat -pp'
# bat with pager
alias batl='bat --pager="less"'
# bat with pager, scroll to end
alias bate='bat --pager="less +G"'
# bat with pager, header, line numbers
# alias batc='bat --paging=always --pager="less -R"'

abbr cv "$VIM ~/.vimrc"
abbr cn "$VIM ~/.config/nvim/init.vim"
abbr cf "$VIM ~/.config/fish/config.fish"
abbr ca "$VIM ~/.config/fish/aliases.fish"
abbr cl "$VIM ~/.config/fish/local.fish"
abbr cs "$VIM ~/.config/sxhkd/sxhkdrc"
abbr ct "$VIM ~/.tmux.conf"
abbr ck "$VIM ~/.config/kmonad/vou-linux-de-rctrl.kbd"
abbr td "$VIM ~/dev/gta_local/max/todo/todo.md"

abbr caei 'pkill kmonad ; xhost &> /dev/null && setxkbmap de -option || sudo loadkeys de'
abbr asdf 'xhost &> /dev/null && setxkbmap de koy && xkbcomp -w 0 ~/bin/vou-tabwin.xkb $DISPLAY || sudo loadkeys ~/bin/vou.map'
alias vou='setxkbmap de koy && xkbcomp -w 0 ~/bin/vou.xkb $DISPLAY'
abbr k '~/bin/start-kmonad.fish -k all'
abbr m 'pkill kmonad ; unbuffer ./keyboard-layouts --device "/dev/input/by-id/usb-Keychron_Keychron_K6-event-kbd" | tee ~/log/keyboard-layouts-(date "+%Y-%m-%d %H.%M.%S").log'
abbr qq 'pkill try_three_times ; pkill run_forever ; pkill kmonad ; pkill keyboard-layouts'
abbr QQ 'pkill try_three_times ; pkill run_forever ; pkill kmonad ; pkill keyboard-layouts'
abbr s 'xrandr | grep -q 2560x1440 && ~/.screenlayout/peaq-usb.sh || ~/.screenlayout/laptop.sh'
# redshift: red=night mode (darker, redish), notred=day mode
abbr red 'redshift -P -O 3500 -b 0.7 || redshift -O 3500 -b 0.7'
abbr notred 'redshift -P -O 6500 || redshift -O 6500'
abbr ti 'pkill run_forever ; pkill kmonad ; setxkbmap de ; tipp10 ; ~/bin/start-kmonad.fish -k all'

alias akku='upower -i /org/freedesktop/UPower/devices/battery_BAT0 | grep -E "power|updated|state|energy|time to|perc|capa" | grep -v design'

# simulate one or two screens for debugging dwm
abbr x1 'Xephyr -br -ac -noreset -screen 800x600+400+80 :1'
abbr x2 'Xephyr +extension RANDR +xinerama -br -ac -noreset -screen 800x600+250+80 -screen 800x600+1050+80 :1'

# git
abbr g 'git status --short'
abbr G 'git status'
abbr gd 'git diff'
abbr gdd 'git -c "core.pager=delta" diff'
abbr gds 'git -c "core.pager=delta" -c "delta.features=side-by-side" diff'
abbr gdt 'git difftool'
abbr gp 'git pull'
abbr gps 'git push'
# git push upstream
abbr gpsu 'git push --set-upstream origin (git rev-parse --abbrev-ref HEAD)'
abbr gc 'git clone'
abbr gcm 'git co master'
abbr cim 'git ci -m "'
abbr gch 'git co HEAD --'
# gh = "git home" (go to the toplevel of the current repo)
abbr gh 'cd (git rev-parse --show-toplevel)'
abbr gfm 'git ls-files --modified'
abbr gfc 'git diff --name-only --diff-filter=U'
# git log
abbr gl 'git log'

set hash_date_reldate '%C(Yellow)%h   %C(reset)%ai %<(14)(%C(Green)%cr%C(reset))%x09 %C(reset)'
set author '%C(Cyan)%an: %C(reset)'
set message_refs '%s %C(Red)%d%C(reset)'
set format_short {$hash_date_reldate}{$message_refs}
set format_names {$hash_date_reldate}{$author}{$message_refs}
# git log compact
alias glc='git log --pretty="'$format_short'" --decorate'
alias glch='git --no-pager log --pretty="'$format_short'" --decorate -n 10'
# git log compact [with] names
alias glcn='git log --pretty="'$format_names'" --decorate'
alias glcnh='git --no-pager log --pretty="'$format_names'" --decorate -n 10'

alias gitlog='git log --oneline --graph --decorate'
alias gitlogs='git log --oneline --graph --decorate --stat'
alias gitloga='git log --oneline --graph --decorate --all'
abbr gitunpushed 'git log ..@{u}'
abbr gitunmerged 'git branch --no-merged master'
alias gb "git for-each-ref --sort=committerdate refs/remotes/origin/ --format='%(HEAD) %(color:red)%(objectname:short)%(color:reset) %(color:yellow)%(refname:short)%(color:reset)  %(contents:subject)  %(color:cyan)%(authorname)%(color:reset) (%(color:green)%(committerdate:relative)%(color:reset))'"
# current branch
abbr br 'git rev-parse --abbrev-ref HEAD'
# copy current branch name into clipboard
abbr cpbr 'git rev-parse --abbrev-ref HEAD | tr -d \n | xclip -sel clip'
# for git 2.22 and newer:
# abbr cpbr 'git branch --show-current | tr -d \n | xclip -sel clip'

abbr cr 'crontab -l | grep --color=never "^[^#]"'

abbr simpleprompt 'function fish_prompt; echo \n(prompt_pwd)\ ▶\ ; end'

# source work related / private stuff (not part of the dotfiles repo)
if [ -f $HOME/.config/fish/local.fish ]
  source $HOME/.config/fish/local.fish
end

