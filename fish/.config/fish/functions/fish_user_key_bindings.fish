function fish_user_key_bindings
    # run fish_key_reader and press a key combo to get its representation

    # Ctrl-w: delete bigword (p.e. whole path with Ctrl-w, as in bash)
    bind \cw backward-kill-bigword

    # jump bigword with Ctrl+b/f
    bind \cb backward-bigword
    bind \cf forward-bigword

    # jump bigword with Shift+LeftArrow/RightArrow
    # (fish default, does work in gnome-terminal and st but not in alacritty)
    bind \e\[1\;2D backward-bigword
    bind \e\[1\;2C forward-bigword

    bind \cq delete-or-exit
    # bind \cp __fish_paginate
    # bind \cs __fish_prepend_sudo
    # bind \ch history-token-search-backward

    # Ctrl-Home/End = Home/End
    bind \e\[1\;5H beginning-of-line
    bind \e\[1\;5F end-of-line

    if type -q fzf_key_bindings
        fzf_key_bindings
        # use Ctrl-g for fzf-cd-widget (like "Go to", default: Alt-c)
        bind -e \ec
        bind \cg fzf-cd-widget
        if bind -M insert > /dev/null 2>&1
            bind -e -M insert \ec
            bind -M insert \cg fzf-cd-widget
        end
    end
end
