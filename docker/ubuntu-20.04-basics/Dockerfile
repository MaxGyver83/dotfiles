FROM ubuntu:20.04

RUN apt-get update && apt-get install -y \
  wget \
  curl \
  tree \
  git \
  stow \
  vim \
  fish \
  fzf \
  fd-find \
  ripgrep \
  build-essential \
  ipython3 \
  python3-pip \
  python3-pudb \
  && rm -rf /var/lib/apt/lists/*

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

