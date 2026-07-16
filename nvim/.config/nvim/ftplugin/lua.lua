local opts = { noremap = true, silent = true }

vim.keymap.set("n", "<leader>pr", ":w<CR>:!lua %<CR>", opts) -- save and run current file with lua cli tool

vim.keymap.set("n", "<leader>pfr", ":w<CR>:!luajit %<CR>", opts) -- save and run current file with luaJIT cli tool
