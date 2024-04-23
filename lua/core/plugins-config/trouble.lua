local map = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

map("n", "<leader>to", "<cmd>lua require('trouble').open()<cr>", opts)

map("n", "<leader>tt", "<cmd>lua require('trouble').toggle()<cr>", opts)

map("n", "<leader>tc", "<cmd>lua require('trouble').close()<cr>", opts)
