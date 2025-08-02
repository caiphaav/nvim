local cmp = require("cmp")
cmp.setup({
  snippet = {
    expand = function(args)
      require("luasnip").lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<C-e>"] = cmp.mapping.abort(),
    ["<CR>"] = cmp.mapping.confirm({ select = true }),
  }),
  sources = cmp.config.sources({
    { name = "nvim_lsp" },
    { name = "luasnip" },
  }, {
    { name = "buffer" },
    { name = "path" },
  }),
})

local function lsp_keymaps(bufnr)
  local opts = { noremap = true, silent = true }
  local keymap = vim.api.nvim_buf_set_keymap
  keymap(bufnr, "n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
  keymap(bufnr, "n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
  keymap(bufnr, "n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
  keymap(bufnr, "n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
  keymap(bufnr, "n", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
  keymap(
    bufnr,
    "n",
    "<leader>rn",
    "<cmd>lua vim.lsp.buf.rename()<CR>",
    opts
  )
  keymap(
    bufnr,
    "n",
    "<leader>ca",
    "<cmd>lua vim.lsp.buf.code_action()<CR>",
    opts
  )
  keymap(bufnr, "n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
  keymap(
    bufnr,
    "n",
    "<leader>e",
    "<cmd>lua vim.diagnostic.open_float()<CR>",
    opts
  )
  keymap(bufnr, "n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<CR>", opts)
  keymap(bufnr, "n", "]d", "<cmd>lua vim.diagnostic.goto_next()<CR>", opts)
  keymap(
    bufnr,
    "n",
    "<leader>q",
    "<cmd>lua vim.diagnostic.setloclist()<CR>",
    opts
  )
  vim.cmd([[ command! Format execute 'lua vim.lsp.buf.format()' ]])
end

local on_attach = function(client, bufnr)
  vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
  lsp_keymaps(bufnr)

  -- if client.server_capabilities.documentHighlightProvider then
  --   vim.cmd([[
  --     hi LspReferenceRead cterm=underline gui=underline
  --     hi LspReferenceText cterm=underline gui=underline
  --     hi LspReferenceWrite cterm=underline gui=underline
  --     augroup lsp_document_highlight
  --       autocmd! * <buffer>
  --       autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
  --       autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
  --     augroup END
  --   ]])
  -- end
end

local capabilities = require("cmp_nvim_lsp").default_capabilities()

local servers = {
  "lua_ls",
  "gopls",
  "biome",
  "ts_ls",
  "yamlls",
  "html",
  "cssls",
  "tailwindcss",
  "pyright",
  "marksman",
  "terraformls",
  "dockerls",
  "dartls",
  "jsonls",
}

require("mason-lspconfig").setup({
  ensure_installed = servers,
})

local lspconfig = require("lspconfig")

for _, server_name in ipairs(servers) do
  local server_opts = {
    on_attach = on_attach,
    capabilities = capabilities,
  }

  if server_name == "gopls" then
    server_opts.settings = {
      gopls = {
        analyses = { unusedparams = true },
        staticcheck = true,
        gofumpt = true,
      }
    }
  end

  if server_name == "jsonls" then
    server_opts.settings = {
      json = {
        schemas = require('schemastore').json.schemas(),
        validate = {
          enable = true,
        },
        format = {
          enable = true,
        }
      }
    }
  end

  if server_name == "lua_ls" then
    server_opts.settings = {
      Lua = {
        runtime = { version = "LuaJIT" },
        diagnostics = { globals = { "vim" } },
        workspace = {
          library = vim.api.nvim_get_runtime_file("", true),
          checkThirdParty = false,
        },
      },
    }
  end

  if server_name == "pyright" then
    server_opts.settings = {
      python = {
        pythonPath = "python3",
        analysis = {
          autoSearchPaths = true,
          useLibraryCodeForTypes = true,
          diagnosticMode = "workspace",
        },
      },
    }
  end

  lspconfig[server_name].setup(server_opts)
end
