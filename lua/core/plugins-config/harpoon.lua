local harpoon = require("harpoon")

harpoon:setup({
  settings = {
    save_on_toggle = true,
    sync_on_ui_close = true,
    select_with_nil = true,
  }
})

vim.keymap.set("n", "X", function() harpoon:list():add() end)
vim.keymap.set("n", "S", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)
