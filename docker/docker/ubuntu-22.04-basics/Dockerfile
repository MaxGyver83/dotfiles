FROM ubuntu:22.04

ENV TZ=Europe/Berlin \
    DEBIAN_FRONTEND=noninteractive

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
RUN ver=3.6.1-1 \
    && cd /tmp \
    && wget https://launchpad.net/~fish-shell/+archive/ubuntu/release-3/+files/fish_${ver}~jammy_amd64.deb \
    && dpkg -i fish_${ver}~jammy_amd64.deb \
    && rm fish_${ver}~jammy_amd64.deb

# get bat
RUN ver=0.23.0 \
    && cd /tmp \
    && wget https://github.com/sharkdp/bat/releases/download/v${ver}/bat_${ver}_amd64.deb \
    && dpkg -i bat_${ver}_amd64.deb \
    && rm bat_${ver}_amd64.deb

# get sd
RUN ver=v0.7.6 \
    && cd /tmp \
    && wget https://github.com/chmln/sd/releases/download/${ver}/sd-${ver}-x86_64-unknown-linux-gnu \
    && chmod +x sd-${ver}-x86_64-unknown-linux-gnu \
    && mv sd-${ver}-x86_64-unknown-linux-gnu /usr/bin/sd

# add user "docker"
RUN useradd -m docker && echo "docker:docker" | chpasswd && adduser docker sudo
USER docker
WORKDIR /home/docker

RUN echo
# (shallow) clone my dotfiles repo
RUN git clone --depth 1 https://github.com/MaxGyver83/dotfiles.git ~/.dotfiles
# run stow (linking my dotfiles) and create other useful directories
RUN ~/.dotfiles/install

# will be used in .tmux.conf
ENV IN_DOCKER=1

CMD /usr/bin/fish
