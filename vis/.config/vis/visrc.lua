-- load standard vis module, providing parts of the Lua API
require('vis')
-- load plugins
require('plugins/vis-commentary')
require('plugins/vis-surround')
require('plugins/vis-jump')
require('plugins/vis-exchange')
--require('plugins/vis-goto-file')

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
vis:map(vis.modes.NORMAL, '<Enter>', 'o<Escape>')
vis:map(vis.modes.NORMAL, '<C-Up>', '<C-k>')
vis:map(vis.modes.NORMAL, '<C-Down>', '<C-j>')
vis:map(vis.modes.NORMAL, '<C-Left>', 'b')
vis:map(vis.modes.NORMAL, '<C-Right>', 'w')
