function e --description 'Copy n-th line to last into command line and prepend "vim "'
    if not count $argv > /dev/null
        set argv 1
    end
    tmux capture-pane -p | awk /./ | sed /▶/d | sed /\(ansi/d | sed /\(pytest/d | tail -$argv | head -1 | tr "\n" " " | string trim | tmux load-buffer - && tmux send "vim " && tmux paste-buffer -s " "
end
