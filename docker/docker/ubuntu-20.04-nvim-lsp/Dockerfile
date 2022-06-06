FROM ubuntu-basics:latest

# install Node.js 18
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash -

# set DEBIAN_FRONTEND because otherwise tzdata asks for geographic region and timezone
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
  nodejs \
  clangd \
  shellcheck \
  && rm -rf /var/lib/apt/lists/*

# install Neovim package and config
RUN cd ~/.dotfiles && stow nvim
RUN cd /tmp \
  && wget https://github.com/neovim/neovim/releases/download/v0.7.0/nvim-linux64.deb \
  && dpkg -i nvim-linux64.deb \
  && rm nvim-linux64.deb

RUN npm install -g pyright

RUN pip install pycodestyle pylint black isort yamllint

RUN mkdir -p ~/.local/share/nvim/site/pack/plugins/start \
  && cd ~/.local/share/nvim/site/pack/plugins/start \
  && git clone https://github.com/neovim/nvim-lspconfig.git \
  && git clone https://github.com/hrsh7th/cmp-nvim-lsp.git \
  && git clone https://github.com/hrsh7th/nvim-cmp.git \
  && git clone https://github.com/jose-elias-alvarez/null-ls.nvim \
  && git clone https://github.com/nvim-lua/plenary.nvim

ADD lsp.lua /root/.config/nvim/lua/lsp.lua
RUN echo "lua require('lsp')" >> /root/.config/nvim/init.vim

# Inside fish+tmux:
# set TERM tmux-256color
