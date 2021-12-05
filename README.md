# dotfiles

My vim, bash, fish, tmux, sxhkd, surfingkeys, Docker, KMonad config files and scripts for changing the keyboard layout. These files are organized in such a way that they can be installed with GNU Stow. Stow creates links to the dotfiles from this repo in `$HOME` (or its subfolders).

```sh
sudo apt-get install stow
```

At first, back up the original dotfiles. Then clone this repository into your home directory:

```sh
mkdir -p ~/.config/fish ~/.vim ~/bin
git clone git@github.com:MaxGyver83/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
stow -v fish bash tmux vim sxhkd surfingkeys kmonad editorconfig scripts
```

If this repo is located somewhere else, pass the destination directory explicitly, for example:

```sh
stow -t $HOME vim
```

## fish

I have configured fish to show Git repository information in the prompt. This prompt uses some Unicode characters that will be rendered wider than one terminal character when the font is set to *Ubuntu Mono Regular* (the default in Ubuntu 18.04). So change it to *Monospace Regular, 14*, for example (in your terminal application).

This fish setup will work best with these programs installed:

* [**fzf**](https://github.com/junegunn/fzf)
* [**fd**](https://github.com/sharkdp/fd)
* [**bat**](https://github.com/sharkdp/bat)

(The settings regarding these programs will be skipped if they are not installed.)

Also recommended:

* [**z** (for fish)](https://github.com/jethrokuan/z) via [**fisher**](https://github.com/jorgebucaran/fisher).

## vim

I use vim8's integrated package manager. So some plugins need to be cloned into `~/.vim/pack/plugins/start/` or `~/.vim/pack/plugins/opt/`.

Install plugins with [install-vim-plugins](scripts/bin/install-vim-plugins). This script itself contains the list of plugins to be installed:

```sh
~/bin/install-vim-plugins
```

Update vim plugins with [update-vim-plugins](scripts/bin/update-vim-plugins).

## dwm

For dwm, install its dependencies and other useful tools:

```sh
sudo apt install suckless-tools sxhkd rofi dunst pcmanfm i3lock compton wmctrl pavucontrol pasystray scrot copyq
```

`suckless-tools` includes `dmenu`. This can also be cloned and built from source.

Then clone dwm:

```sh
cd ~/repos
git clone https://github.com/MaxGyver83/dwm.git
```

Install configs:

```sh
stow -vv scripts sxhkd dunst st dwm
```

Build dwm:

```sh
cd ~/repos/dwm/
sudo make clean install
```

## bspwm (outdated)

Install dependencies (probably this list is not complete):

```sh
sudo apt install libxcb-xinerama0-dev libxcb-icccm4-dev libxcb-ewmh-dev
```

Clone these repos:

```sh
cd ~/repos
git clone https://github.com/baskerville/bspwm.git
git clone https://github.com/baskerville/xdo.git
git clone https://github.com/baskerville/xtitle.git
git clone https://github.com/LemonBoy/bar.git
git clone https://github.com/sargon/trayer-srg.git
```

and install from source (`make && sudo make install`).

```sh
stow -vv scripts sxhkd dunst bspwm
```
