local keymap = vim.keymap
local api = vim.api

-- Leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Split window
keymap.set("n", "hh", ":belowright split new<CR>", { silent = true })
keymap.set("n", "ss", ":below vsplit new<CR>", { silent = true })

-- Delete/Move/Yank until line start/end
keymap.set("n", "del", "d$", { silent = true })
keymap.set("n", "dsl", "d^", { silent = true })
keymap.set("n", "mel", "<S-$>", { silent = true })
keymap.set("n", "msl", "<S-^>", { silent = true })
keymap.set("n", "yel", "y$", { silent = true })
keymap.set("n", "ysl", "y^", { silent = true })

-- Generic function to replace content from the cursor position to the end or start of the line with yanked content
local function replace_with_yanked_content(option)
  -- Get the current line number and cursor column
  local current_line_number = vim.fn.line('.')
  local current_col = vim.fn.col('.')

  -- Get the yanked content from the clipboard
  local yanked_content = vim.fn.getreg('+') -- Using '+' to get the clipboard content

  -- Check if the clipboard is empty
  if yanked_content == nil or yanked_content == '' then
    print("No content in the clipboard")
    return
  end

  -- Get the current line content
  local line_content = vim.fn.getline(current_line_number)

  local new_line_content
  if option == 'end' then
    -- Replace the content from the cursor to the end of the line
    new_line_content = string.sub(line_content, 1, current_col - 1) .. yanked_content
    print("Replaced from cursor to end of line with yanked content")
  elseif option == 'start' then
    -- Replace the content from the start of the line to the cursor
    new_line_content = yanked_content .. string.sub(line_content, current_col)
    print("Replaced from start of line to cursor with yanked content")
  else
    print("Invalid option")
    return
  end

  vim.fn.setline(current_line_number, new_line_content)
end

keymap.set("n", "yer", function() replace_with_yanked_content('end') end, { silent = true })
keymap.set("n", "ysr", function() replace_with_yanked_content('start') end, { silent = true })

-- Delete until first symbol
local function delete_until_symbol()
  local symbol = vim.fn.input("Enter symbol: ")
  if symbol == "" then
    print("No symbol entered")
    return
  end

  -- Get the current buffer content as a single string
  local buffer_content = table.concat(vim.api.nvim_buf_get_lines(0, 0, -1, false), "\n")
  -- Convert cursor position to a single index
  local current_line = vim.fn.line('.')
  local current_col = vim.fn.col('.')
  local cursor_pos = vim.fn.line2byte(current_line) + current_col - 1  -- Convert to byte position (1-based index)
  local symbol_pos = buffer_content:find(symbol, cursor_pos + 1, true) -- Find the symbol starting after the cursor

  if symbol_pos then
    -- Calculate the line and column of the symbol position
    local before_symbol = buffer_content:sub(1, symbol_pos - 1)
    local line_count = #vim.split(before_symbol, "\n")
    local col_count = #before_symbol:match("([^\n]*)$")

    -- Select the range from cursor to the symbol position and delete
    local end_line = line_count
    local end_col = col_count

    -- Ensure correct position for deletion
    vim.api.nvim_buf_set_text(0, current_line - 1, current_col - 1, end_line - 1, end_col, {})
  else
    print("Symbol not found")
  end
end

keymap.set("n", "ds", delete_until_symbol, { silent = true })

-- Change window
keymap.set("", "<S-Left>", "<C-w>h")
keymap.set("", "<S-Up>", "<C-w>k")
keymap.set("", "<S-Down>", "<C-w>j")
keymap.set("", "<S-Right>", "<C-w>l")

-- Tab
keymap.set("n", "<C-n>", ":tabnew<Return>")
keymap.set("n", "<C-j>", "<cmd>BufferLineCycleNext<CR>", {})
keymap.set("n", "<C-k>", "<cmd>BufferLineCyclePrev<CR>", {})
keymap.set("n", "<C-q>", ":bd<CR>")

-- File
keymap.set("n", "<C-s>", ":wa<CR>")
keymap.set("n", "<S-s>", "<nop>")
keymap.set("n", "fq", ":q!<CR>")
keymap.set("n", "fwq", ":wqa<CR>")

-- Nvim-tree
keymap.set("n", "<F2>", ":NvimTreeFindFileToggle<CR>")
keymap.set("n", "<F1>", ":NvimTreeFocus<CR>")

--Terminal

function ToggleTerminal()
  local term_buf_exists = false
  for _, buf in ipairs(api.nvim_list_bufs()) do
    if vim.bo[buf].buftype == "terminal" then
      term_buf_exists = true
      break
    end
  end

  if term_buf_exists then
    vim.cmd("silent! bd! term://")
  else
    vim.cmd("belowright split term://zsh")

    local term_win = api.nvim_get_current_win()
    local term_buf = api.nvim_win_get_buf(term_win)
    api.nvim_buf_set_keymap(term_buf, "t", "<Esc>", "<C-\\><C-n>", { noremap = true })
  end
end

keymap.set("n", "<S-t>", ":lua ToggleTerminal()<CR>")

-- Telescope config search in ./plugins-config

-- Redo operation
keymap.set("n", "r", "<C-r>", { noremap = true, silent = true })

-- Select all
api.nvim_set_keymap("n", "<C-a>", "ggVG", { noremap = true, silent = true })

-- Save operation
-- MacOS Cmd + s Insert and Normal mode
api.nvim_set_keymap("i", "<C-s>", "<Esc>:w<CR>", { noremap = true, silent = true })
api.nvim_set_keymap("n", "<C-s>", "<Esc>:w<CR>", { noremap = true, silent = true })
-- Linux/Windows Ctrl + S
api.nvim_set_keymap("i", "<D-s>", "<Esc>:w<CR>", { noremap = true, silent = true })
api.nvim_set_keymap("n", "<D-s>", "<Esc>:w<CR>", { noremap = true, silent = true })
