local keymap = vim.keymap
local api = vim.api

-- Leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Split window
keymap.set("n", "hh", ":belowright split new<CR>", { silent = true })
keymap.set("n", "ss", ":below vsplit new<CR>", { silent = true })

-- Change window
keymap.set("", "<S-Left>", "<C-w>h")
keymap.set("", "<S-Up>", "<C-w>k")
keymap.set("", "<S-Down>", "<C-w>j")
keymap.set("", "<S-Right>", "<C-w>l")

-- Tab
keymap.set("n", "<C-n>", ":tabnew<Return>")
keymap.set("n", "<C-j>", "<cmd>BufferLineCycleNext<CR>", {})
keymap.set("n", "<C-k>", "<cmd>BufferLineCyclePrev<CR>", {})
keymap.set("n", "<C-q>", ":bd<CR>")

-- File
keymap.set("n", "<C-s>", ":wa<CR>")
keymap.set("n", "<S-s>", "<nop>")
keymap.set("n", "fq", ":q!<CR>")
keymap.set("n", "fwq", ":wqa<CR>")

-- Nvim-tree
keymap.set("n", "<F2>", ":NvimTreeFindFileToggle<CR>")
keymap.set("n", "<F1>", ":NvimTreeFocus<CR>")

--Terminal

function ToggleTerminal()
	local term_buf_exists = false
	for _, buf in ipairs(api.nvim_list_bufs()) do
		if vim.bo[buf].buftype == "terminal" then
			term_buf_exists = true
			break
		end
	end

	if term_buf_exists then
		vim.cmd("silent! bd! term://")
	else
		vim.cmd("belowright split term://zsh")

		local term_win = api.nvim_get_current_win()
		local term_buf = api.nvim_win_get_buf(term_win)
		api.nvim_buf_set_keymap(term_buf, "t", "<Esc>", "<C-\\><C-n>", { noremap = true })
	end
end

keymap.set("n", "<S-t>", ":lua ToggleTerminal()<CR>")

-- Telescope config search in ./plugins-config

-- Redo operation
keymap.set("n", "r", "<C-r>", { noremap = true, silent = true })

-- Select all
api.nvim_set_keymap("n", "<C-a>", "ggVG", { noremap = true, silent = true })

-- Save operation
-- MacOS Cmd + s Insert and Normal mode
api.nvim_set_keymap("i", "<D-s>", "<Esc>:w<CR>", { noremap = true, silent = true })
api.nvim_set_keymap("n", "<D-s>", "<Esc>:w<CR>", { noremap = true, silent = true })
