function fish_prompt --description 'Prompt ausgeben'
    set -l last_status $status

    if not set -q __fish_prompt_normal
        set -g __fish_prompt_normal (set_color normal)
    end

    set -l color_cwd
    set -l prefix
    set -l suffix
    switch "$USER"
        case root toor
            if set -q fish_color_cwd_root
                set color_cwd $fish_color_cwd_root
            else
                set color_cwd $fish_color_cwd
            end
            set suffix '#'
        case '*'
            set color_cwd $fish_color_cwd
            set suffix '▶'
    end

    # set_color brblack
    # echo -n \n(date '+%H:%M:%S ')
    # set_color normal
    # PWD
    set_color $color_cwd
    if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ] || [ -f /.dockerenv ]
        echo -n \n(uname -n):(prompt_pwd)
    else
        echo -n \n(prompt_pwd)
    end
    set_color normal

    # printf '%s ' (__fish_vcs_prompt)
    if string match -q 's*' $USER
        printf '%s ' (timeout 0.5 fish -i -c vcs_prompt)
    else
        printf '%s ' (vcs_prompt)
    end

    if not test $last_status -eq 0
        set_color $fish_color_error
        echo -n "[$last_status] "
        set_color normal
    end

    echo -n "$suffix "
end

# function fish_right_prompt
#     set_color brblack
#     echo -n (date +%H:%M:%S)
#     set_color normal
# end
