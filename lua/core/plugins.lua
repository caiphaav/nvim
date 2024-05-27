require("lazy").setup({
	{
		"rockyzhang24/arctic.nvim",
		dependencies = { "rktjmp/lush.nvim" },
		name = "arctic",
		branch = "main",
		priority = 1000,
	},
	"tpope/vim-commentary",
	"mattn/emmet-vim",
	"ThePrimeagen/harpoon",
	"nvim-telescope/telescope-live-grep-args.nvim",
	"TrevorS/uuid-nvim",
	"nvim-tree/nvim-tree.lua",
	"nvim-tree/nvim-web-devicons",
	"nvim-lualine/lualine.nvim",
	"nvim-treesitter/nvim-treesitter",
	"github/copilot.vim",
	-- foormatter
	{
		"stevearc/conform.nvim",
		version = "5.6.0",
	},
	-- errormsg
	{
		"folke/trouble.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
	},
	-- completion
	"hrsh7th/nvim-cmp",
	"hrsh7th/cmp-nvim-lsp",
	"L3MON4D3/LuaSnip",
	"saadparwaiz1/cmp_luasnip",
	"rafamadriz/friendly-snippets",
	"github/copilot.vim",
	"williamboman/mason.nvim",
	"williamboman/mason-lspconfig.nvim",
	"neovim/nvim-lspconfig",
	--tailwindcss
	{
		"luckasRanarison/tailwind-tools.nvim",
		init = function()
			vim.api.nvim_create_autocmd({ "BufWritePre" }, {
				pattern = "*.tsx, *.html, *.js, *.jsx",
				command = "TailwindSort",
			})
		end,
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		opts = {
			sort = {
				enabled = true,
			},
		}, -- your configuration
	},
	{
		"razak17/tailwind-fold.nvim",
		opts = {},
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		ft = { "html", "svelte", "astro", "vue", "typescriptreact", "php", "blade", "javascriptreact", "twig" },
	},
	--terminal
	"akinsho/toggleterm.nvim",
	tag = "*",
	-- windows
	{
		"anuvyklack/windows.nvim",
		dependencies = {
			"anuvyklack/middleclass",
			"anuvyklack/animation.nvim",
		},
	},
	-- file tree
	{
		"kyazdani42/nvim-tree.lua", -- Nvim Tree
	},
	{
		"vinnymeller/swagger-preview.nvim",
		run = "npm install -g swagger-ui-watcher",
	},
	{
		"iamcco/markdown-preview.nvim",
		run = "cd app && npm install",
	},
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.5",
		dependencies = { "nvim-lua/plenary.nvim" },
	},
})
