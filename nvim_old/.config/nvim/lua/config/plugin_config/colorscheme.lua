-- sonokai
vim.g.sonokai_style = 'shusia' -- default is also good
vim.g.sonokai_menu_selection_background = 'green'

-- change visual hl color (default for shusia: bg3 -> #423f4g: bg4 -> #49454e
--vim.g.sonokai_colors_override = {['bg3'] = {'#514e56', '237'}, ['bg4'] = {'#58555e', '237'}}

vim.cmd.colorscheme 'sonokai'


--[[
-- one dark pro
require("onedarkpro").setup({
	highlights = {
		Comment = { italic = true},
	}
})
vim.cmd.colorscheme 'onedark_vivid'
--]]
