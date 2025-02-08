vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

local function flutter_hot_reload()
  local pid = vim.fn.system('pgrep -f "dart --enable-vm-service.*run"'):gsub('\n', '')
  if pid ~= "" then
    vim.fn.system('kill -SIGUSR1 ' .. pid)
  end
end

-- Autocommand for hot-reloading on save
-- vim.api.nvim_create_autocmd('BufWritePost', {
--   pattern = '*/lib/*.dart',
--   callback = flutter_hot_reload,
-- })

require("core.options")
require("core.keymaps")
require("core.plugins")
require("core.plugins-config")
