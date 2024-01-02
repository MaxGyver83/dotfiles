#!/bin/sh
cd /tmp
wget https://github.com/janet-lang/janet/releases/download/v1.32.1/janet-v1.32.1-linux-x64.tar.gz
tar -xzvf janet-v1.32.1-linux-x64.tar.gz ./janet-v1.32.1-linux/bin/janet
mkdir -p ~/.local/bin
mv ./janet-v1.32.1-linux/bin/janet ~/.local/bin/
