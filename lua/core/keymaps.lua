local keymap = vim.keymap


-- Set leader keys
vim.g.mapleader = " "
vim.g.maplocalleader = " "

--------------------------------------------------------------------
-- Buffer Management
--------------------------------------------------------------------
-- Smart buffer close with Alpha fallback
local function smart_close()
  local buffers = vim.fn.getbufinfo({ buflisted = 1 })
  if #buffers == 1 then
    -- If it's the last buffer, open alpha
    vim.cmd("Alpha")
  else
    -- Otherwise, close the current buffer
    vim.cmd("bd")
  end
end

keymap.set("n", "<C-q>", smart_close, { noremap = true, silent = true, desc = "Close buffer or return to Alpha" })

--------------------------------------------------------------------
-- Window Management
--------------------------------------------------------------------
-- Split windows
keymap.set("n", "hh", ":split<CR>", {
  desc = "Horizontal split",
  silent = true
})

keymap.set("n", "ss", ":vsplit<CR>", {
  desc = "Vertical split",
  silent = true
})

-- Window navigation
keymap.set("n", "<S-Left>", "<C-w>h", { desc = "Window left" })
keymap.set("n", "<S-Down>", "<C-w>j", { desc = "Window down" })
keymap.set("n", "<S-Up>", "<C-w>k", { desc = "Window up" })
keymap.set("n", "<S-Right>", "<C-w>l", { desc = "Window right" })

--------------------------------------------------------------------
-- Line Operations
--------------------------------------------------------------------
-- Delete/Yank line segments (changed to <leader> prefixes)
keymap.set("n", "<leader>dl", function()
  vim.cmd('normal! "*d$')
end, {
  desc = "Delete to line end (clipboard)",
  silent = true
})

keymap.set("n", "<leader>ds", function()
  vim.cmd('normal! "*d^')
end, {
  desc = "Delete to line start (clipboard)",
  silent = true
})

-- Move/Yank line segments
keymap.set("n", "<leader>ml", "$", { desc = "Jump to line end" })
keymap.set("n", "<leader>ms", "^", { desc = "Jump to line start" })
keymap.set("n", "<leader>yl", "y$", { desc = "Yank to line end" })
keymap.set("n", "<leader>ys", "y^", { desc = "Yank to line start" })

--------------------------------------------------------------------
-- Delete Until Symbol
--------------------------------------------------------------------
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

    -- Extract the text to be deleted
    local text_to_delete = buffer_content:sub(cursor_pos, symbol_pos - 1)

    -- Copy the text to be deleted to the system clipboard
    vim.fn.setreg('+', text_to_delete)

    -- Select the range from cursor to the symbol position and delete
    local end_line = line_count
    local end_col = col_count

    -- Ensure correct position for deletion
    vim.api.nvim_buf_set_text(0, current_line - 1, current_col - 1, end_line - 1, end_col, {})

    print("Deleted text copied to clipboard")
  else
    print("Symbol not found")
  end
end

keymap.set("n", "ds", delete_until_symbol, { silent = true })

--------------------------------------------------------------------
-- File Operations
--------------------------------------------------------------------
local function safe_save()
  vim.cmd("silent! write")
end
-- Save mappings
keymap.set("n", "<C-s>", safe_save, { desc = "Save file" })
keymap.set("i", "<C-s>", "<Esc>:w<CR>", { desc = "Save file" })
-- Quit mappings
keymap.set("n", "<leader>fq", "<cmd>q!<CR>", { desc = "Force quit" })
keymap.set("n", "<leader>fwq", "<cmd>wqa<CR>", { desc = "Save and quit all" })


-- Select all
keymap.set("n", "<C-a>", "ggVG", {
  noremap = true,
  silent = true,
  desc = "Select entire buffer"
})

-- Scrolling (centered jumps)
keymap.set("n", "<C-Up>", "10kzz", { desc = "Scroll up 10 lines (centered)" })
keymap.set("n", "<C-Down>", "10jzz", { desc = "Scroll down 10 lines (centered)" })
-- Horizontal navigation with centered jumps
keymap.set("n", "<C-Left>", "20hzz", { desc = "Move left 10 chars (centered)" })
keymap.set("n", "<C-Right>", "20lzz", { desc = "Move right 10 chars (centered)" })

--------------------------------------------------------------------
-- Line Operations
--------------------------------------------------------------------
-- Delete/Yank line segments (now under <leader> prefix)
keymap.set("n", "del", function()
  vim.cmd('normal! "*d$')
end, {
  silent = true,
  desc = "Delete to line end (clipboard)"
})

keymap.set("n", "dsl", function()
  vim.cmd('normal! "*d^')
end, {
  silent = true,
  desc = "Delete to line start (clipboard)"
})

--------------------------------------------------------------------
-- Redo/Undo
--------------------------------------------------------------------
keymap.set("n", "r", "<C-r>", { noremap = true, silent = true })
