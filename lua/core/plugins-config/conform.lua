require("conform").setup({
  formatters_by_ft = {
    lua = { "stylua" },
    -- Use a sub-list to run only the first available formatter
    javascript = { "biome" },
    javascriptreact = { "biome" },
    php = { "pretty-php" },
    typescript = { "biome" },
    json = { "biome" },
    go = { "golines", "goimports" },
    typescriptreact = { "biome" },
  },
  format_on_save = {
    -- These options will be passed to conform.format()
    timeout_ms = 500,
    lsp_fallback = true,
  },
})
