-- dap.lua (Simple Dart/Flutter only)
local dap = require("dap")
local dapui = require("dapui")

-- Simple DAP UI setup
dapui.setup({
  layouts = {
    {
      elements = {
        { id = "scopes",      size = 0.25 },
        { id = "breakpoints", size = 0.25 },
        { id = "stacks",      size = 0.25 },
        { id = "watches",     size = 0.25 },
      },
      size = 40,
      position = "left",
    },
    {
      elements = {
        { id = "repl",    size = 0.5 },
        { id = "console", size = 0.5 },
      },
      size = 0.25,
      position = "bottom",
    },
  },
})

-- Dart adapter
dap.adapters.dart = {
  type = "executable",
  command = "dart",
  args = { "debug_adapter" }
}

-- Flutter adapter (same as dart but with flutter command)
dap.adapters.flutter = {
  type = "executable",
  command = "flutter",
  args = { "debug_adapter" }
}

-- Dart configurations
dap.configurations.dart = {
  {
    type = "dart",
    request = "launch",
    name = "Launch Dart",
    program = "${file}",
    cwd = "${workspaceFolder}",
  },
  {
    type = "flutter",
    request = "launch",
    name = "Launch Flutter (Debug)",
    program = "${workspaceFolder}/lib/main.dart",
    cwd = "${workspaceFolder}",
  },
  {
    type = "flutter",
    request = "launch",
    name = "Launch Flutter (Profile)",
    program = "${workspaceFolder}/lib/main.dart",
    cwd = "${workspaceFolder}",
    args = { "--profile" }
  },
}

-- Simple keymaps
vim.keymap.set('n', '<F5>', dap.continue, { desc = "Debug: Continue" })
vim.keymap.set('n', '<F10>', dap.step_over, { desc = "Debug: Step Over" })
vim.keymap.set('n', '<F11>', dap.step_into, { desc = "Debug: Step Into" })
vim.keymap.set('n', '<F12>', dap.step_out, { desc = "Debug: Step Out" })
vim.keymap.set('n', '<leader>b', dap.toggle_breakpoint, { desc = "Debug: Toggle Breakpoint" })
vim.keymap.set('n', '<leader>du', dapui.toggle, { desc = "Debug: Toggle UI" })
vim.keymap.set('n', '<leader>dt', dap.terminate, { desc = "Debug: Terminate" })

-- Auto open/close UI
dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open()
end

dap.listeners.before.event_terminated["dapui_config"] = function()
  dapui.close()
end

dap.listeners.before.event_exited["dapui_config"] = function()
  dapui.close()
end

return {}
