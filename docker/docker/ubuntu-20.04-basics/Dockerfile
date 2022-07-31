FROM ubuntu:20.04

RUN apt-get update && apt-get install -y \
  sudo \
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
  unzip \
  jq \
  build-essential \
  ipython3 \
  python3-pip \
  python3-pudb \
  locales \
  gettext-base \
  man-db \
  libpcre2-32-0 \
  && rm -rf /var/lib/apt/lists/*
# gettext-base, man-db and libpcre2-32-0 for fish

# Set the locale
RUN sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && locale-gen
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# get fish
RUN cd /tmp \
    && wget https://launchpad.net/~fish-shell/+archive/ubuntu/release-3/+files/fish_3.5.0-1~focal_amd64.deb \
    && dpkg -i fish_3.5.0-1~focal_amd64.deb \
    && rm fish_3.5.0-1~focal_amd64.deb

# get bat
RUN cd /tmp \
    && wget https://github.com/sharkdp/bat/releases/download/v0.21.0/bat_0.21.0_amd64.deb \
    && dpkg -i bat_0.21.0_amd64.deb \
    && rm bat_0.21.0_amd64.deb

# get sd
RUN cd /tmp \
    && wget https://github.com/chmln/sd/releases/download/v0.7.6/sd-v0.7.6-x86_64-unknown-linux-gnu \
    && chmod +x sd-v0.7.6-x86_64-unknown-linux-gnu \
    && mv sd-v0.7.6-x86_64-unknown-linux-gnu /usr/bin/sd

# add user "docker"
RUN useradd -m docker && echo "docker:docker" | chpasswd && adduser docker sudo
USER docker
WORKDIR /home/docker

# (shallow) clone my dotfiles repo
RUN git clone --depth 1 https://github.com/MaxGyver83/dotfiles.git ~/.dotfiles

# run stow (linking my dotfiles) and create other useful directories
RUN mv ~/.bashrc ~/.bashrc_bak ; mkdir -p ~/.config ~/.vim ~/bin ~/.vim/pack/plugins/start ~/.vim/pack/plugins/opt ~/repos \
    && cd ~/.dotfiles && stow bash fish tmux ripgrep scripts vim

# will be used in .tmux.conf
ENV IN_DOCKER=1

CMD /usr/bin/fish
