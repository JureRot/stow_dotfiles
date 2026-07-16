local opts = { noremap = true, silent = true }

vim.keymap.set("n", "<leader>pr", ":w<CR>:!python %<CR>", opts) -- save and run current file with python cli tool
