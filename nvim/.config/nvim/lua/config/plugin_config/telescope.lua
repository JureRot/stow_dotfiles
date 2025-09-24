local builtin = require('telescope.builtin')
local opts = {}

function vim.getVisualSelection()
    vim.cmd('noau normal! "vy"')
    local text = vim.fn.getreg('v')
    vim.fn.setreg('v', {})

    text = string.gsub(text, "\n", "")
    if #text > 0 then
        return text
    else
        return ''
    end
end

--[[
function GetChangedOnBranchFiles()
    vim.cmd('noau normal! "vy"')
    local text = vim.fn.getreg('v')
    vim.fn.setreg('v', {})

    text = string.gsub(text, "\n", "")
    if #text > 0 then
        return text
    else
        return ''
    end
end
--]]

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

-- find files
vim.keymap.set('n', '<leader>fg', builtin.find_files, opts)
vim.keymap.set('v', '<leader>fg', function()
    local text = vim.getVisualSelection()
    builtin.find_files({ default_text = text })
end)

-- find text (requires ripgrep)
vim.keymap.set('n', '<leader>ff', builtin.live_grep, opts)
vim.keymap.set('v', '<leader>ff', function()
    local text = vim.getVisualSelection()
    builtin.live_grep({ default_text = text })
end)

-- find word under cursor
vim.keymap.set('n', '<leader>fs', builtin.grep_string, opts)

-- search buffers
vim.keymap.set('n', '<leader>fb', builtin.buffers, opts)

-- search marks
--vim.keymap.set('n', '<leader>fm', builtin.marks, opts) --have the same for harpoon

-- search help tags
vim.keymap.set('n', '<leader>fh', builtin.help_tags, opts)


-- git
vim.keymap.set('n', '<leader>gb', builtin.git_branches, opts)
vim.keymap.set('n', '<leader>gc', builtin.git_status, opts)
--vim.keymap.set('n', '<leader>gc', function() builtin.git_status({ path_display = { "tail" } }) end) --same as above but without path??

-- custom git script (not that good)
vim.keymap.set('n', '<leader>fc', function() changed_on_branch(opts) end)
--{ "<leader>gm", function() changed_on_branch() end, desc = "Modified files" },

-- search diagnostics
-- create another custom picker like changed_on_branch but using (:lua vim.diagnostic.setqflist())
--vim.keymap.set("n", "<leader>fd", ':lua vim.diagnostic.setqflist()<CR>', opts)
vim.keymap.set("n", "<leader>fd", builtin.diagnostics, opts)


--todo better rebinds (ff, fg, fb are bad because on the same finger)
--todo quickfix (and jumplist) search
--todo need lsp_references search
--todo need git files search (files not in gitignore, and changed files)
--todo need sorting by recent (telescope-frecency or telescope-all-recent

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
	-- layout_strategy = "vertical",
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
    }
}

-- load extensions
require("telescope").load_extension("harpoon")
--require("telescope").load_extension("git_worktree")


