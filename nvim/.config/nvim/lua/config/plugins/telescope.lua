require('telescope').setup {
    defaults = {
        mappings = {
            i = {
            }
        },
        -- makes so the names in path are 2 characters long
        path_display = {
            --"tail"
            --"truncate"
            --"smart"
            filename_first = { reverse_directories = false }
        },
	layout_strategy = "vertical",
    },
    pickers = {
        find_files = {
            hidden = true
        },
        live_grep = {
            additional_args = function()
                return {"--hidden"}
            end
        },
        grep_string = {
            additional_args = function()
                return {"--hidden"}
            end
        }
    },
	extensions = {
		fzf = {
			fuzzy = true,                    -- false will only do exact matching
			override_generic_sorter = true,  -- override the generic sorter
			override_file_sorter = true,     -- override the file sorter
			case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
			-- the default case_mode is "smart_case"
		}
	}
}

require("telescope").load_extension("fzf") -- requires manual `make` in .local/share/nvim/site/pack/core/opt/telescope-fzf-native.nvim directory
require("telescope").load_extension("harpoon")


local changed_on_branch = function(local_opts)
	local pickers = require "telescope.pickers"
	local finders = require "telescope.finders"
	local sorters = require "telescope.sorters"
	local previewers = require "telescope.previewers"
	-- local conf = require("telescope.config").values

	opts = local_opts or {}
	pickers.new(opts, {
		prompt_title = "Find Files",
		results_title = "Modified in current branch",
		finder = finders.new_oneshot_job({
			"git",
			"ls-files",
			"--modified",
			"--deleted",
			"--others",
			"--exclude-standard",
			"-t",
			--"status",
			--"--porcelain=v1",
			--"--",
			--"."
		}, {}),
		sorter = sorters.get_fuzzy_file(),
		previewer = previewers.git_file_diff.new(opts), -- doesnt work with this way of finder
	}):find()
end

function vim.getVisualSelection()
	vim.cmd('noau normal! "vy"')
	local text = vim.fn.getreg("v")
	vim.fn.setreg("v", {})

	text = string.gsub(text, "\n", "")
	if #text > 0 then
		return text
	else
		return ""
	end
end

vim.keymap.set("n", "<leader>ff", function()
	require("telescope.builtin").find_files()
end, { desc = "Find files" })
vim.keymap.set("n", "<leader>fg", function()
	require("telescope.builtin").live_grep()
end, { desc = "Grep" })
vim.keymap.set("v", "<leader>fg", function()
	local text = vim.getVisualSelection()
	require("telescope.builtin").live_grep({ default_text = text })
end, { desc = "Grep" })
vim.keymap.set("n", "<leader>fs", function()
	require("telescope.builtin").grep_string()
end, { desc = "Grep word under cursor" })
vim.keymap.set("n", "<leader>fb", function()
	require("telescope.builtin").buffers()
end, { desc = "Find buffers" })
vim.keymap.set("n", "<leader>gb", function()
	require("telescope.builtin").git_branches()
end, { desc = "Git branches" })
vim.keymap.set("n", "<leader>gc", function()
	require("telescope.builtin").git_status()
end, { desc = "Git changes" })
vim.keymap.set("n", "<leader>fc", function()
	changed_on_branch()
end, { desc = "Git changes (mine)" })
-- todo: improve fc order (changed, added, deleted, untracked) or create a better one
vim.keymap.set("n", "<leader>fd", function()
	require("telescope.builtin").diagnostics()
end, { desc = "Show diagnostics" })
