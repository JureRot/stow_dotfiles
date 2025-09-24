require ("config.plugin_config.colorscheme")
require ("config.plugin_config.lualine")
require ("config.plugin_config.nvim-tree")
require ("config.plugin_config.treesitter")
require ("config.plugin_config.treesitter-context")
require ("config.plugin_config.todo-comments")
require ("config.plugin_config.harpoon")
require ("config.plugin_config.marks")
require ("config.plugin_config.telescope")
require ("config.plugin_config.undotree")
--require ("config.plugin_config.gitsigns")
--require ("config.plugin_config.fugitive") --missing keybinds
--require ("config.plugin_config.lsp")
--require ("config.plugin_config.autocmpletion") --nvim-ts-autotag not installed and enabled
--(require ("config.plugin_config.illuminate"))

-- maybe add something for hl indented chunk you are in

-- maybe add something for debugging (but this can be somewhat language and framework specific)

-- use folding
	-- set foldmethod=indent
	-- than use za to toggle folds (or zo /zc to open/close) (zf in visual mode creates a manual fold)
	-- zM and zR used to open/close all folds
