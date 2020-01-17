# How to write/load kou.xkb

When KOU is active, write layout into xkb file:

```
xkbcomp $DISPLAY kou.xkb
```

Activate layout with:

```
xkbcomp kou.xkb $DISPLAY
```

Source: https://wiki.archlinux.org/index.php/X_keyboard_extension


# Use KOU layout on other PCs

Download `kou.xkb` and `kou-activate.bash` (or clone this repository). Run `kou-activate.bash`. This activates KOU and sets an alias for the current session and also appends it to `~/.bash_aliases`. The alias is `haei` (the keys labeled `asdf`) for (re)setting the keyboard layout to `de` (=QWERTZ).
