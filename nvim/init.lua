-- Bootstrap lazy
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

-- This has to be set before initializing lazy
vim.g.mapleader = " "

require("lazy").setup("plugins", {
  change_detection = {
    enabled = true,
    notify = false,
  }
})

-- These modules are not loaded by lazy
require("core.options")
require("core.keymaps")
require("plugins.telescope-nvim")
