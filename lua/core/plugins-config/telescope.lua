local telescope = require("telescope")
local builtin = require("telescope.builtin")

telescope.setup({
  defaults = {
    file_ignore_patterns = {
      "node_modules/.*",
      ".git/.*",
      ".dist/.*",
      "yarn.lock",
      "*-lock.*",
      "pnpm-lock.yaml",
      "package-lock.json",
      ".output/.*",
      ".dart_tool/.*",
      ".github/.*",
      ".gradle/.*",
      ".idea/.*",
      ".vscode/.*",
      "build/.*",
      "gradle/.*",
      "vendor/.*",   -- Ignoring vendor folder
      "packages/.*", -- Ignoring Dart packages folder
      "%.lock",
      "%.sum",
      "%.mod",
      "%.apk",
      "%.png",
      "%.jpg",
      "%.jpeg",
      "%.webp",
      "%.svg",
      "%.otf",
      "%.ttf",
    },
    mappings = {
      i = {
        ["<C-u>"] = false,
        ["<C-d>"] = false,
      },
    },
  },
  extensions = {
    file_browser = {
      theme = "ivy",
      -- disables netrw and use telescope-file-browser in its place
      hijack_netrw = true,
    },
  }
})

-- Enable telescope fzf native, if installed
pcall(telescope.load_extension, "fzf")
pcall(telescope.load_extension, "live_grep_args")
pcall(telescope.load_extension, "undo")
pcall(telescope.load_extension, "file_browser")

vim.keymap.set("n", "<leader>?", builtin.oldfiles, { desc = "[?] Find recently opened files" })
vim.keymap.set("n", "<leader><space>", builtin.buffers, { desc = "[ ] Find existing buffers" })
vim.keymap.set("n", "<leader>/", function()
  builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown {
    winblend = 10,
    previewer = false,
  })
end, { desc = "[/] Fuzzily search in current buffer" })

vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "[F]ind [F]iles" })
vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "[F]ind [H]elp" })
vim.keymap.set("n", "<leader>fw", builtin.grep_string, { desc = "[F]ind current [W]ord" })
vim.keymap.set("n", "<leader>fg", ":lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>",
  { desc = "[F]ind [G]rep" })
vim.keymap.set("n", "<leader>fd", builtin.diagnostics, { desc = "[F]ind [D]iagnostics" })
vim.keymap.set("n", "<leader>fr", builtin.resume, { desc = "[F]ind [R]esume" })
vim.keymap.set("n", "<space>fa", ":Telescope file_browser<CR>", { desc = "[F]ind [B]rowser" })
vim.keymap.set("n", "<space>fb", function()
  local current_buffer_file_path = vim.fn.expand("%:p:h")
  require("telescope").extensions.file_browser.file_browser({
    path = current_buffer_file_path,
    cwd = current_buffer_file_path,
    respect_gitignore = false,
    hidden = true,
    grouped = true,
    previewer = false,
    initial_mode = "normal",
    layout_config = { height = 40 }
  })
end, { desc = "[F]ile [B]rowser in current directory" })
