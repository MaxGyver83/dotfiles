status is-interactive || exit 0

# add ~/install (AppImages) to PATH
fish_add_path -p ~/install
fish_add_path -a ~/.local/bin
fish_add_path -a ~/bin

# delete /bin and /sbin from PATH when they are just symlinks
if [ -L /bin ] && contains /usr/bin $PATH && set -l ind (contains -i -- /bin $PATH)
    set -e PATH[$ind]
end
if [ -L /sbin ] && contains /usr/sbin $PATH && set -l ind (contains -i -- /sbin $PATH)
    set -e PATH[$ind]
end

if type -q luarocks
    set -x LUA_PATH "$(luarocks path --lr-path)"
    set -x LUA_CPATH "$(luarocks path --lr-cpath)"
end

# load aliases
if [ -f $HOME/.config/fish/aliases.fish ]
  source $HOME/.config/fish/aliases.fish
end

# no greeting
set -U fish_greeting ""

# don't shorten path in prompt
set -U fish_prompt_pwd_dir_length 0

# bright blue working directory in prompt
set fish_color_cwd brblue

# green for commands
set fish_color_command 00b315

# brighter red for errors
set fish_color_error ff6644

# brighter autosuggestions (default: brblack)
set fish_color_autosuggestion 888888

set -g __fish_git_prompt_color_branch
set -g __fish_git_prompt_showcolorhints true

# default settings for less
set -x LESS '-iMFXRj4a#4'

# colored man pages
set -x LESS_TERMCAP_mb (printf "\033[1;31m")     # begin bold
set -x LESS_TERMCAP_md (printf "\033[1;36m")     # begin blink
set -x LESS_TERMCAP_me (printf "\033[0m")        # reset bold/blink
set -x LESS_TERMCAP_so (printf "\033[0;43;30m")  # begin reverse video
set -x LESS_TERMCAP_se (printf "\033[0m")        # reset reverse video
set -x LESS_TERMCAP_us (printf "\033[1;32m")     # begin underline
set -x LESS_TERMCAP_ue (printf "\033[0m")        # reset underline
set -x GROFF_NO_SGR 1                            # for konsole and gnome-terminal

# colors for exa
set -x EXA_COLORS 'nb=38;5;7:nk=38;5;228:nm=38;5;208:ng=38;5;199:sb=38;5;7:uu=37:un=31'

set -x BAT_PAGER ''
set -x BAT_THEME TwoDark

# use vim for editing the command line with Alt-e
set -x VISUAL vim
set -x EDITOR vim

set -x BYOBU_EDITOR vim

ulimit -c 1000000

if test -f "$HOME/.config/ripgrep/ripgreprc"
    set -x RIPGREP_CONFIG_PATH "$HOME/.config/ripgrep/ripgreprc"
end

if type -q fzf
    # also find hidden files with FZF
    #set -x FZF_DEFAULT_COMMAND "find ."
    # better: use fd instead of find
    if type -q fd
        set -x FZF_DEFAULT_COMMAND 'fd --type f --hidden --follow --exclude .git'
        # use same command for Ctrl-t
        set -x FZF_CTRL_T_COMMAND $FZF_DEFAULT_COMMAND' --search-path $dir'
        # use similar command for Alt-C
        set -x FZF_ALT_C_COMMAND "fd --type d --hidden --follow --exclude .git"
    end
    set -x FZF_DEFAULT_OPTS "--exact"
    if type -q bat
        set -x FZF_CTRL_T_OPTS "--preview 'bat --style=numbers --line-range :60 --color=always {}'"
    end
    # set color scheme
    set -x FZF_DEFAULT_OPTS "--color fg:-1,bg:-1,hl:#fa9a2d,fg+:3,hl+:#fa9a2d,info:150,prompt:110,spinner:150,pointer:167,marker:174 $FZF_DEFAULT_OPTS"
end

# fix delete key in st terminal
if status is-interactive
    switch $TERM

        # Fix DEL key in st
        case 'st*'
            set -gx is_simple_terminal 1

        case "linux"
            set -e is_simple_terminal
            # function fish_prompt
            #     # fish_fallback_prompt
            #     echo '>'
            # end
    end

    if set -q is_simple_terminal
        tput smkx 2>/dev/null
        function fish_enable_keypad_transmit --on-event fish_postexec
            # see https://www.reddit.com/r/suckless/comments/svssz0/my_st_returns_tput_unknown_terminfo_capability/
            # tput smkx 2>/dev/null
            tput smkx
        end

        function fish_disable_keypad_transmit --on-event fish_preexec
            #tput rmkx 2>/dev/null
            tput rmkx
        end
    end
end
