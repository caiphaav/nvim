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
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim", "neovim/nvim-lspconfig" },
    config = function()
      require("mason-lspconfig").setup()
    end,
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "hrsh7th/cmp-nvim-lsp",
    },
    -- The main configuration will go here (see Step 2)
  },
  -- Autocompletion Engine (Highly Recommended)
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "L3MON4D3/LuaSnip",         -- Optional, for snippets
      "saadparwaiz1/cmp_luasnip", -- Optional, for snippets
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
  { "rebelot/kanagawa.nvim", priority = 1000 },
  {
    "nvim-lualine/lualine.nvim",
    event = "UIEnter",
    opts = {
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
  -- Git integration
  --------------------------------------------------------------------------------
  {
    'sindrets/diffview.nvim',
    dependencies = 'nvim-lua/plenary.nvim',
    config = function()
      local actions = require("diffview.actions")
      require('diffview').setup({
        enhanced_diff_hl = true,
        icons = {
          folder_closed = "📁",
          folder_open = "📂",
        },
        signs = {
          fold_closed = "▶",
          fold_open = "▼",
          done = "✓",
        },
        view = {
          default = { layout = "diff2_horizontal" },
          merge_tool = { layout = "diff3_horizontal", disable_diagnostics = true },
        },
        keymaps = {
          disable_defaults = false,
          view = {
            { { "n", "v" }, "o", actions.conflict_choose("ours"),   { desc = "Choose Ours", nowait = true } },
            { { "n", "v" }, "t", actions.conflict_choose("theirs"), { desc = "Choose Theirs", nowait = true } },
            { { "n", "v" }, "b", actions.conflict_choose("base"),   { desc = "Choose Base", nowait = true } },
            { { "n", "v" }, "a", actions.conflict_choose("all"),    { desc = "Choose All", nowait = true } },
          },
          merge_tool = {
            { { "n", "v" }, "o", actions.conflict_choose("ours"),   { desc = "Choose Ours", nowait = true } },
            { { "n", "v" }, "t", actions.conflict_choose("theirs"), { desc = "Choose Theirs", nowait = true } },
            { { "n", "v" }, "b", actions.conflict_choose("base"),   { desc = "Choose Base", nowait = true } },
            { { "n", "v" }, "a", actions.conflict_choose("all"),    { desc = "Choose All", nowait = true } },
          },
        },
      })
    end,
  },
  {
    "lewis6991/gitsigns.nvim",
    event = "BufReadPre",
    config = function()
      require("gitsigns").setup({
        signs = {
          add = { text = "+" },
          change = { text = "~" },
          delete = { text = "_" },
          topdelete = { text = "‾" },
          changedelete = { text = "~" },
        },
        on_attach = function(bufnr)
          local gs = package.loaded.gitsigns

          -- Git blame shortcut
          vim.keymap.set("n", "<leader>gb", function()
            gs.blame_line({ full = true }) -- Show full blame info
          end, { buffer = bufnr, desc = "Git blame line" })
          vim.keymap.set("n", "gb", function()
            gs.toggle_current_line_blame() -- Toggle blame
          end, { buffer = bufnr, desc = "Git blame toggle" })


          -- Navigation between hunks
          vim.keymap.set("n", "]c", function()
            if vim.wo.diff then return "]c" end
            vim.schedule(function() gs.next_hunk() end)
            return "<Ignore>"
          end, { buffer = bufnr, expr = true, desc = "Next hunk" })

          vim.keymap.set("n", "[c", function()
            if vim.wo.diff then return "[c" end
            vim.schedule(function() gs.prev_hunk() end)
            return "<Ignore>"
          end, { buffer = bufnr, expr = true, desc = "Previous hunk" })

          -- Stage/reset hunks
          vim.keymap.set("n", "<leader>gs", gs.stage_hunk, { buffer = bufnr, desc = "Stage hunk" })
          vim.keymap.set("n", "<leader>gr", gs.reset_hunk, { buffer = bufnr, desc = "Reset hunk" })

          -- Preview hunk changes
          vim.keymap.set("n", "<leader>gp", gs.preview_hunk, { buffer = bufnr, desc = "Preview hunk" })
        end,
      })
    end,
  },

  --------------------------------------------------------------------------------
  -- Editing & Code Actions
  --------------------------------------------------------------------------------
  {
    "stevearc/conform.nvim",
    event = "BufWritePre",
  },
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
    },
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
    name = "tailwind-tools",
    build = ":UpdateRemotePlugins",
    dependencies = {
      "neovim/nvim-lspconfig", -- optional
    }
  },
  'WhoIsSethDaniel/mason-tool-installer.nvim',
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
})
