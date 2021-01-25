#!/usr/bin/env fish

# When used with vim -> E994. Workaround: call timer_start ...
# But then selection of a match with "Enter" does not work.
# Save command in command history: needs autocommand in .vimrc. Does not work in nvim.
set last_command (string split --max 1 ' ' $history[2])
set cmd $last_command[1]
if [ $cmd = 'rg' ]
    set args_stripped_quotes (string replace -a "'" "" $last_command[2])
    nvim -c "RgRaw $args_stripped_quotes"
    # vim -c "call timer_start(0, {-> execute('RgRaw $args_stripped_quotes')})"
else
    nvim -c Rg
    # vim -c "call timer_start(0, {-> execute('Rg')})"
end
