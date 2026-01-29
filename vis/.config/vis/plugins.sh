#!/bin/sh
mkdir -p ~/.config/vis/plugins
cd ~/.config/vis/plugins

for plugin in \
    https://github.com/lutobler/vis-commentary.git \
    https://gitlab.com/mcepl/vis-jump.git \
    https://repo.or.cz/vis-surround.git \
    https://repo.or.cz/vis-goto-file.git \
    https://repo.or.cz/vis-exchange.git \
    https://github.com/erf/vis-plug.git
do
    git clone $plugin
done
