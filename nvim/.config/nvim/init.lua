local vim = vim
local Plug = vim.fn['plug#']

vim.cmd('set runtimepath^=~/.vim runtimepath+=~/.vim/after')
vim.cmd('let &packpath = &runtimepath')
vim.cmd('source ~/.vimrc')

vim.call('plug#begin', '~/.local/share/nvim/plugged')
-- Plug('nvim-treesitter/nvim-treesitter', {['do'] = function() vim.fn[':TSUpdate']() end})
Plug('nvim-treesitter/nvim-treesitter', {['do'] = ':TSUpdate'})
Plug('neovim/nvim-lspconfig')
Plug('ibhagwan/fzf-lua')
Plug('dhananjaylatkar/cscope_maps.nvim')
Plug('lukas-reineke/headlines.nvim')
-- next four plugins belong to flutter-tools.nvim
Plug('nvim-lua/plenary.nvim')
Plug('stevearc/dressing.nvim') -- optional for vim.ui.select
Plug('akinsho/flutter-tools.nvim')
Plug('mfussenegger/nvim-dap')
-- Plug('theHamsta/nvim-dap-virtual-text')
vim.call('plug#end')

require("cscope_maps").setup({
  skip_input_prompt = true,
  cscope = {
    picker = "fzf-lua",
    skip_picker_for_single_result = true
  }
})
-- Default keymaps (jump to README with gF)
-- ~/.local/share/nvim/plugged/cscope_maps.nvim/README.md +93
-- let g:gutentags_modules = ['ctags', 'cscope_maps']

vim.cmd('highlight CodeBlockHeadlinesPlugin ctermbg=236')
require("headlines").setup({
  markdown = {
    headline_highlights = false,
    codeblock_highlight = "CodeBlockHeadlinesPlugin",
  }
})

require("flutter-tools").setup {} -- use defaults

local dap = require("dap")
dap.configurations.dart = {
  {
    type = "dart",
    request = "launch",
    name = "Launch dart",
    dartSdkPath = "/opt/flutter/bin/cache/dart-sdk/bin/dart", -- ensure this is correct
    flutterSdkPath = "/opt/flutter/bin/flutter",              -- ensure this is correct
    program = "${workspaceFolder}/lib/main.dart",             -- ensure this is correct
    cwd = "${workspaceFolder}",
  },
  {
    type = "flutter",
    request = "launch",
    name = "Launch flutter",
    dartSdkPath = "/opt/flutter/bin/cache/dart-sdk/bin/dart", -- ensure this is correct
    flutterSdkPath = "/opt/flutter/bin/flutter",              -- ensure this is correct
    program = "${workspaceFolder}/lib/main.dart",             -- ensure this is correct
    cwd = "${workspaceFolder}",
  }
}
-- Dart CLI adapter (recommended)
dap.adapters.dart = {
  type = 'executable',
  command = 'dart',    -- if you're using fvm, you'll need to provide the full path to dart (dart.exe for windows users), or you could prepend the fvm command
  args = { 'debug_adapter' },
  -- windows users will need to set 'detached' to false
  options = { 
    detached = true,
  }
}
dap.adapters.flutter = {
  type = 'executable',
  command = 'flutter',   -- if you're using fvm, you'll need to provide the full path to flutter (flutter.bat for windows users), or you could prepend the fvm command
  args = { 'debug_adapter' },
  -- windows users will need to set 'detached' to false
  options = { 
    detached = true,
  }
}

-- using ':lua dap.step_out' instead of simply dap.stepout because the latter is hidden in :Maps/:map
vim.keymap.set('', '<leader>ld', ':lua vim.lsp.buf.definition()<cr>')
vim.keymap.set('', '<leader>lr', ':lua vim.lsp.buf.references()<cr>')
vim.keymap.set('', '<leader>li', ':lua vim.lsp.buf.implementation()<cr>')
vim.keymap.set('', '<leader>lc', ':lua vim.lsp.buf.code_action()<cr>')
vim.keymap.set('', '<leader>lR', ':lua vim.lsp.buf.rename()<cr>')
vim.keymap.set('n', '<F5>',  ':lua require("dap").continue()<cr>')
vim.keymap.set('n', '<F9>',  ':lua require("dap").toggle_breakpoint()<cr>')
vim.keymap.set('n', '<F10>', ':lua require("dap").step_over()<cr>')
vim.keymap.set('n', '<F11>', ':lua require("dap").step_into()<cr>')
vim.keymap.set('n', '<F12>', ':lua require("dap").step_out()<cr>')

-- require("nvim-dap-virtual-text").setup()

vim.diagnostic.config({ float = { border = 'rounded' } })

vim.cmd('highlight Whitespace ctermfg=236 ctermbg=NONE cterm=NONE guifg=#555555 guibg=NONE gui=NONE')
