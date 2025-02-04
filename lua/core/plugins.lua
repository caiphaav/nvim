require("lazy").setup({
  "tiagovla/tokyodark.nvim",
  "tpope/vim-commentary",
  "mattn/emmet-vim",
  "ThePrimeagen/harpoon",
  "nvim-lualine/lualine.nvim",
  "nvim-treesitter/nvim-treesitter",
  -- dart & flutter
  {
    "dart-lang/dart-vim-plugin",
    ft = "dart",
  },
  {
    "akinsho/flutter-tools.nvim",
    lazy = false,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "stevearc/dressing.nvim",
    },
    config = function()
      require("flutter-tools").setup({
        debugger = {
          enabled = true,
          run_via_dap = true,
        },
        outline = { auto_open = false },
        dev_log = { auto_open = false },
        lsp = {
          color = {
            enabled = true,
            background = true,
          },
          settings = {
            showTodos = true,
            renameFilesWithClasses = "prompt",
          },
        },
      })
    end,
  },
  {
    "mfussenegger/nvim-dap",
    config = function()
      local dap = require("dap")
      dap.configurations.dart = {
        {
          type = "dart",
          request = "launch",
          name = "Launch Flutter",
          dartSdkPath = vim.fn.expand("$HOME/flutter/bin/cache/dart-sdk/"),
          flutterSdkPath = vim.fn.expand("$HOME/flutter"),
          program = "${workspaceFolder}/lib/main.dart",
          cwd = "${workspaceFolder}",
        }
      }
    end,
  },
  -- copilot
  -- {
  --   "supermaven-inc/supermaven-nvim",
  --   config = function()
  --     require("supermaven-nvim").setup({})
  --   end,
  -- },
  -- initial screen
  {
    "goolord/alpha-nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require 'alpha'.setup(require 'alpha.themes.dashboard'.config)
    end
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
  "williamboman/mason.nvim",
  "williamboman/mason-lspconfig.nvim",
  "neovim/nvim-lspconfig",
  --tailwindcss
  {
    "laytan/tailwind-sorter.nvim",
    on_save_enabled = true,
    on_save_pattern = { "*.html", "*.js", "*.jsx", "*.tsx", "*.twig", "*.hbs", "*.php", "*.heex", "*.astro" },
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-lua/plenary.nvim" },
    build = "cd formatter && npm ci && npm run build",
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
  -- windows
  {
    "anuvyklack/windows.nvim",
    dependencies = {
      "anuvyklack/middleclass",
      "anuvyklack/animation.nvim",
    },
  },
  {
    "iamcco/markdown-preview.nvim",
    run = "cd app && npm install",
  },
  -- telescope
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.5",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "debugloop/telescope-undo.nvim",
      "nvim-telescope/telescope-file-browser.nvim",
      "nvim-telescope/telescope-live-grep-args.nvim"
    },
  },
})
