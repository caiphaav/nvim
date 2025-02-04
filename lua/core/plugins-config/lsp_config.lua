local mason_lspconfig = require("mason-lspconfig")
local lspconfig = require("lspconfig")
local cmp_nvim_lsp = require("cmp_nvim_lsp")

local servers = {
  "lua_ls",      -- Lua
  -- "dartls",      -- Dart/Flutter
  "tsserver",    -- TypeScript/JavaScript
  "tailwindcss", -- Tailwind CSS
  "gopls",       -- Go
  "html",        -- HTML
  "cssls",       -- CSS
  "sqlls",       -- SQL
  "biome",       -- Modern JS/TS alternative (combines formatter + linter)
  "dockerls",    -- Dockerfiles
  "helm_ls",     -- Helm charts
}

-- Improved Mason configuration
mason_lspconfig.setup({
  ensure_installed = servers,
  automatic_installation = true,
})

-- Enhanced capabilities with additional features
local capabilities = vim.tbl_deep_extend(
  "force",
  cmp_nvim_lsp.default_capabilities(),
  {
    textDocument = {
      documentHighlight = {
        dynamicRegistration = false
      },
      foldingRange = {
        dynamicRegistration = false
      }
    },
    workspace = {
      workspaceFolders = true
    }
  }
)

local function switch_to_previous_file()
  local current_buf = vim.api.nvim_get_current_buf()
  local alternate_buf = vim.fn.bufnr('#')

  if alternate_buf ~= -1 and alternate_buf ~= current_buf then
    vim.api.nvim_set_current_buf(alternate_buf)
  else
    print("No previous file to switch to")
  end
end

-- Better organized LSP keymaps
local on_attach = function(_, bufnr)
  -- Enable omnifunc
  vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

  -- Create a helper function for buffer-local keymaps
  local bufmap = function(mode, lhs, rhs, desc)
    vim.keymap.set(mode, lhs, rhs, {
      buffer = bufnr,
      noremap = true,
      silent = true,
      desc = desc,
    })
  end

  -- Navigation
  bufmap("n", "gd", vim.lsp.buf.definition, "Go to definition")
  bufmap("n", "gD", vim.lsp.buf.declaration, "Go to declaration")
  bufmap("n", "gr", vim.lsp.buf.references, "Find references")
  bufmap("n", "gi", vim.lsp.buf.implementation, "Go to implementation")
  bufmap("n", "K", vim.lsp.buf.hover, "Show documentation")
  bufmap("n", "<C-k>", vim.lsp.buf.signature_help, "Signature help")
  vim.keymap.set("n", "<C-p>", switch_to_previous_file,
    vim.tbl_extend("force", { noremap = true, silent = true, buffer = bufnr }, { desc = "Switch to previous file" }))

  -- Code actions
  bufmap("n", "<leader>ca", vim.lsp.buf.code_action, "Code actions")
  bufmap("n", "<leader>rn", vim.lsp.buf.rename, "Rename symbol")

  -- Workspace
  bufmap("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, "Add workspace folder")
  bufmap("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, "Remove workspace folder")
  bufmap("n", "<leader>wl", function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, "List workspace folders")

  -- Formatting
  bufmap("n", "<leader>f", function()
    vim.lsp.buf.format({ async = true, timeout_ms = 5000 })
  end, "Format buffer")

  -- Diagnostics
  bufmap("n", "[d", vim.diagnostic.goto_prev, "Previous diagnostic")
  bufmap("n", "]d", vim.diagnostic.goto_next, "Next diagnostic")
  bufmap("n", "<leader>d", vim.diagnostic.open_float, "Show diagnostic")

  -- Type information
  bufmap("n", "<leader>td", vim.lsp.buf.type_definition, "Type definition")
end

-- Base LSP configuration
local lsp_defaults = {
  capabilities = capabilities,
  on_attach = on_attach,
  flags = {
    debounce_text_changes = 150,
  },
}

-- Server-specific configurations
local server_settings = {
  lua_ls = {
    settings = {
      Lua = {
        runtime = {
          version = "LuaJIT",
        },
        diagnostics = {
          globals = { "vim" },
        },
        workspace = {
          library = vim.api.nvim_get_runtime_file("", true),
          checkThirdParty = false,
        },
        telemetry = {
          enable = false,
        },
      },
    },
  },

  tsserver = {
    init_options = {
      maxTsServerMemory = 4096,
      preferences = {
        includeInlayParameterNameHints = "all",
        includeInlayParameterNameHintsWhenArgumentMatchesName = true,
        includeInlayFunctionParameterTypeHints = true,
        includeInlayVariableTypeHints = true,
        includeCompletionsForModuleExports = true,
        includeCompletionsWithInsertText = true,
      }
    }
  },

  tailwindcss = {
    filetypes = {
      "html",
      "css",
      "javascript",
      "javascriptreact",
      "typescript",
      "typescriptreact",
      "svelte",
      "vue",
      "templ",
    },
    init_options = {
      userLanguages = {
        templ = "html",
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
        },
        staticcheck = true,
        gofumpt = true,
        hints = {
          assignVariableTypes = true,
          compositeLiteralFields = true,
          constantValues = true,
          functionTypeParameters = true,
          parameterNames = true,
          rangeVariableTypes = true,
        },
      },
    },
  },

  dartls = {
    init_options = {
      closingLabels = true,
      flutterOutline = true,
      onlyAnalyzeProjectsWithOpenFiles = true,
      outline = true,
      suggestFromUnimportedLibraries = true,
    },
    settings = {
      dart = {
        completeFunctionCalls = true,
        showTodos = true,
        updateImportsOnRename = true,
      }
    }
  },

  biome = {
    filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
    single_file_support = true,
  },

  helm_ls = {
    filetypes = { "helm" },
    settings = {
      helm = {
        lint = {
          enable = true,
        },
        template = {
          enable = true,
        },
      }
    }
  },

  dockerls = {
    settings = {
      docker = {
        languageserver = {
          formatter = {
            ignorePaths = { "node_modules" },
          },
        }
      }
    }
  }
}

-- Setup servers with merged configurations
mason_lspconfig.setup_handlers({
  function(server_name)
    local opts = vim.tbl_deep_extend("force", lsp_defaults, server_settings[server_name] or {})
    lspconfig[server_name].setup(opts)
  end
})

-- Format on save for specific filetypes
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = { "*.lua", "*.go", "*.dart", "*.ts", "*.js", "*.css", "*.html" },
  callback = function()
    vim.lsp.buf.format({ async = false, timeout_ms = 2000 })
  end
})
