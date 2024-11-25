local stt, leap = pcall(require, 'leap')
if not stt then return end

leap.add_default_mappings(true)
vim.keymap.del({ 'x', 'o' }, 'x')
vim.keymap.del({ 'x', 'o' }, 'X')

-- Go to top left of buffer and start searching
vim.keymap.set({ 'n', 'x', 'o' }, 'f', 'H0<Plug>(leap-forward)')
vim.keymap.set({ 'n', 'x', 'o' }, 'fs', '<Plug>(leap-from-window)')
