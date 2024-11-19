local stt, leap = pcall(require, 'leap')
if not stt then return end

leap.add_default_mappings(true)
vim.keymap.del({'x', 'o'}, 'x')
vim.keymap.del({'x', 'o'}, 'X')

