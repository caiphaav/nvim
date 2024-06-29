local api = vim.api
local map = api.nvim_set_keymap
local opts = { noremap = true, silent = true }

-- Trouble mappings
map("n", "<leader>tt", "<cmd>lua require('trouble').toggle({mode='diagnostics'})<cr>", opts)
