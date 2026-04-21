remove_from_path() {
    new_path=""
    old_ifs=$IFS
    IFS=:

    for dir in $PATH; do
        if [ "$dir" != "$1" ]; then
            if [ -z "$new_path" ]; then
                new_path=$dir
            else
                new_path=$new_path:$dir
            fi
        fi
    done

    IFS=$old_ifs
    PATH=$new_path
}

remove_from_path_if_symlink() {
    if [ -L "$1" ] &&
       [ "$(realpath "$1")" = "/usr/bin" ] &&
       { case ":$PATH:" in
            *:"$1":*) true ;;
            *) false ;;
         esac; } &&
       { case ":$PATH:" in
            *:/usr/bin:*) true ;;
            *) false ;;
         esac; }
    then
        remove_from_path "$1"
    fi
}

prepend_to_path() {
    [ -d "$1" ] && remove_from_path "$1" && PATH="$1:$PATH"
}

append_to_path() {
    [ -d "$1" ] && remove_from_path "$1" && PATH="$PATH:$1"
}

remove_from_path_if_symlink /sbin
remove_from_path_if_symlink /bin
remove_from_path_if_symlink /usr/sbin

prepend_to_path $HOME/Android/Sdk/platform-tools # adb
prepend_to_path $HOME/Android/Sdk/tools/bin
prepend_to_path $HOME/.local/share/gem/ruby/3.4.0/bin
prepend_to_path $HOME/.cargo/bin
prepend_to_path $HOME/go/bin
prepend_to_path $HOME/.local/bin
prepend_to_path $HOME/bin
prepend_to_path $HOME/install

# if [ -e /opt/android-studio/jbr/bin ]; then
#     export JAVA_HOME=/opt/android-studio/jbr
#     prepend_to_path $JAVA_HOME/bin
# fi
append_to_path /opt/android-studio/jbr/bin

exists() {
    command -v "$1" > /dev/null 2>&1 ;
}
exists luarocks && eval $(luarocks path)

if [ $KSH_VERSION ]; then
    case "$KSH_VERSION" in
    *MIRBSD*)   export CURRENT_SHELL=mksh ;;
    *"PD KSH"*) export CURRENT_SHELL=osh ;;
    esac
elif [ "$BASH_VERISON" ]; then
    export CURRENT_SHELL=bash
elif ps | grep '^ *'$$ | grep -q 'busybox a\?sh'; then
    export CURRENT_SHELL=ash
    export ENV=$HOME/.ashrc
# elif ps -o command $$ | grep -wq dash; then
elif ps | grep '^ *'$$ | grep -wq 'dash'; then
    export CURRENT_SHELL=dash
    export ENV=$HOME/.dashrc
fi
