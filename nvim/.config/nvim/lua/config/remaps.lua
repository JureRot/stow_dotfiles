local opts = { noremap = true, silent = true }

-- set leader to space
vim.g.mapleader = ' '

-- bind ctrl+backspace (insert mode) to ctrl+w (delete word backwards)
vim.keymap.set("i", "<C-BS>", "<C-w>", opts)
--vim.keymap.set("i", "<C-h>", "<C-w>", opts) --workaround for terminals

-- move selected text (visual mode) up and down with Up and Down arrows
vim.keymap.set("v", "<Down>", ":m '>+1<CR>gv=gv", opts)
vim.keymap.set("v", "<Up>", ":m '<-2<CR>gv=gv", opts)

-- pasting while having something visually selected does not overwrite yanked value
vim.keymap.set("v", "p", '"_dP', opts)

-- yank to clipboard using <leader>y and <leader>p (maybe use Y instead)
vim.keymap.set("n", "<leader>y", '"+y', opts)
vim.keymap.set("n", "<leader>yy", '"+Y', opts)
vim.keymap.set("v", "<leader>y", '"+y', opts)
vim.keymap.set("n", "<leader>p", '"*p', opts)
vim.keymap.set("n", "<leader><S-p>", '"*P', opts)

-- file tree
--vim.keymap.set("n", "<leader>e", ':Lex<CR>', opts)
vim.keymap.set("n", "<leader>e", ':NvimTreeToggle<CR>', opts)

-- search buffer for visually selected
vim.keymap.set("v", "<leader>/", 'y/<C-r>"<CR>n', opts)

-- dotnet shortcuts
--vim.keymap.set("n", "<leader>db", ':!dotnet build<CR>', opts)
--vim.keymap.set("n", "<leader>dr", ':!dotnet run<CR>', opts)

