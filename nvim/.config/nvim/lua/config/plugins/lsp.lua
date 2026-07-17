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

-- lisp
--[[
vim.lsp.config("cl-lsp", {
	cmd = { "cl-lsp" },
	filetypes = { "lisp" },
	root_markers = { ".git", "*.asd", "package.lisp" },
})
--]]

-- alive lsp (for common lisp)
--[[
vim.lsp.config('alive_lsp', {
  default_config = {
    cmd = {
      "sbcl", "--noinform", "--non-interactive",
      "--eval", "(ql:quickload :alive-lsp)",
      "--eval", "(alive-lsp:start)"
    },
    filetypes = { "lisp" },
	root_markers = { ".git", "*.asd", "package.lisp", vim.fn.getcwd() },
  }
})
--]]

-- not installed through mason
-- requires:
--  julia --project=~/.julia/environments/nvim-lspconfig -e 'using Pkg; Pkg.add("LanguageServer"); Pkg.add("SymbolServer"); Pkg.add("StaticLint")'
-- OR  julia --project=~/.julia/environments/nvim-lspconfig -e 'using Pkg; Pkg.update()'
-- initialize project by  julia --project=/path/to/my/project -e 'using Pkg; Pkg.instantiate()'
-- and not installed through mason
-- requires to activate and init a project (requires Manifest and Project .toml files)
--  julia --project=. -e 'using Pkg; Pkg.activate("."); Pkg.instantiate()' (need to run twice) (maybe)
-- alternative: julia -e 'using Pkg; Pkg.generate("<project_name>"); Pkg.activate("<project_name>"); Pkg.add("Example"); Pkg.instantiate()'
-- local julia_root_files = { "Project.toml", "JuliaProject.toml" }
vim.lsp.config("julials", {
})

vim.lsp.enable({
	"lua_ls",
	"pylsp",
	"julials",
	--"roslyn_ls", -- handled by roslyn.nvim
	--"cl-lsp",
	--"alive_lsp",
})


-- roslyn.nvim
vim.keymap.set("n", "<leader>ct", ":Roslyn target<CR>", { desc = "Choose Roslyn targe"})
