local opts = { noremap = true, silent = true }

vim.keymap.set("n", "<leader>pr", ":w<CR>:!julia %<CR>", opts) -- save and run current file with lua cli tool
