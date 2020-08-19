function p --description 'Return running processes'
    set pids (pgrep -f $argv) && ps wup $pids
end
