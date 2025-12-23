require("mason").setup()
require("mason-lspconfig").setup {
	--ensure_installed = { "lua_ls", "pylsp", "julials"}
	ensure_installed = { "lua_ls", "pylsp" }
}

local on_attach = function(_, _)
	vim.keymap.set("n", '<leader>rn', vim.lsp.buf.rename, {})
	vim.keymap.set("n", '<leader>ca', vim.lsp.buf.code_action, {})

	vim.keymap.set("n", 'gd', vim.lsp.buf.definition, {})
	vim.keymap.set("n", 'gi', vim.lsp.buf.implementation, {})
	vim.keymap.set("n", 'gr', require('telescope.builtin').lsp_references, {})
	vim.keymap.set("n", 'K', vim.lsp.buf.hover, {})

	vim.keymap.set("n", '<leader>sd', ":lua vim.diagnostic.open_float({focus=false, scope='cursor'})<CR>", {})

	vim.keymap.set("n", '<leader>d]', ":lua vim.diagnostic.goto_next()<CR>", {})
	vim.keymap.set("n", '<leader>d[', ":lua vim.diagnostic.goto_prev()<CR>", {})
end

local capabilities = require("cmp_nvim_lsp").default_capabilities()


-- FOR LSP CONFIGS SEE: https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md
-- https://github.com/neovim/nvim-lspconfig/blob/master/lsp/julials.lua

-- requires lua-language-server (installed separately)
vim.lsp.config('lua_ls', {
  on_init = function(client)
    if client.workspace_folders then
      local path = client.workspace_folders[1].name
      if
        path ~= vim.fn.stdpath('config')
        and (vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc'))
      then
        return
      end
    end

    client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
      runtime = {
        -- Tell the language server which version of Lua you're using (most
        -- likely LuaJIT in the case of Neovim)
        version = 'LuaJIT',
        -- Tell the language server how to find Lua modules same way as Neovim
        -- (see `:h lua-module-load`)
        path = {
          'lua/?.lua',
          'lua/?/init.lua',
        },
      },
      -- Make the server aware of Neovim runtime files
      workspace = {
        checkThirdParty = false,
        library = {
          vim.env.VIMRUNTIME,
          -- Depending on the usage, you might want to add additional paths
          -- here.
          '${3rd}/luv/library',
          -- '${3rd}/busted/library'
        }
        -- Or pull in all of 'runtimepath'.
        -- NOTE: this is a lot slower and will cause issues when working on
        -- your own configuration.
        -- See https://github.com/neovim/nvim-lspconfig/issues/3189
        -- library = {
        --   vim.api.nvim_get_runtime_file('', true),
        -- }
      }
    })
  end,
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    Lua = {}
  }
})
vim.lsp.enable('lua_ls')

-- requires python-lsp-server (installed separately using pipx)
vim.lsp.config('pylsp', {
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    pylsp = {
      plugins = {
        pycodestyle = {
          ignore = {'W391'},
          maxLineLength = 100
        }
      }
    }
  }
})
vim.lsp.enable('pylsp')


-- not installed through mason
-- requires:
--  julia --project=~/.julia/environments/nvim-lspconfig -e 'using Pkg; Pkg.add("LanguageServer"); Pkg.add("SymbolServer"); Pkg.add("StaticLint")'
-- OR  julia --project=~/.julia/environments/nvim-lspconfig -e 'using Pkg; Pkg.update()'
-- initialize project by  julia --project=/path/to/my/project -e 'using Pkg; Pkg.instantiate()'
-- and not installed through mason
-- requires to activate and init a project (requires Manifest and Project .toml files)
--  julia --project=. -e 'using Pkg; Pkg.activate("."); Pkg.instantiate()'
local root_files = { 'Project.toml', 'JuliaProject.toml' }
vim.lsp.config('julials', {
	--cmd = cmd,
	--filetypes = { "julia" },
	--root_markers = root_files,
	on_attach = on_attach,
	--on_attach = julia_on_attach,
	capabilities = capabilities
})
vim.lsp.enable('julials')
