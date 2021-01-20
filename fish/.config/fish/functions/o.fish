function o --description 'Copy n-th line to last into command line'
    if not count $argv > /dev/null
        set argv 1
    end
    tmux capture-pane -p | awk /./ | sed /▶/d | sed /\(ansi/d| tail -$argv | head -1 | tr "\n" " " | string trim | tmux load-buffer - && tmux paste-buffer -s " "
end
