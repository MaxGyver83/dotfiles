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
abbr wlan 'nmcli d wifi'

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
# rv = open vim with last ripgrep search
alias rv='~/bin/vimrg.fish'


# not escaped: rg -N 'Emit.*Press' ~/kmonad.log | sed 's/Emitting: Press //' | tr '\n' ' ' | sed 's/<\(.\)>/\1/g' | sed "s/<sft> '/\"/g" | sed 's/<spc>/\n/g' | sed '/pgup\|lft\|rght\|up/d' | sed 's/<ralt> " u/ü/' | sed 's/<ralt> " o/ö/' | sed 's/<ralt> " a/ä/' | sed 's/<sft> \([a-z]\)/\U\1/g' | sed 's/<sft> \(.\)/⇧\1/g' | rg '<bks>'
alias typos='rg -N \'Emit.*Press\' ~/kmonad.log | sed \'s/Emitting: Press //\' | tr \'\\n\' \' \' | sed \'s/<\\(.\\)>/\\1/g\' | sed "s/<sft> \'/\\"/g" | sed \'s/<spc>/\\n/g\' | sed \'/pgup\\|lft\\|rght\\|up/d\' | sed \'s/<ralt> " u/ü/g\' | sed \'s/<ralt> " o/ö/g\' | sed \'s/<ralt> " a/ä/g\' | sed \'s/<ralt> s s/ß/g\' | sed \'s/<sft> \\([a-z]\\)/\\U\\1/g\' | sed \'s/<sft> \\(.\\)/⇧\\1/g\' | rg \'<bks>\''
alias words='rg -N \'Emit.*Press\' ~/kmonad.log | sed \'s/Emitting: Press //\' | tr \'\\n\' \' \' | sed \'s/<\\(.\\)>/\\1/g\' | sed "s/<sft> \'/\\"/g" | sed \'s/<spc>/\\n/g\' | sed \'/pgup\\|lft\\|rght\\|up/d\' | sed \'s/<ralt> " u/ü/g\' | sed \'s/<ralt> " o/ö/g\' | sed \'s/<ralt> " a/ä/g\' | sed \'s/<ralt> s s/ß/g\' | sed \'s/<sft> \\([a-z]\\)/\\U\\1/g\' | sed \'s/<sft> \\(.\\)/⇧\\1/g\''

abbr acs 'apt-cache search'
abbr sai 'sudo apt install'
abbr sau 'sudo apt update'
abbr alu 'apt list --upgradable'
abbr ali 'apt list --installed'
abbr ap 'apt policy'
abbr nh 'sudo nethogs wlp2s0 -v 3'
abbr hg 'history | grep'

alias notes='search_in_notes.sh'

abbr v 'vim'
alias vv='vim -c "normal '\''0"'
abbr n 'nvim'
abbr rr 'ranger'
alias feh='feh --scale-down --auto-zoom --auto-rotate'

# bat: default: line numbers, no pager
alias batp='bat -pp'
alias batl='bat --pager="less"'

abbr cv 'vim ~/.vimrc'
abbr cf 'vim ~/.config/fish/config.fish'
abbr ca 'vim ~/.config/fish/aliases.fish'
abbr cs 'vim ~/.config/sxhkd/sxhkdrc'
abbr ck 'vim ~/.config/kmonad/vou-linux.kbd'
abbr td 'vim ~/dev/gta_local/max/todo/todo.md'

abbr caei 'pkill kmonad ; xhost &> /dev/null && setxkbmap de -option || sudo loadkeys de'
abbr asdf 'xhost &> /dev/null && setxkbmap de koy && xkbcomp -w 0 ~/bin/vou-tabwin.xkb $DISPLAY || sudo loadkeys ~/bin/vou.map'
alias vou='setxkbmap de koy && xkbcomp -w 0 ~/bin/vou.xkb $DISPLAY'
abbr kkk '~/bin/start-kmonad-for-all-keyboards.fish'
abbr kk '~/bin/start-kmonad-for-all-keyboards.fish de'
# abbr kkk '~/bin/start-kmonad-for-all-keyboards-dev.fish de'
abbr k '~/bin/start-kmonad-for-all-keyboards.fish de2'
abbr kkkk '~/bin/start-kmonad-for-all-keyboards-slot.fish de'
abbr qq 'pkill try_three_times ; pkill run_forever ; pkill kmonad'
abbr QQ 'pkill try_three_times ; pkill run_forever ; pkill kmonad'
abbr s 'xrandr | grep -q 2560x1440 && ~/.screenlayout/peaq-usb.sh || ~/.screenlayout/laptop.sh'
# redshift: red=night mode (darker, redish), notred=day mode
abbr red 'redshift -P -O 3500 -b 0.7 || redshift -O 3500 -b 0.7'
abbr notred 'redshift -P -O 6500 || redshift -O 6500'
abbr ti 'pkill run_forever ; pkill kmonad ; setxkbmap de ; tipp10'

alias akku='upower -i /org/freedesktop/UPower/devices/battery_BAT0 | grep -E "power|updated|state|energy|time to|perc|capa" | grep -v design'

# simulate one or two screens for debugging dwm
abbr x1 'Xephyr -br -ac -noreset -screen 800x600+400+80 :1'
abbr x2 'Xephyr +extension RANDR +xinerama -br -ac -noreset -screen 800x600+250+80 -screen 800x600+1050+80 :1'

# git
abbr g 'git status'
abbr gd 'git diff'
abbr gdd 'git -c "core.pager=delta" diff'
abbr gds 'git -c "core.pager=delta" -c "delta.features=side-by-side" diff'
abbr gdt 'git difftool'
abbr gp 'git pull'
# gh = "git home" (go to the toplevel of the current repo)
abbr gcm 'git co master'
abbr cim 'git ci -m "'
abbr gh 'cd (git rev-parse --show-toplevel)'
abbr gfm 'git ls-files --modified'
# git log
abbr gl 'git log'
# git log compact
# alias glc='git log --pretty="%C(Yellow)%h  %C(reset)%ai (%C(Green)%cr%C(reset))%x09 %C(reset)%s"'
alias glc='git log --pretty="%C(Yellow)%h   %C(reset)%ai (%C(Green)%cr%C(reset))%x09 %C(reset)%s %C(Red)%d%C(reset)" --decorate=full'
# git log compact [with] names
alias glcn='git log --pretty="%C(Yellow)%h  %C(reset)%ai (%C(Green)%cr%C(reset))%x09 %C(Cyan)%an: %C(reset)%s"'
alias gitlog='git log --oneline --graph --decorate'
alias gitlogs='git log --oneline --graph --decorate --stat'
alias gitloga='git log --oneline --graph --decorate --all'
abbr gitunpushed 'git log ..@{u}'
abbr gitunmerged 'git branch --no-merged master'
alias gb "git for-each-ref --sort=committerdate refs/remotes/origin/ --format='%(HEAD) %(color:red)%(objectname:short)%(color:reset) %(color:yellow)%(refname:short)%(color:reset)  %(contents:subject)  %(color:cyan)%(authorname)%(color:reset) (%(color:green)%(committerdate:relative)%(color:reset))'"
# copy current branch name into clipboard
abbr br 'git rev-parse --abbrev-ref HEAD | tr -d \n | xclip -sel clip'
# for git 2.22 and newer:
# abbr br 'git branch --show-current | tr -d \n | xclip -sel clip'

abbr cr 'crontab -l | grep --color=never "^[^#]"'

# source work related / private stuff (not part of the dotfiles repo)
if [ -f $HOME/.config/fish/local.fish ]
  source $HOME/.config/fish/local.fish
end

