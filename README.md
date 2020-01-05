# dotfiles

My bash, fish, vim, IdeaVim, surfingkeys config files and scripts for changing the keyboard layout. These files are organized in such a way that they can be installed with GNU Stow. Stow creates links to the dotfiles from this repo in `$HOME` (or its subfolders).

```sh
sudo apt-get install stow
```

At first, back up the original dotfiles. Then clone this repository into your home directory:

```sh
git clone git@github.com:MaxGyver83/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
stow fish
stow bash
stow vim
stow ideavim
stow surfingkeys
stow scripts
```

If this repo is located somewhere else, pass the destination directory explicitely, for example:

```sh
stow -t $HOME vim
```

## fish

This repo's config expects these programs being installed:

* [**fd**](https://github.com/sharkdp/fd)
* [**fzf**](https://github.com/junegunn/fzf)
* [**z** (for fish)](https://github.com/jethrokuan/z) via [**fisher**](https://github.com/jorgebucaran/fisher).

I have configured fish to show Git repository information in the prompt. This prompt uses some Unicode characters that will be rendered wider than one terminal character when the font is set to *Ubuntu Mono Regular* (the default in Ubuntu 18.04). So change it to *Monospace Regular, 14*, for example.

## vim

I use vim8's integrated package manager. So some plugins need to be cloned into `~/.vim/pack/plugins/start/` or `~/.vim/pack/plugins/opt/`.

```sh
mkdir -p ~/.vim/pack/plugins/start/
cd ~/.vim/pack/plugins/start/
git clone https://github.com/ap/vim-buftabline
git clone https://github.com/tpope/vim-surround
git clone https://github.com/tpope/vim-repeat
git clone https://github.com/tpope/vim-commentary
git clone https://github.com/Raimondi/delimitMate
git clone https://github.com/justinmk/vim-sneak
git clone https://github.com/ervandew/supertab
git clone https://github.com/kana/vim-textobj-user
git clone https://github.com/kana/vim-textobj-line
git clone https://github.com/sukima/vim-tiddlywiki

mkdir -p ~/.vim/pack/plugins/opt/
cd ~/.vim/pack/plugins/opt/
git clone https://github.com/ap/vim-css-color
git clone https://github.com/godlygeek/tabular
git clone https://github.com/jacquesbh/vim-showmarks
```

