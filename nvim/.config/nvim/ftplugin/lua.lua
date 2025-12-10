local opts = { noremap = true, silent = true }

vim.keymap.set("n", "<leader>pr", ":!lua %<CR>", opts) -- run current file with lua cli tool
