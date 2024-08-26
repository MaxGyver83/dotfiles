set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
source ~/.vimrc

call plug#begin('~/.local/share/nvim/plugged')
    Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
    Plug 'neovim/nvim-lspconfig'
    Plug 'ibhagwan/fzf-lua'
    Plug 'dhananjaylatkar/cscope_maps.nvim'
    Plug 'lukas-reineke/headlines.nvim'
    " next four plugins belong to flutter-tools.nvim
    Plug 'nvim-lua/plenary.nvim'
    Plug 'stevearc/dressing.nvim' " optional for vim.ui.select
    Plug 'akinsho/flutter-tools.nvim'
    Plug 'mfussenegger/nvim-dap'
    " Plug 'theHamsta/nvim-dap-virtual-text'
call plug#end()

lua require("cscope_maps").setup({
            \ skip_input_prompt = true,
            \ cscope = {
            \   picker = "fzf-lua",
            \   skip_picker_for_single_result = true }})
" Default keymaps (jump to README with gF)
" ~/.local/share/nvim/plugged/cscope_maps.nvim/README.md +93
" let g:gutentags_modules = ['ctags', 'cscope_maps']

highlight CodeBlockHeadlinesPlugin ctermbg=236
lua require("headlines").setup({
            \ markdown = {
            \     headline_highlights = false,
            \     codeblock_highlight = "CodeBlockHeadlinesPlugin",
            \ }})

lua << EOF
  require("flutter-tools").setup {} -- use defaults
EOF

lua << EOF
local dap = require("dap")
dap.configurations.dart = {
  {
    type = "dart",
    request = "launch",
    name = "Launch dart",
    dartSdkPath = "/opt/flutter/bin/cache/dart-sdk/bin/dart", -- ensure this is correct
    flutterSdkPath = "/opt/flutter/bin/flutter",                  -- ensure this is correct
    program = "${workspaceFolder}/lib/main.dart",     -- ensure this is correct
    cwd = "${workspaceFolder}",
  },
  {
    type = "flutter",
    request = "launch",
    name = "Launch flutter",
    dartSdkPath = "/opt/flutter/bin/cache/dart-sdk/bin/dart", -- ensure this is correct
    flutterSdkPath = "/opt/flutter/bin/flutter",             -- ensure this is correct
    program = "${workspaceFolder}/lib/main.dart",     -- ensure this is correct
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
EOF

noremap <leader>ld  <cmd>lua vim.lsp.buf.definition()<CR>
noremap <leader>lr  <cmd>lua vim.lsp.buf.references()<CR>
noremap <leader>li  <cmd>lua vim.lsp.buf.implementation()<CR>
noremap <leader>lc  <cmd>lua vim.lsp.buf.code_action()<CR>
noremap <leader>lR  <cmd>lua vim.lsp.buf.rename()<CR>
nnoremap <silent><F5> :lua require'dap'.continue()<CR>
nnoremap <silent><F9> :lua require'dap'.toggle_breakpoint()<CR>
nnoremap <silent><F10> :lua require'dap'.step_over()<CR>
nnoremap <silent><F11> :lua require'dap'.step_into()<CR>
nnoremap <silent><F12> :lua require'dap'.step_out()<CR>

" lua <<EOF
" require("nvim-dap-virtual-text").setup()
" EOF

lua vim.diagnostic.config({ float = { border = 'rounded' } })

highlight Whitespace ctermfg=236 ctermbg=NONE cterm=NONE guifg=#555555 guibg=NONE gui=NONE
