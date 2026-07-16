-- update packages with `:lua vim.pack.update()`
-- delete packages with `:lua vim.pack.del({ "name_of_package" })

vim.pack.add({
	"https://github.com/sainnhe/sonokai",
	"https://github.com/nvim-tree/nvim-web-devicons",
	"https://github.com/nvim-tree/nvim-tree.lua",
	"https://github.com/nvim-lualine/lualine.nvim",
	{
		src = "https://github.com/nvim-treesitter/nvim-treesitter",
		branch = "main",
		build = ":TSUpdate",
	},
	"https://github.com/nvim-treesitter/nvim-treesitter-context",
	"https://github.com/lewis6991/gitsigns.nvim",
	"https://github.com/nvim-lua/plenary.nvim",
	"https://github.com/nvim-telescope/telescope.nvim",
	"https://github.com/nvim-telescope/telescope-fzf-native.nvim",
	"https://github.com/ThePrimeagen/harpoon",
	"https://github.com/neovim/nvim-lspconfig",
	"https://github.com/mason-org/mason.nvim",
	"https://github.com/Saghen/blink.cmp",
	"https://github.com/Saghen/blink.lib",
	"https://github.com/L3MON4D3/LuaSnip",
	"https://github.com/seblyng/roslyn.nvim",
	"https://github.com/windwp/nvim-autopairs",
	"https://github.com/saghen/blink.indent",
	"https://github.com/chentoast/marks.nvim",
	"https://github.com/mfussenegger/nvim-dap",
	"https://github.com/rcarriga/nvim-dap-ui",
	"https://github.com/nvim-neotest/nvim-nio",
	"https://github.com/thehamsta/nvim-dap-virtual-text",
})

local function packadd(name)
	vim.cmd("packadd " .. name)
end


packadd("sonokai")
packadd("nvim-web-devicons")
packadd("nvim-tree.lua")
packadd("lualine.nvim")
packadd("nvim-treesitter")
packadd("nvim-treesitter-context")
packadd("nvim.undotree") -- built-in, just need to add it
packadd("gitsigns.nvim")
packadd("plenary.nvim")
packadd("telescope.nvim")
packadd("telescope-fzf-native.nvim")
packadd("harpoon")
packadd("nvim-lspconfig")
packadd("mason.nvim")
packadd("blink.cmp")
packadd("blink.lib")
packadd("LuaSnip")
packadd("roslyn.nvim")
packadd("nvim-autopairs")
packadd("blink.indent")
packadd("marks.nvim")
packadd("nvim-dap")
packadd("nvim-dap-ui")
packadd("nvim-nio")
packadd("nvim-dap-virtual-text")

--todo:
-- todo-comments
-- marks
-- lsp (c#)


-- CONFIGS --
vim.g.sonokai_style = 'shusia' -- default is also good
vim.g.sonokai_menu_selection_background = 'green'
vim.cmd.colorscheme("sonokai")

-- nvim-tree
require("nvim-tree").setup({
	view = {
		width = 30,
	},
	filters = {
		dotfiles = false,
	},
	renderer = {
		group_empty = true,
	},
	diagnostics = {
		enable = true,
	},
	git = {
		enable = true,
	},
	update_focused_file = {
		enable = true,
	},
})


-- lualine
require('lualine').setup {
	options = {
		icons_enabled = true,
		--theme = 'sonokai',
		--theme = 'onedark_vivid',
		-- component_separators = { left = '', right = ''},
		-- section_separators = { left = '', right = ''},
		component_separators = { left = '┊', right = '┊'},
		section_separators = { left = '', right = ''},
	},
}


-- nvim-treesitter
-- requires nvim-treesitter-cli (installed via cargo-binstall)
local setup_treesitter = function()
	local treesitter = require("nvim-treesitter")
	treesitter.setup({})
	local ensure_installed = {
		"c",
		"lua",
		"vim",
		"vimdoc",
		"markdown",
		"markdown_inline",
		"python",
		"c_sharp",
	}

	local config = require("nvim-treesitter.config")
	config.setup({
		highlight = {
			enable = true,
		},
		indent = {
			enable = true,
			disable = { "cs" },
		},
	})

	local already_installed = config.get_installed()
	local parsers_to_install = {}

	for _, parser in ipairs(ensure_installed) do
		if not vim.tbl_contains(already_installed, parser) then
			table.insert(parsers_to_install, parser)
		end
	end

	if #parsers_to_install > 0 then
		treesitter.install(parsers_to_install)
	end

	local group = vim.api.nvim_create_augroup("TreeSitterConfig", { clear = true })
	vim.api.nvim_create_autocmd("FileType", {
		group = group,
		callback = function(args)
			if vim.list_contains(treesitter.get_installed(), vim.treesitter.language.get_lang(args.match)) then
				vim.treesitter.start(args.buf)
			end
		end,
	})
end

setup_treesitter()


-- nvim-treesitter-context
require("treesitter-context").setup {
	enable = true,
	max_lines = 0,
	min_window_height = 0,
	line_numbers = true,
	multiline_threshold = 1,
	trim_scope = 'outer',
	mode = 'cursor',
	separater = nil,
	zindex = 20,
	on_attach = nil,
}


-- gitsigns
require("gitsigns").setup {
    signs = {
        add          = { text = '│' },
        change       = { text = '│' },
        delete       = { text = '_' },
        topdelete    = { text = '‾' },
        changedelete = { text = '~' },
        untracked    = { text = '○' },
    },
    signcolumn = true,  -- Toggle with `:Gitsigns toggle_signs`
    numhl      = false, -- Toggle with `:Gitsigns toggle_numhl`
    linehl     = false, -- Toggle with `:Gitsigns toggle_linehl`
    word_diff  = false, -- Toggle with `:Gitsigns toggle_word_diff`
    watch_gitdir = {
        interval = 1000,
        follow_files = true
    },
    attach_to_untracked = true,
    current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
    current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
        delay = 1000,
        ignore_whitespace = false,
    },
    current_line_blame_formatter = '<author>, <author_time:%Y-%m-%d> - <summary>',
    sign_priority = 6,
    update_debounce = 100,
    status_formatter = nil, -- Use default
    max_file_length = 40000, -- Disable if file is longer than this (in lines)
    preview_config = {
        -- Options passed to nvim_open_win
        border = 'single',
        style = 'minimal',
        relative = 'cursor',
        row = 0,
        col = 1
    },
}



-- telescope
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


-- harpoon
require("harpoon").setup({
})


-- Mason
require("mason").setup({
})

-- LSP
vim.diagnostic.config({
	virtual_text = { enable = true },
})

local function lsp_on_attach(ev)
	local client = vim.lsp.get_client_by_id(ev.data.client_id)
	if not client then
		return
	end

	local bufnr = ev.buf
	local opts = { noremap = true, silent = true, buffer = bufnr }

	vim.keymap.set("n", "gd", vim.lsp.buf.definition, {})
	--vim.keymap.set("n", "gd", require("telescope.builtin").lsp_definitions, {})
	--vim.keymap.set("n", "gi", vim.lsp.buf.implementation, {})
	vim.keymap.set("n", "gi", require("telescope.builtin").lsp_implementations, {})
	vim.keymap.set("n", "gr", require("telescope.builtin").lsp_references, {})
	vim.keymap.set("n", "gt", require("telescope.builtin").lsp_type_definitions, {})
	vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
	vim.keymap.set("n", "<leader>d", require("telescope.builtin").diagnostics, {})

	vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, {})
	vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, {})

	vim.keymap.set("n", "<leader>sd", function()
		--vim.diagnostics.open_float({ focus = false, scope = "cursor" })
		vim.diagnostic.open_float({ scope = "cursor" })
	end, opts)
	vim.keymap.set("n", "<leader>sD", function()
		vim.diagnostic.open_float({ scope = "line" })
	end, opts)

	--vim.keymap.set("n", "<leader>]d", vim.diagnostic.goto_next(), opts)
	--vim.keymap.set("n", "<leader>[d", vim.diagnostic.goto_prev(), opts)
end

local augroup = vim.api.nvim_create_augroup("UserConfig", { clear = true })
vim.api.nvim_create_autocmd("LspAttach", { group = augroup, callback = lsp_on_attach })

-- add completion capabilities for all language servers
vim.lsp.config["*"] = {
	capabilities = require("blink.cmp").get_lsp_capabilities(),
}

vim.lsp.config("lua_ls", {
	settings = {
		Lua = {
			diagnostics = { globals = { "vim" } },
			telemetry = { enable = false },
		},
	},
})
vim.lsp.config("pylsp", {
	settings = {
    pylsp = {
      plugins = {
        pycodestyle = {
          ignore = {'W391'},
          maxLineLength = 100,
        },
      },
    },
  }
})
--[[
vim.lsp.config("roslyn_ls", {
})
--]]
vim.lsp.config("roslyn", {
	--[[
	choose_target = function(target)
		return vim.iter(target):find(function(item)
			if string.match(item, "PECore.slnx") then
				return item
			end
		end)
	end,
	lock_target = true,
	config = {
		settings = {
			["csharp|symbol_search"] = {
				-- Enable searching external references/assemblies for symbols
				dotnet_search_reference_assemblies = true,
			},
			["csharp|completion"] = {
				-- Show completion suggestions from unimported NuGet packages/namespaces
				dotnet_show_name_completion_suggestions = true,
			},
			["csharp|decompilation"] = {
				-- Allows Neovim to navigate (Go-To-Definition) into external DLLs
				enable_decompilation = true,
			}
		}
	}
	--]]
})

vim.lsp.enable({
	"lua_ls",
	"pylsp",
	--"roslyn_ls", -- handled by roslyn.nvim
})


-- Blink
require("blink.cmp").build():pwait()
require("blink.cmp").setup({
	keymap = {
		preset = "none",
		["<C-Space>"] = { "show", "hide" },
		["<CR>"] = { "accept", "fallback" },
		["<C-j>"] = { "select_next", "fallback" },
		["<C-k>"] = { "select_prev", "fallback" },
		["<Down>"] = { "select_next", "fallback" },
		["<Up>"] = { "select_prev", "fallback" },
		["<C-n>"] = { "select_next", "fallback" },
		["<C-p>"] = { "select_prev", "fallback" },
		--["<Tab>"] = { "snippet_forward", "fallback" },
		--["<S-Tab>"] = { "snippet_backward", "fallback" },
	},
	--appearance = {},
	completion = { menu = { auto_show = true } },
	sources = { default = { "lsp", "path", "buffer", "snippets" } },
	--sources = { default = { "lsp", "snippets", "path", "buffer" } },
	snippets = {
		expand = function(snippet)
			require("luasnip").lsp_expand(snippet)
		end,
	},
	fuzzy = {
		implementation = "prefer_rust",
	},
})


-- nvim-autopairs
require("nvim-autopairs").setup({
})


-- indentation guides
require("blink.indent").setup({
	scope = {
		enabled = true,
		highlights = { "BlinkIndentScope" },
	}
})


-- marks
require("marks").setup {
	default_mappings = true,
	builtin_marks = {},
	cyclic = true,
	force_write_shada = true,
	refresh_interval = 250,
	sign_priority = { lower=10, upper=15, builtin=8, bookmark=20 },
	excluded_filetypes = {},
	bookmark_0 = {
		sign = "⚑",
		virt_text = "hello world",
		annotate = false,
	},
	mappings = {},
}


-- debugging

local dap = require("dap")
local dapui = require("dapui")

local function pick_dotnet_process()
  local processes = require('dap.utils').get_processes()
  local filtered = {}
  
  -- Step 1: Use PowerShell to find the actual active Web / Worker worker processes.
  -- This identifies the real child processes and filters out the parent dotnet.exe wrappers.
  local handle = io.popen('powershell -Command "Get-CimInstance Win32_Process | Where-Object {$_.CommandLine -like \'*Hilti*\' -and $_.Name -ne \'dotnet.exe\'} | Select-Object ProcessId, Name | ConvertTo-Json"')
  local result = handle:read("*a")
  handle:close()

  local target_pids = {}
  if result and result ~= "" then
    -- Decode JSON securely using Neovim's built-in decoder
    local success, decoded = pcall(vim.json.decode, result)
    if success and decoded then
      -- PowerShell returns an array if multiple exist, or a single object if only one exists
      local proc_list = (type(decoded) == "table" and decoded[1] ~= nil) and decoded or { decoded }
      for _, p in ipairs(proc_list) do
        if p.ProcessId then
          target_pids[tostring(p.ProcessId)] = true
        end
      end
    end
  end

  -- Step 2: Map the validated target processes to the UI selection menu
  for _, proc in ipairs(processes) do
    if target_pids[tostring(proc.pid)] then
      table.insert(filtered, {
        pid = proc.pid,
        name = string.format(" [PID: %s] -> %s", proc.pid, proc.name)
      })
    end
  end

  -- Fallback: If PowerShell context query returned empty, fall back to our safe string match layout
  if #filtered == 0 then
    for _, proc in ipairs(processes) do
      local name = proc.name:lower()
      if string.match(name, "webcalculationservice") or string.match(name, "hilti") then
        -- Avoid attaching to the generic dotnet host runner shell
        if name ~= "dotnet.exe" and not string.match(name, "msbuild") then
          table.insert(filtered, {
            pid = proc.pid,
            name = string.format(" [PID: %s] -> %s (Fallback)", proc.pid, proc.name)
          })
        end
      end
    end
  end

  if #filtered == 0 then
    print("No active running Hilti .NET application processes found.")
    return dap.ABORT
  end

  -- Show the clean, deduplicated selection menu
  return coroutine.create(function(co)
    vim.ui.select(filtered, {
      prompt = 'Select deduplicated .NET target process:',
      format_item = function(item) return item.name end
    }, function(choice)
      if choice then
        coroutine.resume(co, choice.pid)
      else
        coroutine.resume(co, dap.ABORT)
      end
    end)
  end)
end

dap.adapters.coreclr = {
	type = "executable",
	command = "netcoredbg",
	args = {
		"--interpreter=vscode",
	},
}

dap.configurations.cs = {
	{
		type = "coreclr",
		name = "Attach",
		request = "attach",
		-- procesId = require("dap.utils").pick_process,
		processId = pick_dotnet_process,
		justMyCode = false,
	},
	{
		type = "coreclr",
		name = "Launch - WebCalculationServices",
		request = "launch",

		program = "C:\\Users\\jure.rot\\Documents\\Agitavit\\pe\\pe-core\\src\\Facade\\Hilti.PE.Core.WebCalculationServices\\bin\\Debug\\net10.0\\Hilti.PE.Core.WebCalculationServices.dll",
		cwd = "C:\\Users\\jure.rot\\Documents\\Agitavit\\pe\\pe-core\\src\\Facade\\Hilti.PE.Core.WebCalculationServices",
		justMyCode = false,
	},
	{
		type = "coreclr",
		name = "Launch - WebServices",
		request = "launch",

		program = "C:\\Users\\jure.rot\\Documents\\Agitavit\\pe\\pe-core\\src\\Facade\\Hilti.PE.Core.WebServices\\bin\\Debug\\net10.0\\Hilti.PE.Core.WebServices.dll",
		cwd = "C:\\Users\\jure.rot\\Documents\\Agitavit\\pe\\pe-core\\src\\Facade\\Hilti.PE.Core.WebServices",
		justMyCode = false,
	},
}

vim.fn.sign_define("DapBreakpoint", {
	text = "●",
	texthl = "DiagnosticError",

})
vim.fn.sign_define("DapStopped", {
	text = "▶",
	texthl = "DiagnosticWarn",

})
vim.fn.sign_define("DapBreakpointRejected", {
	text = "○",
	texthl = "DiagnosticError",

})

dapui.setup()

dap.listeners.after.event_initialized["dapui_config"] = function()
	dapui.open()
end
dap.listeners.after.event_terminated["dapui_config"] = function()
	dapui.close()
end
dap.listeners.after.event_exited["dapui_config"] = function()
	dapui.close()
end

require("nvim-dap-virtual-text").setup({
	commented = true,
	virt_text_pos = "eol",
})

vim.keymap.set("n", "<F5>", function ()
	dap.continue()
end)
vim.keymap.set("n", "<F9>", function ()
	dap.toggle_breakpoint()
end)
vim.keymap.set("n", "<F10>", function ()
	dap.step_over()
end)
vim.keymap.set("n", "<F11>", function ()
	dap.step_into()
end)
vim.keymap.set("n", "<F12>", function ()
	dap.step_out()
end)

vim.keymap.set("n", "<leader>dr", function ()
	dap.repl.open()
end)
vim.keymap.set("n", "<leader>du", function ()
	require("dapui").toggle()
end)
