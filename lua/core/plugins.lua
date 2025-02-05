require("lazy").setup({
  --------------------------------------------------------------------------------
  -- Core Dependencies
  --------------------------------------------------------------------------------
  { "nvim-lua/plenary.nvim",       lazy = true },
  { "nvim-tree/nvim-web-devicons", lazy = true },

  --------------------------------------------------------------------------------
  -- LSP & Language Support
  --------------------------------------------------------------------------------
  {
    "neovim/nvim-lspconfig",
    event = "VeryLazy",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
      "folke/neoconf.nvim",
      "folke/neodev.nvim",
    },
  },
  {
    "dart-lang/dart-vim-plugin",
    ft = "dart",
  },
  {
    "akinsho/flutter-tools.nvim",
    ft = "dart",
    dependencies = { "stevearc/dressing.nvim" },
    opts = {
      debugger = { enabled = true, run_via_dap = true },
      lsp = { color = { enabled = true, background = true } }
    },
  },

  --------------------------------------------------------------------------------
  -- Debugging
  --------------------------------------------------------------------------------
  {
    "mfussenegger/nvim-dap",
    config = function()
      require("dap").configurations.dart = {
        type = "dart",
        request = "launch",
        name = "Launch Flutter",
        dartSdkPath = vim.fn.expand("$HOME/flutter/bin/cache/dart-sdk/"),
        flutterSdkPath = vim.fn.expand("$HOME/flutter"),
        program = "${workspaceFolder}/lib/main.dart",
        cwd = "${workspaceFolder}",
      }
    end,
  },
  {
    "rcarriga/nvim-dap-ui",
    dependencies = {
      "mfussenegger/nvim-dap",
      "nvim-neotest/nvim-nio"
    },
  },

  --------------------------------------------------------------------------------
  -- UI & Appearance
  --------------------------------------------------------------------------------
  {
    "tiagovla/tokyodark.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd.colorscheme("tokyodark")
    end,
  },
  {
    "nvim-lualine/lualine.nvim",
    event = "UIEnter",
    opts = {
      options = { theme = "tokyodark" },
      extensions = { "neo-tree", "trouble" },
    },
  },
  {
    "goolord/alpha-nvim",
  },
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {
      lsp = { progress = { enabled = false } },
      cmdline = { view = "cmdline_popup" },
    },
  },

  --------------------------------------------------------------------------------
  -- Navigation & Files
  --------------------------------------------------------------------------------
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    commit = 'e76cb03',
    dependencies = { "nvim-lua/plenary.nvim" }
  },
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    dependencies = {
      "nvim-telescope/telescope-file-browser.nvim",
      "debugloop/telescope-undo.nvim",
      "nvim-telescope/telescope-live-grep-args.nvim",
      "nvim-lua/plenary.nvim",
    },
  },

  --------------------------------------------------------------------------------
  -- Editing & Code Actions
  --------------------------------------------------------------------------------
  {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    opts = {
      formatters_by_ft = {
        lua = { "stylua" },
        dart = { "dart_format" },
        javascript = { { "prettierd", "prettier" } },
      },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      ensure_installed = { "lua", "dart", "javascript", "typescript" },
      highlight = { enable = true },
      indent = { enable = true },
    },
  },
  {
    "Wansmer/treesj",
    keys = { "<leader>j" },
    opts = { use_default_keymaps = false },
  },
  {
    "echasnovski/mini.splitjoin",
    keys = { "gS" },
    config = true,
  },

  --------------------------------------------------------------------------------
  -- AI & Completion
  --------------------------------------------------------------------------------
  -- {
  --   "supermaven-inc/supermaven-nvim",
  --   config = function()
  --     require("supermaven-nvim").setup({
  --       keymaps = {
  --         accept_suggestion = "<Tab>",
  --         clear_suggestion = "<C-]>",
  --       },
  --     })
  --   end,
  -- },
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
      "rafamadriz/friendly-snippets",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "hrsh7th/cmp-nvim-lsp-signature-help",
    },
  },

  --------------------------------------------------------------------------------
  -- Language-Specific Enhancements
  --------------------------------------------------------------------------------
  {
    "ray-x/go.nvim",
    ft = "go",
    dependencies = "ray-x/guihua.lua",
    config = function()
      require("go").setup({ lsp_cfg = false })
    end,
  },
  {
    "b0o/SchemaStore.nvim",
    ft = { "json", "yaml" },
  },
  {
    "pmizio/typescript-tools.nvim",
    ft = "typescript",
    opts = { tsserver_plugins = { "styled-components" } },
  },
  {
    "luckasRanarison/tailwind-tools.nvim",
    dependencies = "nvim-treesitter/nvim-treesitter",
    opts = {
      document_color = {
        enabled = true,
        highlight = { background = true },
      }
    },
  },

  --------------------------------------------------------------------------------
  -- Utilities
  --------------------------------------------------------------------------------
  {
    "folke/trouble.nvim",
    cmd = "Trouble",
    opts = { use_diagnostic_signs = true },
  },
  {
    "axkirillov/hbac.nvim",
    event = "BufAdd",
    config = true,
  },
  {
    "echasnovski/mini.bufremove",
    keys = { "<C-q>", "<leader>bd" },
    config = true,
  },
  {
    "ziontee113/syntax-tree-surfer",
    keys = { "vu", "vd" },
  },
  {
    "mbbill/undotree",
    keys = "<leader>u",
  },
  -- Smooth scrolling
  {
    "declancm/cinnamon.nvim",
    config = function()
      require("cinnamon").setup({
        keymaps = {
          extra = true,
          basic = true
        }
      })
    end,
  }
})
