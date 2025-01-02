FROM ubuntu:24.04

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
  bat \
  sd \
  tmux \
  unzip \
  jq \
  build-essential \
  ipython3 \
  python3-pip \
  python3-pudb \
  locales \
  && rm -rf /var/lib/apt/lists/* \
  && ln -s /usr/bin/batcat /usr/local/bin/bat

# Set the locale
RUN sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && locale-gen
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV LC_ALL=en_US.UTF-8

# add user "docker"
RUN useradd -m docker && echo "docker:docker" | chpasswd && adduser docker sudo
USER docker
WORKDIR /home/docker

# (shallow) clone my dotfiles repo
RUN git clone --depth 1 https://github.com/MaxGyver83/dotfiles.git ~/.dotfiles

# run stow (linking my dotfiles) and create other useful directories
RUN ~/.dotfiles/install

# will be used in .tmux.conf
ENV IN_DOCKER=1

CMD ["/usr/bin/bash"]
