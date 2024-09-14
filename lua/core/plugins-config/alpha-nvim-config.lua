local alpha = require("alpha")
local dashboard = require("alpha.themes.dashboard")

-- Set header
dashboard.section.header.val = {
  "                                                                ",
  "           ███╗   ██╗ ██████╗     ██████╗  █████╗ ██╗███╗   ██╗",
  "           ████╗  ██║██╔═══██╗    ██╔══██╗██╔══██╗██║████╗  ██║",
  "           ██╔██╗ ██║██║   ██║    ██████╔╝███████║██║██╔██╗ ██║",
  "           ██║╚██╗██║██║   ██║    ██╔═══╝ ██╔══██║██║██║╚██╗██║",
  "           ██║ ╚████║╚██████╔╝    ██║     ██║  ██║██║██║ ╚████║",
  "           ╚═╝  ╚═══╝ ╚═════╝     ╚═╝     ╚═╝  ╚═╝╚═╝╚═╝  ╚═══╝",
  "                                                                ",
  "           ███╗   ██╗ ██████╗      ██████╗  █████╗ ██╗███╗   ██╗",
  "           ████╗  ██║██╔═══██╗    ██╔════╝ ██╔══██╗██║████╗  ██║",
  "           ██╔██╗ ██║██║   ██║    ██║  ███╗███████║██║██╔██╗ ██║",
  "           ██║╚██╗██║██║   ██║    ██║   ██║██╔══██║██║██║╚██╗██║",
  "           ██║ ╚████║╚██████╔╝    ╚██████╔╝██║  ██║██║██║ ╚████║",
  "           ╚═╝  ╚═══╝ ╚═════╝      ╚═════╝ ╚═╝  ╚═╝╚═╝╚═╝  ╚═══╝",
  "                                                                ",
}

-- Customized buttons
dashboard.section.buttons.val = {
  dashboard.button("b", "  > File browser", ":Telescope file_browser<CR>"),
  dashboard.button("g", "  > Live grep", ":lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>"),
  dashboard.button("s", "  > Find files", ":Telescope find_files<CR>"),
  dashboard.button("r", "  > Recent files", ":Telescope oldfiles<CR>"),
  dashboard.button("q", "  > Quit NVIM", ":qa<CR>"),
}

-- Set footer
local function footer()
  local datetime = os.date(" %d-%m-%Y   %H:%M:%S")
  local version = vim.version()
  local nvim_version_info = "   v" .. version.major .. "." .. version.minor .. "." .. version.patch

  return datetime .. nvim_version_info
end

dashboard.section.footer.val = footer()

-- Send config to alpha
alpha.setup(dashboard.opts)

-- Disable folding on alpha buffer
vim.cmd([[
    autocmd FileType alpha setlocal nofoldenable
]])
