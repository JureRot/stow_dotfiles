require("nvim-tree").setup({
	view = {
		width = 30,
	},
	filters = {
		dotfiles = false,
	},
	renderer = {
		group_empty = true,
	},
	diagnostics = {
		enable = true,
	},
	git = {
		enable = true,
	},
	update_focused_file = {
		enable = true,
	},
})

vim.keymap.set("n", "<leader>e", function()
	require("nvim-tree.api").tree.toggle()
end, { desc = "Toggle NvimTree" })
