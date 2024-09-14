local wk = require("which-key")

wk.setup({
  plugins = {
    marks = true,       -- shows a list of your marks on ' and `
    registers = true,   -- shows your registers on " in NORMAL or <C-r> in INSERT mode
    spelling = {
      enabled = false,  -- enabling this will show WhichKey when pressing z= to select spelling suggestions
      suggestions = 20, -- how many suggestions should be shown in the list?
    },
    presets = {
      operators = true,    -- adds help for operators like d, y, ...
      motions = true,      -- adds help for motions
      text_objects = true, -- help for text objects triggered after entering an operator
      windows = true,      -- default bindings on <c-w>
      nav = true,          -- misc bindings to work with windows
      z = true,            -- bindings for folds, spelling and others prefixed with z
      g = true,            -- bindings for prefixed with g
    },
  },
  operators = { gc = "Comments" },
  key_labels = {
    -- override the label used to display some keys. It doesn't effect WK in any other way.
    ["<space>"] = "SPC",
    ["<cr>"] = "RET",
    ["<tab>"] = "TAB",
  },
  icons = {
    breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
    separator = "➜", -- symbol used between a key and it's label
    group = "+", -- symbol prepended to a group
  },
  popup_mappings = {
    scroll_down = '<c-d>', -- binding to scroll down inside the popup
    scroll_up = '<c-u>',   -- binding to scroll up inside the popup
  },
  window = {
    border = "single",        -- none, single, double, shadow
    position = "bottom",      -- bottom, top
    margin = { 1, 0, 1, 0 },  -- extra window margin [top, right, bottom, left]
    padding = { 2, 2, 2, 2 }, -- extra window padding [top, right, bottom, left]
    winblend = 0
  },
  layout = {
    height = { min = 4, max = 25 },                                             -- min and max height of the columns
    width = { min = 20, max = 50 },                                             -- min and max width of the columns
    spacing = 3,                                                                -- spacing between columns
    align = "left",                                                             -- align columns left, center or right
  },
  ignore_missing = false,                                                       -- enable this to hide mappings for which you didn't specify a label
  hidden = { "<silent>", "<cmd>", "<Cmd>", "<CR>", "call", "lua", "^:", "^ " }, -- hide mapping boilerplate
  show_help = true,                                                             -- show help message on the command line when the popup is visible
  triggers = "auto",                                                            -- automatically setup triggers
  -- triggers = {"<leader>"} -- or specify a list manually
  triggers_blacklist = {
    -- list of mode / prefixes that should never be hooked by WhichKey
    -- this is mostly relevant for key maps that start with a native binding
    -- most people should not need to change this
    i = { "j", "k" },
    v = { "j", "k" },
  },
})

-- Register which-key mappings
wk.register({
  f = {
    name = "Find", -- optional group name
    f = { "<cmd>Telescope find_files<cr>", "Find File" },
    g = { "<cmd>lua require('telescope').extensions.live_grep_args.live_grep_args()<cr>", "Live Grep" },
    b = { "<cmd>Telescope buffers<cr>", "Find Buffer" },
    h = { "<cmd>Telescope help_tags<cr>", "Find Help" },
    r = { "<cmd>Telescope oldfiles<cr>", "Recent Files" },
    t = { "<cmd>lua require('telescope-config').find_files_by_type()<cr>", "Find by Type" },
  },
  g = {
    name = "Git",
    c = { "<cmd>Telescope git_commits<cr>", "Git Commits" },
    s = { "<cmd>Telescope git_status<cr>", "Git Status" },
  },
  l = {
    name = "LSP",
    d = { "<cmd>lua vim.lsp.buf.definition()<cr>", "Go to Definition" },
    D = { "<cmd>lua vim.lsp.buf.declaration()<cr>", "Go to Declaration" },
    i = { "<cmd>lua vim.lsp.buf.implementation()<cr>", "Go to Implementation" },
    r = { "<cmd>lua vim.lsp.buf.references()<cr>", "Find References" },
    R = { "<cmd>lua vim.lsp.buf.rename()<cr>", "Rename" },
    a = { "<cmd>lua vim.lsp.buf.code_action()<cr>", "Code Action" },
    f = { "<cmd>lua vim.lsp.buf.formatting()<cr>", "Format" },
  },
  u = { "<cmd>Telescope undo<cr>", "Undo History" },
  ["<leader>"] = { "<cmd>Telescope<cr>", "Telescope" },
}, { prefix = "<leader>" })

-- You can add more mappings here as needed
