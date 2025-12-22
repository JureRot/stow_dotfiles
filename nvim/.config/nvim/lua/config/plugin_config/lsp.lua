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
local root_files = { 'Project.toml', 'JuliaProject.toml' }

local function activate_env(path)
  assert(vim.fn.has 'nvim-0.10' == 1, 'requires Nvim 0.10 or newer')
  local bufnr = vim.api.nvim_get_current_buf()
  local julials_clients = vim.lsp.get_clients { bufnr = bufnr, name = 'julials' }
  assert(
    #julials_clients > 0,
    'method julia/activateenvironment is not supported by any servers active on the current buffer'
  )
  local function _activate_env(environment)
    if environment then
      for _, julials_client in ipairs(julials_clients) do
        ---@diagnostic disable-next-line: param-type-mismatch
        julials_client:notify('julia/activateenvironment', { envPath = environment })
      end
      vim.notify('Julia environment activated: \n`' .. environment .. '`', vim.log.levels.INFO)
    end
  end
  if path then
    path = vim.fs.normalize(vim.fn.fnamemodify(vim.fn.expand(path), ':p'))
    local found_env = false
    for _, project_file in ipairs(root_files) do
      local file = vim.uv.fs_stat(vim.fs.joinpath(path, project_file))
      if file and file.type then
        found_env = true
        break
      end
    end
    if not found_env then
      vim.notify('Path is not a julia environment: \n`' .. path .. '`', vim.log.levels.WARN)
      return
    end
    _activate_env(path)
  else
    local depot_paths = vim.env.JULIA_DEPOT_PATH
        and vim.split(vim.env.JULIA_DEPOT_PATH, vim.fn.has 'win32' == 1 and ';' or ':')
      or { vim.fn.expand '~/.julia' }
    local environments = {}
    vim.list_extend(environments, vim.fs.find(root_files, { type = 'file', upward = true, limit = math.huge }))
    for _, depot_path in ipairs(depot_paths) do
      local depot_env = vim.fs.joinpath(vim.fs.normalize(depot_path), 'environments')
      vim.list_extend(
        environments,
        vim.fs.find(function(name, env_path)
          return vim.tbl_contains(root_files, name) and string.sub(env_path, #depot_env + 1):match '^/[^/]*$'
        end, { path = depot_env, type = 'file', limit = math.huge })
      )
    end
    environments = vim.tbl_map(vim.fs.dirname, environments)
    vim.ui.select(environments, { prompt = 'Select a Julia environment' }, _activate_env)
  end
end

local cmd = {
  'julia',
  '--startup-file=no',
  '--history-file=no',
  '-e',
  [[
    # Load LanguageServer.jl: attempt to load from ~/.julia/environments/nvim-lspconfig
    # with the regular load path as a fallback
    ls_install_path = joinpath(
        get(DEPOT_PATH, 1, joinpath(homedir(), ".julia")),
        "environments", "nvim-lspconfig"
    )
    pushfirst!(LOAD_PATH, ls_install_path)
    using LanguageServer, SymbolServer, StaticLint
    popfirst!(LOAD_PATH)
    depot_path = get(ENV, "JULIA_DEPOT_PATH", "")
    project_path = let
        dirname(something(
            ## 1. Finds an explicitly set project (JULIA_PROJECT)
            Base.load_path_expand((
                p = get(ENV, "JULIA_PROJECT", nothing);
                p === nothing ? nothing : isempty(p) ? nothing : p
            )),
            ## 2. Look for a Project.toml file in the current working directory,
            ##    or parent directories, with $HOME as an upper boundary
            Base.current_project(),
            ## 3. First entry in the load path
            get(Base.load_path(), 1, nothing),
            ## 4. Fallback to default global environment,
            ##    this is more or less unreachable
            Base.load_path_expand("@v#.#"),
        ))
    end
    @info "Running language server" VERSION pwd() project_path depot_path
    server = LanguageServer.LanguageServerInstance(stdin, stdout, project_path, depot_path)
    server.runlinter = true
    run(server)
  ]],
}

local function julia_on_attach(_, bufnr)
	vim.api.nvim_buf_create_user_command(bufnr, 'LspJuliaActivateEnv', activate_env, {
		desc = 'Activate a Julia environment',
		nargs = '?',
		complete = 'file',
	})
end

vim.lsp.config('julials', {
	cmd = cmd,
	filtypes = { "julia" },
	root_markers = root_files,
	--on_attach = on_attach,
	on_attach = julia_on_attach,
	capabilities = capabilities
})
vim.lsp.enable('julials')
