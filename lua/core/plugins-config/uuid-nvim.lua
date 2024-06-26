local uuid = require("uuid-nvim")
uuid.setup({
	case = "lower",
	quotes = "double",
})

vim.keymap.set("n", "<leader>ut", uuid.toggle_highlighting)
vim.keymap.set("i", "<C-u>", uuid.insert_v4)
