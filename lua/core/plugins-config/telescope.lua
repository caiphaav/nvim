local telescope = require("telescope")
local builtin = require("telescope.builtin")
local fb_actions = require "telescope".extensions.file_browser.actions
local actions = require "telescope.actions"

-- Custom paste action
local function paste_file(prompt_bufnr)
  local current_picker = actions.state.get_current_picker(prompt_bufnr)
  local cwd = current_picker.cwd

  -- Get the file path from the system clipboard
  local clipboard_content = vim.fn.getreg('+'):gsub("[\n\r]", "")

  if clipboard_content ~= "" then
    local source_path = clipboard_content
    local file_name = vim.fn.fnamemodify(source_path, ":t")
    local target_path = cwd .. "/" .. file_name

    -- Check if the file already exists
    if vim.fn.filereadable(target_path) == 1 then
      print("File already exists at destination.")
      return
    end

    -- Copy the file
    vim.fn.system(string.format('cp -r "%s" "%s"', source_path, target_path))

    if vim.v.shell_error == 0 then
      print("File pasted successfully.")
      current_picker:refresh()
    else
      print("Error pasting file.")
    end
  else
    print("Clipboard is empty or doesn't contain a valid file path.")
  end
end

local function open_telescope_file_browser()
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
end

local last_search = ""
local function live_grep_with_last_search()
  telescope.extensions.live_grep_args.live_grep_args({
    default_text = last_search,
    on_input_filter_cb = function(input)
      last_search = input
      return { prompt = input }
    end,
  })
end

local last_find_files_query = ""
local function find_files_with_last_query()
  builtin.find_files({
    default_text = last_find_files_query,
    on_input_filter_cb = function(input)
      last_find_files_query = input
      return { prompt = input }
    end
  })
end

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
      "vendor/.*", -- Ignoring vendor folder
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
      n = {
        a = fb_actions.create,
        r = fb_actions.rename,
        d = fb_actions.remove,
        c = fb_actions.copy,
        p = paste_file,
        h = fb_actions.toggle_hidden,
        s = fb_actions.toggle_all,
      }
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
pcall(telescope.load_extension, "harpoon")

vim.keymap.set("n", "<leader>?", builtin.oldfiles, { desc = "[?] Find recently opened files" })
vim.keymap.set("n", "<leader><space>", builtin.buffers, { desc = "[ ] Find existing buffers" })
vim.keymap.set("n", "<leader>/", function()
  builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown {
    winblend = 10,
    previewer = false,
  })
end, { desc = "[/] Fuzzily search in current buffer" })

vim.keymap.set("n", "<leader>ff", find_files_with_last_query, { desc = "[F]ind [F]iles (with last path)" })
vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "[F]ind [H]elp" })
vim.keymap.set("n", "<leader>fw", builtin.grep_string, { desc = "[F]ind current [W]ord" })
vim.keymap.set("n", "<leader>fg", live_grep_with_last_search, { desc = "[F]ind [G]rep (with last search)" })
vim.keymap.set("n", "<leader>fd", builtin.diagnostics, { desc = "[F]ind [D]iagnostics" })
vim.keymap.set("n", "<leader>fr", builtin.resume, { desc = "[F]ind [R]esume" })
vim.keymap.set("n", "<space>fa", ":Telescope file_browser<CR>", { desc = "[F]ind [B]rowser" })
vim.keymap.set("n", "f", open_telescope_file_browser, { desc = "[F]ile [B]rowser in current directory" })
vim.keymap.set("n", "<space>fb", open_telescope_file_browser, { desc = "[F]ile [B]rowser in current directory" })
