FROM alpine:3.16.1

RUN apk update && apk add \
  doas \
  wget \
  curl \
  tree \
  git \
  stow \
  vim \
  fzf \
  fd \
  ripgrep \
  tmux \
  unzip \
  jq \
  fish \
  build-base \
  python3 \
  py3-pip \
  && rm -rf /var/cache/apk/*

# Set the locale
# RUN sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && locale-gen
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV LC_ALL=en_US.UTF-8

# get sd
RUN cd /tmp \
    && wget https://github.com/chmln/sd/releases/download/v0.7.6/sd-v0.7.6-x86_64-unknown-linux-gnu \
    && chmod +x sd-v0.7.6-x86_64-unknown-linux-gnu \
    && mv sd-v0.7.6-x86_64-unknown-linux-gnu /usr/bin/sd

# add user "docker"
RUN adduser --disabled-password -g "docker user" docker
RUN adduser docker wheel
RUN echo "docker:docker" | chpasswd
RUN echo "permit persist :wheel" >> /etc/doas.d/doas.conf
USER docker
WORKDIR /home/docker

# (shallow) clone my dotfiles repo
RUN git clone --depth 1 https://github.com/MaxGyver83/dotfiles.git ~/.dotfiles

# run stow (linking my dotfiles) and create other useful directories
RUN mkdir -p ~/.config ~/.vim ~/bin ~/.vim/pack/plugins/start ~/.vim/pack/plugins/opt ~/repos \
    && cd ~/.dotfiles && stow ash bash fish tmux ripgrep scripts vim

# will be used in .tmux.conf
ENV IN_DOCKER=1

ENV ENV="\$HOME/.ashrc"

CMD /usr/bin/fish
