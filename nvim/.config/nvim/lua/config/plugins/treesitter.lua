-- nvim-treesitter
-- requires nvim-treesitter-cli (installed via cargo-binstall)
local setup_treesitter = function()
	local treesitter = require("nvim-treesitter")
	treesitter.setup({})
	local ensure_installed = {
		"c",
		"lua",
		"vim",
		"vimdoc",
		"markdown",
		"markdown_inline",
		"python",
		"c_sharp",
	}

	local config = require("nvim-treesitter.config")
	config.setup({
		highlight = {
			enable = true,
		},
		indent = {
			enable = true,
			disable = { "cs" },
		},
	})

	local already_installed = config.get_installed()
	local parsers_to_install = {}

	for _, parser in ipairs(ensure_installed) do
		if not vim.tbl_contains(already_installed, parser) then
			table.insert(parsers_to_install, parser)
		end
	end

	if #parsers_to_install > 0 then
		treesitter.install(parsers_to_install)
	end

	local group = vim.api.nvim_create_augroup("TreeSitterConfig", { clear = true })
	vim.api.nvim_create_autocmd("FileType", {
		group = group,
		callback = function(args)
			if vim.list_contains(treesitter.get_installed(), vim.treesitter.language.get_lang(args.match)) then
				vim.treesitter.start(args.buf)
			end
		end,
	})
end

setup_treesitter()


-- nvim-treesitter-context
require("treesitter-context").setup {
	enable = true,
	max_lines = 0,
	min_window_height = 0,
	line_numbers = true,
	multiline_threshold = 1,
	trim_scope = 'outer',
	mode = 'cursor',
	separater = nil,
	zindex = 20,
	on_attach = nil,
}
