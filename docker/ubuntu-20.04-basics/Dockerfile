FROM ubuntu:20.04

RUN apt-get update && apt-get install -y \
  wget \
  curl \
  tree \
  git \
  stow \
  vim \
  fzf \
  fd-find \
  ripgrep \
  tmux \
  build-essential \
  ipython3 \
  python3-pip \
  python3-pudb \
  gettext-base \
  man-db \
  && rm -rf /var/lib/apt/lists/*
# gettext-base and man-db for fish

# get fish
RUN cd /tmp \
    && wget https://launchpad.net/~fish-shell/+archive/ubuntu/release-3/+files/fish-common_3.3.1-1~focal_all.deb \
    && wget https://launchpad.net/~fish-shell/+archive/ubuntu/release-3/+files/fish_3.3.1-1~focal_amd64.deb \
    && dpkg -i fish-common_3.3.1-1~focal_all.deb fish_3.3.1-1~focal_amd64.deb \
    && rm fish-common_3.3.1-1~focal_all.deb fish_3.3.1-1~focal_amd64.deb

# get bat
RUN cd /tmp \
    && wget https://github.com/sharkdp/bat/releases/download/v0.18.3/bat_0.18.3_amd64.deb \
    && dpkg -i bat_0.18.3_amd64.deb \
    && rm bat_0.18.3_amd64.deb

# get sd
RUN cd /tmp \
    && wget https://github.com/chmln/sd/releases/download/v0.7.6/sd-v0.7.6-x86_64-unknown-linux-gnu \
    && chmod +x sd-v0.7.6-x86_64-unknown-linux-gnu \
    && mv sd-v0.7.6-x86_64-unknown-linux-gnu /usr/bin/sd

# (shallow) clone my dotfiles repo
RUN git clone --depth 1 https://github.com/MaxGyver83/dotfiles.git ~/.dotfiles

# run stow (linking my dotfiles)
RUN mv ~/.bashrc ~/.bashrc_bak ; mkdir ~/.config \
    && cd ~/.dotfiles && stow bash fish tmux scripts
