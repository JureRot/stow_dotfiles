vim.g.mapleader = " "

-- bind ctrl+backspace (insert mode) to ctrl+w (delete word backwards)
-- vim.keymap.set("i", "<C-BS>", "<C-w>", opts)
--vim.keymap.set("i", "<C-h>", "<C-w>", opts) --workaround for terminals

--[[
-- moving by line in wrapped lines
vim.kemap.set("n", "j", function()
	return vim.v.count == 0 and "gj" or "j"
end, { expr = true, silent = true, desc = "Down (wrap-aware)" })
vim.kemap.set("n", "k", function()
	return vim.v.count == 0 and "gk" or "k"
end, { expr = true, silent = true, desc = "Up (wrap-aware)" })
--]]

-- TODO: bind for highlighting search and keeping it

-- put next search result in the midle
-- vim.keymap.set("n", "n", "nzzzv", { desc = "Next search result (centered)" })
-- vim.keymap.set("n", "N", "Nzzzv", { desc = "Previous search result (centered)" })

-- pasting while having something visually selected does not overwrite yanked value
vim.keymap.set("v", "p", '"_dP', { desc = "Pasting without yanking visually selected" })

-- deleting something does not overwrite yanked value
vim.keymap.set({ "n", "v" }, "<leader>x", '"_d', { desc = "Deleting without yanking" })

-- move selected text (visual mode) up and down with Up and Down arrows
vim.keymap.set("v", "<Down>", ":m '>+1<CR>gv=gv", { desc = "Move visual selecion down" })
vim.keymap.set("v", "<Up>", ":m '<-2<CR>gv=gv", { desc = "Move visual selection up" })

-- keep visual selection when indenting
vim.keymap.set("v", "<", "<gv", { desc = "Indent left and reselect" })
vim.keymap.set("v", ">", ">gv", { desc = "Indent right and reselect" })

vim.keymap.set("n", "<leader>ut", ":Undotree<CR>", { desc = "Toggle Undotree" })

vim.keymap.set("n", "<leader>y", '"+y', { desc = "Yank to clipboard" })
vim.keymap.set("n", "<leader>yy", '"+Y', { desc = "Yank line to clipboard" })
vim.keymap.set("v", "<leader>y", '"+y', { desc = "Yank visual selection to clipboard" })
--vim.keymap.set("n", "<leader>p", '"*p', { desc = "Paste from clipboard"})
--vim.keymap.set("n", "<leader><S-p>", '"*P', { desc = "Paste above from clipboard"})


-- better movement in wrapped text
vim.keymap.set("n", "j", function()
	return vim.v.count == 0 and "gj" or "j"
end, { expr = true, silent = true, desc = "Down (wrap-aware)" })
vim.keymap.set("n", "k", function()
	return vim.v.count == 0 and "gk" or "k"
end, { expr = true, silent = true, desc = "Up (wrap-aware)" })


-- bind ctrl+backspace (insert mode) to ctrl+w (delete word backwards)
--vim.keymap.set("i", "<C-BS>", "<C-w>", opts)
vim.keymap.set("i", "<C-h>", "<C-w>", opts) --workaround for terminals


-- TODO: bindings for folding (for now is `za` for toggle fold)
