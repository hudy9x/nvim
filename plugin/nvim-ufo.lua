local stt, ufo = pcall(require, 'ufo')
if not stt then return end

vim.o.foldcolumn = '1' -- '0' is not bad
vim.o.foldlevel = 99   -- Using ufo provider need a large value, feel free to decrease the value
vim.o.foldlevelstart = 99
vim.o.foldenable = true

-- Using ufo provider need remap `zR` and `zM`. If Neovim is 0.6.1, remap yourself
vim.keymap.set('n', 'zR', ufo.openAllFolds)
vim.keymap.set('n', 'zM', ufo.closeAllFolds)
vim.keymap.set('n', 'z1', function()
  ufo.closeFoldsWith(1)
end)
vim.keymap.set('n', 'z2', function()
  ufo.closeFoldsWith(2)
end)
vim.keymap.set('n', 'z3', function()
  ufo.closeFoldsWith(3)
end)
vim.keymap.set('n', 'z4', function()
  ufo.closeFoldsWith(4)
end)
vim.keymap.set('n', 'z5', function()
  ufo.closeFoldsWith(5)
end)

ufo.setup({
  provider_selector = function(bufnr, filetype, buftype)
    return { 'treesitter', 'indent' }
  end

})
