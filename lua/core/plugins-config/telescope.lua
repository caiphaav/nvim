require("telescope").setup({ file_ignore_patterns = { "node%_modules/.*" } })
local builtin = require("telescope.builtin")

-- Telescope config. see `:help telescope.builtin`
vim.keymap.set("n", "<leader>/", function()
    -- You can pass additional configuration to telescope to change theme, layout, etc.
    require("telescope.builtin").current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
        winblend = 10,
        previewer = true,
    }))
end, { desc = "[/] Fuzzily search in current buffer" })

local function telescope_live_grep_open_files()
    builtin.live_grep({
        grep_open_files = true,
        prompt_title = "Live Grep in Open Files",
    })
end
vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "[S]earch [F]iles" })
vim.keymap.set("n", "<leader>sw", builtin.grep_string, { desc = "[S]earch current [W]ord" })
vim.keymap.set("n", "<leader>lg", builtin.live_grep, { desc = "[S]earch by [G]rep" })
vim.keymap.set("n", "<leader>lgo", telescope_live_grep_open_files, { desc = "[S]earch [/] in Open Files" })
