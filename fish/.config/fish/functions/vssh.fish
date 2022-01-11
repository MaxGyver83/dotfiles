function vssh --description 'Copy ~/.vimrc and ~/.tmux.conf to /tmp/ of host before ssh'
    scp ~/.vimrc ~/.tmux.conf $argv:/tmp/
    ssh $argv
end
