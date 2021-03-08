#!/usr/bin/fish
set counter 0
while true
    set counter (math $counter + 1)
    $argv[1] $argv[2] 2>> ~/.kmonad.loop.log
    set message (date -Iseconds)": Restarting KMonad ($counter)"
    echo -e \n$message >> ~/.kmonad.loop.log
    notify-send -u low --hint int:transient:1 $message
    if [ $counter -gt 10 ]
      sleep 5s
    else
      sleep 1s
    end
end
