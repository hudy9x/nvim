-- Disable netrw at the very start
-- It strongly recommended by NvimTree
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Change leader key to <Space>
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Set default encoding to utf-8
vim.scriptencoding = 'utf-8'
vim.opt.encoding = 'utf-8'
vim.opt.fileencoding = 'utf-8'

-- Enable line number and relative line number
vim.opt.nu = true
vim.opt.rnu = true

-- Set default indent to 2
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
--- Using space instead tab
vim.opt.expandtab = true

--- Using tab instead space
---vim.opt.noexpandtab = true

-- For smart indenting
vim.opt.ai = true
vim.opt.si = true

-- Auto break line when reach to window's border
vim.opt.wrap = true

vim.opt.cursorline = true
vim.opt.termguicolors = true

-- Descrease update time
vim.opt.timeoutlen = 250
vim.opt.timeout = true
vim.opt.updatetime = 250

-- Case insensitive searching unless /c or capital in search
-- Ex: name NaME namE
vim.o.ignorecase = true
vim.o.smartcase = true
