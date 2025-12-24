local opts = { noremap = true, silent = true }

vim.keymap.set("n", "<leader>pr", ":w<CR>:!julia --project=. %<CR>", opts) -- save and run current file as part of project in current file with lua cli tool
-- project setting is required when using packages (which are written in Project.toml) so it knows about them
