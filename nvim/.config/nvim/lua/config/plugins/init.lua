-- update packages with `:lua vim.pack.update()`
-- delete packages with `:lua vim.pack.del({ "name_of_package" })

vim.pack.add({
	"https://github.com/sainnhe/sonokai",
	"https://github.com/nvim-tree/nvim-web-devicons",
	"https://github.com/nvim-tree/nvim-tree.lua",
	"https://github.com/nvim-lualine/lualine.nvim",
	{
		src = "https://github.com/nvim-treesitter/nvim-treesitter",
		branch = "main",
		build = ":TSUpdate",
	},
	"https://github.com/nvim-treesitter/nvim-treesitter-context",
	"https://github.com/lewis6991/gitsigns.nvim",
	"https://github.com/nvim-lua/plenary.nvim",
	"https://github.com/nvim-telescope/telescope.nvim",
	"https://github.com/nvim-telescope/telescope-fzf-native.nvim",
	"https://github.com/ThePrimeagen/harpoon",
	"https://github.com/neovim/nvim-lspconfig",
	"https://github.com/mason-org/mason.nvim",
	"https://github.com/Saghen/blink.cmp",
	"https://github.com/Saghen/blink.lib",
	"https://github.com/L3MON4D3/LuaSnip",
	"https://github.com/seblyng/roslyn.nvim",
	"https://github.com/windwp/nvim-autopairs",
	"https://github.com/saghen/blink.indent",
	"https://github.com/chentoast/marks.nvim",
	"https://github.com/mfussenegger/nvim-dap",
	"https://github.com/rcarriga/nvim-dap-ui",
	"https://github.com/nvim-neotest/nvim-nio",
	"https://github.com/thehamsta/nvim-dap-virtual-text",
})

local function packadd(name)
	vim.cmd("packadd " .. name)
end

packadd("sonokai")
packadd("nvim-web-devicons")
packadd("nvim-tree.lua")
packadd("lualine.nvim")
packadd("nvim-treesitter")
packadd("nvim-treesitter-context")
packadd("nvim.undotree") -- built-in, just need to add it
packadd("gitsigns.nvim")
packadd("plenary.nvim")
packadd("telescope.nvim")
packadd("telescope-fzf-native.nvim")
packadd("harpoon")
packadd("nvim-lspconfig")
packadd("mason.nvim")
packadd("blink.cmp")
packadd("blink.lib")
packadd("LuaSnip")
packadd("roslyn.nvim")
packadd("nvim-autopairs")
packadd("blink.indent")
packadd("marks.nvim")
packadd("nvim-dap")
packadd("nvim-dap-ui")
packadd("nvim-nio")
packadd("nvim-dap-virtual-text")

-- individual plugin configs
require("config.plugins.colorscheme")
require("config.plugins.nvim_tree")
require("config.plugins.lualine")
require("config.plugins.treesitter")
require("config.plugins.gitsigns")
require("config.plugins.telescope")
require("config.plugins.harpoon")
require("config.plugins.lsp")
require("config.plugins.autocomplete")
require("config.plugins.debugging")
require("config.plugins.marks")
require("config.plugins.qol")
