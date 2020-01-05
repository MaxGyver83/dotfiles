function fish_user_key_bindings
    # Ctrl-f completes only next word of autosuggestion
    bind \cf forward-word
    # delete bigword (p.e. whole path with Ctrl-w, as in bash)
    bind \cw backward-kill-bigword
    fzf_key_bindings
end
