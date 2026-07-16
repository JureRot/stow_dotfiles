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
