local keymap = vim.keymap

keymap.set('n', '<C-a>', [[gg<s-v>G]])
keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')
keymap.set('n', '<C-s>', ':w<cr>')
keymap.set('i', '<C-s>', '<esc>:w<cr>')
vim.keymap.set('n', '<leader>e', ':Neotree toggle<CR>', { desc = 'Explorer (Neo-tree)', silent = true })
vim.keymap.set('n', '<leader>ff', function()
  vim.cmd 'Neotree reveal'
end, { desc = 'Neo-tree: reveal current file', silent = true })

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Highlight when yanking (copying) text
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
-- vim.keymap.set('n', '<c-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
-- vim.keymap.set('n', '<c-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
-- vim.keymap.set('n', '<c-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
-- vim.keymap.set('n', '<c-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

vim.keymap.set('n', 'sh', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', 'sl', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', 'sj', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', 'sk', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- NOTE: Some terminals have colliding keymaps or are not able to send distinct keycodes
--
-- vim.keymap.set("n", "<C-S-h>", "<C-w>H", { desc = "Move window to the left" })
-- vim.keymap.set("n", "<C-S-l>", "<C-w>L", { desc = "Move window to the right" })
-- vim.keymap.set("n", "<C-S-j>", "<C-w>J", { desc = "Move window to the lower" })
-- vim.keymap.set("n", "<C-S-k>", "<C-w>K", { desc = "Move window to the upper" })

-- Clear highlight text when pressing Esc
keymap.set({ 'i', 'n' }, '<Esc>', '<esc>:nohl<cr>')

-- move up-down but keep center
keymap.set('n', 'j', 'jzz')
keymap.set('n', 'k', 'kzz')

-- Split windows
keymap.set('n', 'ss', ':split<cr><C-w>w')
keymap.set('n', 'sv', ':vsplit<cr><C-w>w')

-- open toggle term
keymap.set('n', '<leader>t', '<cmd>ToggleTerm<CR>')
keymap.set('t', '<esc>', [[<C-\\><C-n>:ToggleTerm<CR>]])

-- Next/Prev tab page
keymap.set('n', '<leader>l', ':BufferLineCycleNext<CR>')
keymap.set('n', '<leader>h', ':BufferLineCyclePrev<CR>')

-- Close all tabs
keymap.set('n', '<leader>ta', [[:tabedit<cr>:BufferLineCloseLeft<cr>:BufferLineCloseRight<cr>]])
-- Keep current tab and close the others
keymap.set('n', '<leader>to', [[:BufferLineCloseLeft<cr>:BufferLineCloseRight<cr>]])

-- Close buffer and jump to neighbor buffers
local function choose_and_close(direction)
  local cur = vim.api.nvim_get_current_buf()
  local bufs_info = vim.fn.getbufinfo({ buflisted = 1 })
  local bufs = {}
  for _, b in ipairs(bufs_info) do
    local ok_ft, ft = pcall(vim.api.nvim_buf_get_option, b.bufnr, 'filetype')
    local ok_bt, bt = pcall(vim.api.nvim_buf_get_option, b.bufnr, 'buftype')
    if ok_ft and ok_bt and ft ~= 'neo-tree' and bt == '' then
      table.insert(bufs, b.bufnr)
    end
  end
  if #bufs == 0 then
    vim.api.nvim_buf_delete(cur, { force = false })
    return
  end
  local idx
  for i, b in ipairs(bufs) do
    if b == cur then
      idx = i
      break
    end
  end
  if not idx then
    -- current buffer not in filtered list; just delete it
    vim.api.nvim_buf_delete(cur, { force = false })
    return
  end
  local target
  if direction == 'prev' then
    local t_idx = idx - 1
    if t_idx < 1 then t_idx = #bufs end
    target = bufs[t_idx]
  else
    local t_idx = idx + 1
    if t_idx > #bufs then t_idx = 1 end
    target = bufs[t_idx]
  end
  vim.api.nvim_set_current_buf(target)
  vim.api.nvim_buf_delete(cur, { force = false })
end

keymap.set('n', '<leader>qq', function() choose_and_close('prev') end, { desc = 'Close buffer and go to previous' })
keymap.set('n', '<leader>qQ', function() choose_and_close('next') end, { desc = 'Close buffer and go to next' })

keymap.set('n', '<leader>jf', ':Neotree reveal<cr>')
