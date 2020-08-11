function fish_user_key_bindings
    # Ctrl-w: delete bigword (p.e. whole path with Ctrl-w, as in bash)
    bind \cw backward-kill-bigword
    # Ctrl-f completes only next word of autosuggestion
    #bind \cf forward-word
    # jump bigword with Ctrl+b/f
    bind \cb backward-bigword
    bind \cf forward-bigword
    # jump bigword with Shift+LeftArrow/RightArrow
    #bind '[1;2D' backward-bigword
    #bind '[1;2C' forward-bigword
    bind \cp __fish_paginate
    bind \cs __fish_prepend_sudo
    bind \ch history-token-search-backward

    if type -q fzf_key_bindings
        fzf_key_bindings
    end
end
