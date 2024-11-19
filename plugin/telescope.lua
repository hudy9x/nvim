local status, telescope = pcall(require, 'telescope')
if not status then return end

local builtin = require('telescope.builtin')

vim.keymap.set('n', ';f', builtin.find_files, {})
vim.keymap.set('n', ';r', builtin.live_grep, {})
vim.keymap.set('n', ';;', builtin.buffers, {})
vim.keymap.set('n', ';fs', builtin.current_buffer_fuzzy_find)
vim.keymap.set('n', ';gbr', builtin.git_branches)
vim.keymap.set('n', ';gst', builtin.git_status)
vim.keymap.set('n', ';gcm', builtin.git_commits)
vim.keymap.set('n', ';xx', builtin.diagnostics)

telescope.setup {
  defaults = {
    layout_strategy = 'center',
    layout_config = { height = 0.75 }
  }

}
