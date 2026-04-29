-- nvim-dap
-- debugger
vim.pack.add({
  "https://github.com/jbyuki/one-small-step-for-vimkind",
  "https://github.com/mfussenegger/nvim-dap",
})

-- nvim-dap-ui
-- UI for nvim-dap
vim.pack.add({
  "https://github.com/mfussenegger/nvim-dap",
  "https://github.com/nvim-neotest/nvim-nio",
  "https://github.com/rcarriga/nvim-dap-ui",
})

require("dapui").setup()

local dap = require("dap")
local dapui = require("dapui")

dap.configurations.lua = {
  {
    type = "nlua",
    request = "attach",
    name = "Attach to running Neovim instance",
  },
}

dap.adapters.nlua = function(callback, config)
  callback({ type = "server", host = config.host or "127.0.0.1", port = config.port or 8086 })
end

-- dap.defaults.fallback.terminal_win_cmd = "tabnew"
dap.defaults.fallback.step_over_external_code = true

dap.listeners.before.attach.dapui_config = function()
  dapui.open()
end
dap.listeners.before.launch.dapui_config = function()
  dapui.open()
end
dap.listeners.before.event_terminated.dapui_config = function()
  dapui.close()
end
dap.listeners.before.event_exited.dapui_config = function()
  dapui.close()
end

vim.keymap.set("n", "<Leader>dat", function()
  dapui.toggle()
end)

vim.keymap.set("n", "<leader>dal", function()
  require("osv").launch({ port = 8086, delay_frozen = 100 })
end, { noremap = true })

vim.keymap.set("n", "<leader>daw", function()
  local widgets = require("dap.ui.widgets")
  widgets.hover()
end)

vim.keymap.set("n", "<leader>daf", function()
  local widgets = require("dap.ui.widgets")
  widgets.centered_float(widgets.frames)
end)
