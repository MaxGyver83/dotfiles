function vssh --description 'Copy ~/.vimrc to /tmp/.vimrc of host before ssh'
    scp ~/.vimrc $argv:/tmp/.vimrc
    ssh $argv
end
