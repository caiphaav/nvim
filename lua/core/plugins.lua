require("lazy").setup({
  "tiagovla/tokyodark.nvim",
  "tpope/vim-commentary",
  "mattn/emmet-vim",
  "ThePrimeagen/harpoon",
  "nvim-telescope/telescope-live-grep-args.nvim",
  "TrevorS/uuid-nvim",
  "nvim-tree/nvim-tree.lua",
  "nvim-tree/nvim-web-devicons",
  "nvim-lualine/lualine.nvim",
  "nvim-treesitter/nvim-treesitter",
  -- copilot
  {
    "supermaven-inc/supermaven-nvim",
    config = function()
      require("supermaven-nvim").setup({})
    end,
  },
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
  "williamboman/mason.nvim",
  "williamboman/mason-lspconfig.nvim",
  "neovim/nvim-lspconfig",
  --tailwindcss
  {
    'laytan/tailwind-sorter.nvim',
    on_save_enabled = true,
    on_save_pattern = { '*.html', '*.js', '*.jsx', '*.tsx', '*.twig', '*.hbs', '*.php', '*.heex', '*.astro' },
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-lua/plenary.nvim' },
    build = 'cd formatter && npm ci && npm run build',
    config = true,
    init = function()
      vim.api.nvim_create_autocmd({ "BufWritePre" }, {
        pattern = "*.tsx, *.html, *.jsx",
        command = "TailwindSort",
      })
    end,
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
