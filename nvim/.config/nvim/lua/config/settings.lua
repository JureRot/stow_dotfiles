vim.opt.termguicolors = true

vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.wrap = true
vim.opt.linebreak = true

--vim.o.incsearch = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.hlsearch = false

vim.opt.cursorline = true

vim.opt.colorcolumn = "80"

vim.opt.scrolloff = 8

-- split windows below and to the right (opposite of default)
vim.opt.splitbelow = true
vim.opt.splitright = true

-- highlight yanked text
vim.api.nvim_create_autocmd('TextYankPost', {
	group = vim.api.nvim_create_augroup('highlight_yank', {}),
	desc = 'Highlight selected on yank',
	pattern = '*',
	callback = function()
		vim.highlight.on_yank { higroup = 'Visual', timeout = 500 }
	end
})

-- remove auto comment on new line
vim.api.nvim_create_autocmd("FileType", {
	pattern = "*",
	callback = function()
		vim.opt_local.formatoptions:remove({ 'r', 'o' })
	end
})

-- enable persistent history
vim.opt.undodir = vim.fn.expand("$HOME/.nvimundodir")
vim.opt.undofile = true
