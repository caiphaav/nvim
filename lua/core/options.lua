-- General

local opt = vim.opt

opt.backspace = "2"
opt.showcmd = true
opt.laststatus = 2
opt.autowrite = true
opt.cursorline = true
opt.autoread = true

vim.cmd([[ set noswapfile ]])
vim.cmd([[ set termguicolors ]])

--Line numbers
vim.wo.number = true
opt.relativenumber = true
opt.shell = "zsh"
opt.updatetime = 100
opt.wrap = false -- No Wrap lines
opt.ignorecase = true -- Case insensitive searching UNLESS /C or capital in search
opt.smartcase = true
opt.swapfile = false

-- Tab & Indent
opt.autoindent = true
opt.smartindent = true
opt.breakindent = true
opt.softtabstop = 0
opt.expandtab = true
opt.smarttab = true
opt.tabstop = 2
opt.shiftwidth = 2
opt.signcolumn = "yes"

-- Window
opt.splitright = false
opt.splitbelow = false

-- Coding
vim.scriptencoding = "utf-8"
opt.encoding = "utf-8"
opt.fileencodings = { "utf-8", "gbk", "gb2312" }

-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.o.clipboard = "unnamedplus"

-- Highlight on yanking
local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
	callback = function()
		vim.highlight.on_yank()
	end,
	group = highlight_group,
	pattern = "*",
})
