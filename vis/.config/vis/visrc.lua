-- load standard vis module, providing parts of the Lua API
require('vis')

local plug = require('plugins/vis-plug')
plug.path('/home/max/.config/vis')

-- configure plugins in an array of tables with git urls and options
local plugins = {
	{ 'lutobler/vis-commentary' },
	{ 'repo.or.cz/vis-exchange' },
	-- { 'repo.or.cz/vis-goto-file' }, -- broken?
	-- { 'gitlab.com/mcepl/vis-jump' }, -- disappeared
	{ 'repo.or.cz/vis-surround' },
	{ 'erf/vis-sneak' },
	{ 'git.sr.ht/~mcepl/vis-fzf-open' },
	{ 'peaceant/vis-fzf-mru.git', file = 'fzf-mru' },
	{ 'seifferth/vis-editorconfig' },
	-- { 'gitlab.com/muhq/vis-spellcheck' },
	-- { 'jocap/vis-filetype-settings' },
	{ 'samlwood/vis-gruvbox', file = 'gruvbox', theme = true },
}

-- require and optionally install plugins on init
plug.init(plugins, true)

vis.events.subscribe(vis.events.INIT, function()
	-- Your global configuration options
end)

vis.events.subscribe(vis.events.WIN_OPEN, function(win)
	-- Your per window configuration options
	vis:command('set number')
	vis:command('set tabwidth 4')
	vis:command('set show-tabs on')
end)

my_fzf_args = string.gsub([[
    --bind=$my_fzf_key_bindings \
    --color fg:242,bg:236,hl:65,fg+:15,bg+:239,hl+:108 \
    --color info:108,prompt:109,spinner:108,pointer:168,marker:168 \
    --delimiter / --nth -1 \
    --height=70% \
    --inline-info \
    --no-mouse \
    --preview-window=up:70% \
    --preview="(
        bat --style=changes,grid,numbers --color=always {} ||
        highlight -O ansi -l {} ||
        coderay {} ||
        rougify {} ||
        cat {}
    ) 2> /dev/null | head -1000"
]], '%$([%w_]+)', {
    my_fzf_key_bindings=table.concat({
        "alt-j:preview-down",
        "alt-k:preview-up",
        "ctrl-f:preview-page-down",
        "ctrl-b:preview-page-up",
        "?:toggle-preview",
        "alt-w:toggle-preview-wrap",
        "ctrl-z:clear-screen"
    }, ",")
})

local plugin_vis_open = require('plugins/vis-fzf-open')
-- Arguments passed to fzf (default: "")
plugin_vis_open.fzf_args = my_fzf_args

vis:map(vis.modes.NORMAL, ' w', ':w<Enter>')
vis:map(vis.modes.NORMAL, ' q', ':q<Enter>')
vis:map(vis.modes.NORMAL, '<C-s>', ':w<Enter>')
vis:map(vis.modes.NORMAL, '<C-q>', ':q<Enter>')

vis:map(vis.modes.NORMAL, '<Enter>', 'o<Escape>')

vis:command('map! normal <C-j> <vis-selection-new-lines-above>')
vis:command('map! normal <C-k> <vis-selection-new-lines-below>')
vis:map(vis.modes.NORMAL, '<C-Up>', '<C-j>')
vis:map(vis.modes.NORMAL, '<C-Down>', '<C-k>')

vis:map(vis.modes.NORMAL, '<C-Left>', 'b')
vis:map(vis.modes.NORMAL, '<C-Right>', 'w')

vis:map(vis.modes.NORMAL, ' p', '"+p')
vis:map(vis.modes.NORMAL, ' y', '"+y')
vis:map(vis.modes.VISUAL, ' y', '"+y')

vis:map(vis.modes.NORMAL, ' ff', ':fzf<Enter>')
vis:map(vis.modes.NORMAL, ' fh', ':fzf --search-path $HOME<Enter>')
vis:map(vis.modes.NORMAL, ' fr', ':fzf --search-path /<Enter>')
vis:map(vis.modes.NORMAL, ' fg', ':fzf --search-path "$(git rev-parse --show-toplevel<C-s>)"<Enter>')

vis:map(vis.modes.NORMAL, ' h', ':fzfmru<Enter>')

vis:map(vis.modes.NORMAL, '<C-w><Left>', '<C-w>h')
vis:map(vis.modes.NORMAL, '<C-w><Right>', '<C-w>l')
vis:map(vis.modes.NORMAL, '<C-w><Up>', '<C-w>k')
vis:map(vis.modes.NORMAL, '<C-w><Down>', '<C-w>j')
