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
	{ 'git.sr.ht/~mcepl/vis-fzf-open' },
	{ 'peaceant/vis-fzf-mru.git', file = 'fzf-mru' },
	{ 'https://github.com/samlwood/vis-gruvbox', file = 'gruvbox', theme = true },
}

-- require and optionally install plugins on init
plug.init(plugins, true)

-- vis:command('set theme vis-gruvbox')

vis.events.subscribe(vis.events.INIT, function()
	-- Your global configuration options
end)

vis.events.subscribe(vis.events.WIN_OPEN, function(win)
	-- Your per window configuration options
	vis:command('set number')
	vis:command('set tabwidth 4')
	vis:command('set show-tabs on')
end)

vis:map(vis.modes.NORMAL, ' w', ':w<Enter>')
vis:map(vis.modes.NORMAL, ' q', ':q<Enter>')
vis:map(vis.modes.NORMAL, '<C-s>', ':w<Enter>')
vis:map(vis.modes.NORMAL, '<C-q>', ':q<Enter>')
vis:map(vis.modes.NORMAL, '<Enter>', 'o<Escape>')
vis:map(vis.modes.NORMAL, '<C-Up>', '<C-k>')
vis:map(vis.modes.NORMAL, '<C-Down>', '<C-j>')
vis:map(vis.modes.NORMAL, '<C-Left>', 'b')
vis:map(vis.modes.NORMAL, '<C-Right>', 'w')
vis:map(vis.modes.NORMAL, ' p', '"+p')
vis:map(vis.modes.NORMAL, ' y', '"+y')
vis:map(vis.modes.VISUAL, ' y', '"+y')
vis:map(vis.modes.NORMAL, ' f', ':fzf<Enter>')
vis:map(vis.modes.NORMAL, ' h', ':fzfmru<Enter>')
vis:map(vis.modes.NORMAL, '<C-w><Left>', '<C-w>h')
vis:map(vis.modes.NORMAL, '<C-w><Right>', '<C-w>l')
vis:map(vis.modes.NORMAL, '<C-w><Up>', '<C-w>k')
vis:map(vis.modes.NORMAL, '<C-w><Down>', '<C-w>j')
