# VOU layout for the Linux terminal (without X11)

Download `vou.map`:

```sh
wget https://raw.githubusercontent.com/MaxGyver83/dotfiles/master/vou.map/vou.map
```

Activate it (without system installation):

```sh
loadkeys vou.map
```

System installation:

```shell
# gzip -c vou.map > /usr/share/kbd/keymaps/i386/neo/vou.map.gz
```

Then activate it with `loadkeys vou`.
