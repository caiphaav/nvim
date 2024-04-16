require("nvim-treesitter.configs").setup({
	-- A list of parser names, or "all"
	ensure_installed = {
		"c",
		"lua",
		"php",
		"go",
		"vim",
		"html",
		"javascript",
		"typescript",
		"css",
		"json",
		"markdown",
		"yaml",
		"dockerfile",
		"graphql",
		"gitignore",
		"dart",
		"scss",
	},

	-- Install parsers synchronously (only applied to `ensure_installed`)
	sync_install = false,
	auto_install = true,
	highlight = {
		enable = true,
	},
	indent = {
		enable = true,
	},
})
