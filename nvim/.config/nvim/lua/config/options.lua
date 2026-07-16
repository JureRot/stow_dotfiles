vim.opt.termguicolors = true

vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.wrap = true
vim.opt.linebreak = true

vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = false
vim.opt.incsearch = true

-- edit these
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
-- vim.opt.softtabstop = 4 -- for editing operations
-- vim.opt.expandtab = false -- use paces instead of tabs

vim.opt.signcolumn = "yes"

vim.opt.cursorline = true
vim.opt.colorcolumn = "80"

vim.opt.scrolloff = 8

vim.opt.splitbelow = true
vim.opt.splitright = true

--vim.opt.showmatch = true -- show matching brackets

vim.opt.autoread = true --auto-reload changes if outside of neovim

vim.opt.errorbells = false

-- vim.opt.backspace = "indent,eol,start" -- better backspace behaviour

-- vim.opt.iskeyword:append("-") -- hypinated words behave as single word

vim.opt.path:append("**") -- include subdirectories in search
vim.opt.selection = "inclusive"

vim.opt.mouse = "a" -- enable mouse support

-- vim.opt.clipboard:append("")

vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()" -- use treesitter for folding
vim.opt.foldlevel = 99 -- start with all folds open

vim.opt.encoding = "utf-8"

-- enable persistent history
local undodir = vim.fn.expand("$HOME/.nvimundodir")
if (vim.fn.isdirectory(undodir) == 0) then -- create undodir if nonexistent
	vim.fn.mkdir(undodir, "p")
end
vim.opt.undodir = undodir
vim.opt.undofile = true
-- vim.opt.backup = false
-- vim.opt.writebackup = false
-- vim.opt.swapfile = false
