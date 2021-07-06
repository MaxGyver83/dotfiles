function prepend_vim -d "Prepend 'vim ' to the beginning of the current commandline"
    set -l cmd (commandline -po)
    set -l cursor (commandline -C)
    if test -z "$cmd"
        commandline -r "vim $history[1]"
    else if test "$cmd[1]" != vim
        commandline -C 0
        commandline -i "vim "
        commandline -C (math $cursor + 4)
    else
        commandline -r (string sub --start=5 (commandline -p))
        commandline -C -- (math $cursor - 4)
    end
end
