set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
source ~/.vimrc

call plug#begin('~/.local/share/nvim/plugged')
    Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
    Plug 'ibhagwan/fzf-lua'
    Plug 'dhananjaylatkar/cscope_maps.nvim'
    Plug 'lukas-reineke/headlines.nvim'
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

highlight Whitespace ctermfg=236 ctermbg=NONE cterm=NONE guifg=#555555 guibg=NONE gui=NONE
