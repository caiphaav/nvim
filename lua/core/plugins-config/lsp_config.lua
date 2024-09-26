local mason_lspconfig = require("mason-lspconfig")
local lspconfig = require("lspconfig")
local cmp_nvim_lsp = require("cmp_nvim_lsp")

-- List of servers to install and configure
local servers = {
  "lua_ls",
  "tsserver",
  "tailwindcss",
  "gopls",
  "ast_grep",
  "dartls",
  "html",
  "cssls",
  "intelephense",
  "sqlls",
  "terraformls",
  "biome",
  "zls",
}

mason_lspconfig.setup({
  ensure_installed = servers,
  automatic_installation = true,
})

-- Function to switch to the previous file
local function switch_to_previous_file()
  local current_buf = vim.api.nvim_get_current_buf()
  local alternate_buf = vim.fn.bufnr('#')

  if alternate_buf ~= -1 and alternate_buf ~= current_buf then
    vim.api.nvim_set_current_buf(alternate_buf)
  else
    print("No previous file to switch to")
  end
end

-- Generic LSP settings
local lsp_defaults = {
  flags = {
    debounce_text_changes = 150,
  },
  capabilities = cmp_nvim_lsp.default_capabilities(
    vim.lsp.protocol.make_client_capabilities()
  ),
  on_attach = function(client, bufnr)
    -- Enable completion triggered by <c-x><c-o>
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

    -- Keybindings for LSP
    local opts = { noremap = true, silent = true, buffer = bufnr }
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, vim.tbl_extend("force", opts, { desc = "Go to definition" }))
    vim.keymap.set("n", "gh", vim.lsp.buf.hover, vim.tbl_extend("force", opts, { desc = "Show hover information" }))
    vim.keymap.set("n", "gi", vim.lsp.buf.implementation,
      vim.tbl_extend("force", opts, { desc = "Go to implementation" }))
    vim.keymap.set("n", "<space>wa", vim.lsp.buf.add_workspace_folder,
      vim.tbl_extend("force", opts, { desc = "Add workspace folder" }))
    vim.keymap.set("n", "<space>wr", vim.lsp.buf.remove_workspace_folder,
      vim.tbl_extend("force", opts, { desc = "Remove workspace folder" }))
    vim.keymap.set("n", "<space>wl", function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, vim.tbl_extend("force", opts, { desc = "List workspace folders" }))
    vim.keymap.set("n", "<space>D", vim.lsp.buf.type_definition,
      vim.tbl_extend("force", opts, { desc = "Go to type definition" }))
    vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, vim.tbl_extend("force", opts, { desc = "Rename symbol" }))
    vim.keymap.set({ "n", "v" }, "<space>ca", vim.lsp.buf.code_action,
      vim.tbl_extend("force", opts, { desc = "Code action" }))
    vim.keymap.set("n", "gr", vim.lsp.buf.references, vim.tbl_extend("force", opts, { desc = "Find references" }))
    vim.keymap.set("n", "<space>f", function()
      vim.lsp.buf.format({ async = true })
    end, vim.tbl_extend("force", opts, { desc = "Format buffer" }))
    -- Add keybinding for switching to the previous file
    vim.keymap.set("n", "<C-p>", switch_to_previous_file,
      vim.tbl_extend("force", opts, { desc = "Switch to previous file" }))
  end
}

-- Merge user-defined lsp_defaults with the default capabilities
lspconfig.util.default_config = vim.tbl_deep_extend(
  "force",
  lspconfig.util.default_config,
  lsp_defaults
)

-- Server-specific settings
local server_settings = {
  lua_ls = {
    settings = {
      Lua = {
        diagnostics = {
          globals = { "vim" },
        },
        workspace = {
          library = {
            [vim.fn.expand("$VIMRUNTIME/lua")] = true,
            [vim.fn.stdpath("config") .. "/lua"] = true,
          },
        },
      },
    },
  },
  -- Add other server-specific settings here
}

-- Set up each server
for _, server in ipairs(servers) do
  local opts = server_settings[server] or {}
  opts = vim.tbl_deep_extend("force", lsp_defaults, opts)
  lspconfig[server].setup(opts)
end

-- Additional auto-commands or settings can be added here
