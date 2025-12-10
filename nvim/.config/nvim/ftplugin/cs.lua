local opts = { noremap = true, silent = true }

vim.keymap.set("n", "<leader>pb", ':!dotnet build<CR>', opts)
vim.keymap.set("n", "<leader>pr", ':!dotnet run<CR>', opts)

