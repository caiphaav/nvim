-- lsp.lua
local mason = require("mason")
local mason_lspconfig = require("mason-lspconfig")
local mason_tool_installer = require("mason-tool-installer")
local lspconfig = require("lspconfig")
local cmp_nvim_lsp = require("cmp_nvim_lsp")

-- Mason setup
mason.setup({
  ui = {
    icons = {
      package_installed = "✓",
      package_pending = "➜",
      package_uninstalled = "✗"
    }
  }
})

-- LSP servers for your languages
local servers = {
  "ts_ls",       -- TypeScript/JavaScript
  "biome",       -- Modern JS/TS linter/formatter
  "gopls",       -- Go
  "dartls",      -- Dart/Flutter
  "tailwindcss", -- Tailwind CSS (useful for web projects)
  "html",        -- HTML
  "cssls",       -- CSS
  "jsonls",      -- JSON
}

-- Additional tools for debugging and formatting
local tools = {
  -- Debuggers
  "js-debug-adapter",   -- JavaScript/TypeScript debugger
  "delve",              -- Go debugger
  "dart-debug-adapter", -- Dart debugger

  -- Formatters & Linters
  "gofumpt",       -- Go formatter
  "golangci-lint", -- Go linter
  "gomodifytags",  -- Go struct tags
  "gotests",       -- Go test generator
  "impl",          -- Go interface implementation
}

mason_lspconfig.setup({
  ensure_installed = servers,
  automatic_installation = true,
})

mason_tool_installer.setup({
  ensure_installed = tools,
  auto_update = false,
  run_on_start = true,
})

-- Enhanced capabilities
local capabilities = vim.tbl_deep_extend(
  "force",
  cmp_nvim_lsp.default_capabilities(),
  {
    textDocument = {
      foldingRange = {
        dynamicRegistration = false,
        lineFoldingOnly = true
      },
      documentHighlight = {
        dynamicRegistration = false
      },
      inlayHint = {
        dynamicRegistration = true,
      },
    },
    workspace = {
      workspaceFolders = true,
      didChangeWatchedFiles = {
        dynamicRegistration = true,
      },
    }
  }
)

-- Utility functions
local function toggle_inlay_hints()
  local bufnr = vim.api.nvim_get_current_buf()
  vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }), { bufnr = bufnr })
end

-- Enhanced on_attach function
local on_attach = function(client, bufnr)
  -- Enable omnifunc
  vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

  -- Enable inlay hints if supported
  if client.supports_method("textDocument/inlayHint") then
    vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
  end

  -- Buffer-local keymap helper
  local function keymap(mode, lhs, rhs, desc)
    vim.keymap.set(mode, lhs, rhs, {
      buffer = bufnr,
      desc = desc,
      noremap = true,
      silent = true,
    })
  end

  -- Navigation
  keymap("n", "gd", vim.lsp.buf.definition, "Go to definition")
  keymap("n", "gD", vim.lsp.buf.declaration, "Go to declaration")
  keymap("n", "gr", vim.lsp.buf.references, "Find references")
  keymap("n", "gi", vim.lsp.buf.implementation, "Go to implementation")
  keymap("n", "gt", vim.lsp.buf.type_definition, "Go to type definition")

  -- Documentation
  keymap("n", "K", vim.lsp.buf.hover, "Show hover documentation")
  keymap("n", "<C-k>", vim.lsp.buf.signature_help, "Show signature help")
  keymap("i", "<C-k>", vim.lsp.buf.signature_help, "Show signature help")

  -- Code actions
  keymap("n", "<leader>ca", vim.lsp.buf.code_action, "Code actions")
  keymap("v", "<leader>ca", vim.lsp.buf.code_action, "Code actions")
  keymap("n", "<leader>rn", vim.lsp.buf.rename, "Rename symbol")

  -- Formatting
  keymap("n", "<leader>f", function()
    vim.lsp.buf.format({
      async = true,
      timeout_ms = 10000,
      filter = function(format_client)
        -- Prefer Biome for JS/TS files
        if vim.bo.filetype == "javascript" or vim.bo.filetype == "typescript"
            or vim.bo.filetype == "javascriptreact" or vim.bo.filetype == "typescriptreact" then
          return format_client.name == "biome"
        end
        return true
      end
    })
  end, "Format buffer")
end

-- Server-specific configurations
local server_configs = {
  ts_ls = {
    settings = {
      typescript = {
        inlayHints = {
          includeInlayParameterNameHints = "all",
          includeInlayParameterNameHintsWhenArgumentMatchesName = true,
          includeInlayFunctionParameterTypeHints = true,
          includeInlayVariableTypeHints = true,
          includeInlayPropertyDeclarationTypeHints = true,
          includeInlayFunctionLikeReturnTypeHints = true,
          includeInlayEnumMemberValueHints = true,
        },
        suggest = {
          includeCompletionsForModuleExports = true,
        },
        preferences = {
          includePackageJsonAutoImports = "auto",
        },
      },
      javascript = {
        inlayHints = {
          includeInlayParameterNameHints = "all",
          includeInlayParameterNameHintsWhenArgumentMatchesName = true,
          includeInlayFunctionParameterTypeHints = true,
          includeInlayVariableTypeHints = true,
          includeInlayPropertyDeclarationTypeHints = true,
          includeInlayFunctionLikeReturnTypeHints = true,
          includeInlayEnumMemberValueHints = true,
        },
        suggest = {
          includeCompletionsForModuleExports = true,
        },
      },
    },
  },

  biome = {
    filetypes = {
      "javascript",
      "javascriptreact",
      "typescript",
      "typescriptreact",
      "json",
      "jsonc"
    },
    single_file_support = true,
    settings = {
      biome = {
        formatter = {
          enabled = true,
          formatOnSave = true,
        },
        linter = {
          enabled = true,
        },
      },
    },
  },

  gopls = {
    settings = {
      gopls = {
        analyses = {
          fieldalignment = true,
          nilness = true,
          unusedparams = true,
          unusedresults = true,
          unusedwrite = true,
          useany = true,
          shadow = true,
          -- Concurrency & Resource Leaks
          loopclosure = true,
          lostcancel = true,
          httpresponse = true,
          copylocks = true,
          -- Correctness & Bug Prevention
          printf = true,
          unreachable = true,
          unmarshal = true,
        },
        staticcheck = true,
        gofumpt = true,
        completeUnimported = true,
        usePlaceholders = true,
        matcher = "Fuzzy",
        symbolMatcher = "fuzzy",
        buildFlags = { "-tags", "integration" },
        hints = {
          assignVariableTypes = true,
          compositeLiteralFields = true,
          compositeLiteralTypes = true,
          constantValues = true,
          functionTypeParameters = true,
          parameterNames = true,
          rangeVariableTypes = true,
        },
        codelenses = {
          gc_details = true,
          generate = true,
          regenerate_cgo = true,
          test = true,
          tidy = true,
          upgrade_dependency = true,
          vendor = true,
        },
      },
    },
    on_attach = function(client, bufnr)
      on_attach(client, bufnr)

      -- Go-specific keymaps
      local function go_keymap(mode, lhs, rhs, desc)
        vim.keymap.set(mode, lhs, rhs, {
          buffer = bufnr,
          desc = desc,
          noremap = true,
          silent = true,
        })
      end

      go_keymap("n", "<leader>gt", ":GoTest<CR>", "Run Go tests")
      go_keymap("n", "<leader>gf", ":GoTestFunc<CR>", "Run Go test function")
      go_keymap("n", "<leader>gc", ":GoCoverage<CR>", "Show Go coverage")
      go_keymap("n", "<leader>gi", ":GoImpl<CR>", "Implement interface")
      go_keymap("n", "<leader>gat", ":GoAddTags<CR>", "Add struct tags")
      go_keymap("n", "<leader>grt", ":GoRemoveTags<CR>", "Remove struct tags")
    end,
  },

  dartls = {
    cmd = { "dart", "language-server", "--protocol=lsp" },
    filetypes = { "dart" },
    init_options = {
      onlyAnalyzeProjectsWithOpenFiles = false,
      suggestFromUnimportedLibraries = true,
      closingLabels = true,
      outline = true,
      flutterOutline = true,
    },
    settings = {
      dart = {
        completeFunctionCalls = true,
        showTodos = true,
        enableSnippets = true,
        updateImportsOnRename = true,
      },
    },
    on_attach = function(client, bufnr)
      on_attach(client, bufnr)

      -- Dart/Flutter specific keymaps
      local function dart_keymap(mode, lhs, rhs, desc)
        vim.keymap.set(mode, lhs, rhs, {
          buffer = bufnr,
          desc = desc,
          noremap = true,
          silent = true,
        })
      end

      dart_keymap("n", "<leader>fr", ":FlutterRun<CR>", "Flutter run")
      dart_keymap("n", "<leader>fr", ":FlutterReload<CR>", "Flutter hot reload")
      dart_keymap("n", "<leader>fR", ":FlutterRestart<CR>", "Flutter hot restart")
    end,
  },

  tailwindcss = {
    filetypes = {
      "html", "css", "scss", "javascript", "javascriptreact",
      "typescript", "typescriptreact", "vue", "svelte"
    },
    settings = {
      tailwindCSS = {
        experimental = {
          classRegex = {
            "tw`([^`]*)",
            "tw=\"([^\"]*)",
            "tw={\"([^\"}]*)",
            "tw\\.\\w+`([^`]*)",
            "tw\\(.*?\\)`([^`]*)",
          },
        },
      },
    },
  },

  jsonls = {
    settings = {
      json = {
        schemas = require('schemastore').json.schemas(),
        validate = { enable = true },
      },
    },
  },
}

-- Setup servers manually
for _, server_name in ipairs(servers) do
  local config = vim.tbl_deep_extend("force", {
    capabilities = capabilities,
    on_attach = on_attach,
    flags = {
      debounce_text_changes = 150,
    },
  }, server_configs[server_name] or {})

  lspconfig[server_name].setup(config)
end

-- Diagnostic configuration
vim.diagnostic.config({
  virtual_text = {
    prefix = "●",
    spacing = 2,
  },
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
  float = {
    focusable = false,
    style = "minimal",
    border = "rounded",
    source = "always",
    header = "",
    prefix = "",
  },
})

-- Diagnostic signs
local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

-- LSP UI customization
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
  border = "rounded",
})

vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
  border = "rounded",
})

-- Auto commands for LSP
local lsp_group = vim.api.nvim_create_augroup("LspConfig", { clear = true })

-- Highlight symbol under cursor
vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
  group = lsp_group,
  callback = function()
    vim.lsp.buf.document_highlight()
  end,
})

vim.api.nvim_create_autocmd("CursorMoved", {
  group = lsp_group,
  callback = function()
    vim.lsp.buf.clear_references()
  end,
})

-- Format on save for specific filetypes
vim.api.nvim_create_autocmd("BufWritePre", {
  group = lsp_group,
  pattern = { "*.go", "*.ts", "*.js", "*.tsx", "*.jsx", "*.dart" },
  callback = function()
    vim.lsp.buf.format({ timeout_ms = 2000 })
  end,
})

return {}
