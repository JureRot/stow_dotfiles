local opts = { noremap = true, silent = true }

vim.keymap.set("n", "<leader>pr", ":!python %<CR>", opts) -- run current file with python cli tool
