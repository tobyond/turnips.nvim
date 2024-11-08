local plenary_path = vim.fn.stdpath("data") .. "/lazy/plenary.nvim"
local alternate_path = vim.fn.getcwd()

-- Clone plenary if it doesn't exist
if not vim.loop.fs_stat(plenary_path) then
  vim.fn.system({
    "git",
    "clone",
    "--depth=1",
    "https://github.com/nvim-lua/plenary.nvim.git",
    plenary_path,
  })
end

-- Add both plenary and our plugin to runtimepath
vim.opt.rtp:prepend(alternate_path)
vim.opt.rtp:prepend(plenary_path)

-- Load plenary
require("plenary.busted")

-- Disable swap files for tests
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.writebackup = false
local path_sep = vim.loop.os_uname().version:match("Windows") and "\\" or "/"
local base_dir = vim.fn.fnamemodify(debug.getinfo(1, "S").source:sub(2), ":h:h")

vim.opt.rtp:append(base_dir)
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.runtimepath:append(base_dir)
