local keymap = vim.keymap

keymap.set('n', '<C-a>', 'gg<S-v>G')
-- Toggle NeoTree sidebar
keymap.set('n', '<leader>e', ':NvimTreeToggle<cr>')

-- Close buffer
keymap.set('n', '<leader>q', ':q<cr>')
keymap.set('n', '<leader>Q', ':q<cr>')
keymap.set('n', '<leader>qa', ':qa<cr>')
keymap.set('n', '<leader>Qa', ':qa<cr>')

-- Centering serach result
keymap.set('n', 'n', 'nzz')
keymap.set('n', 'N', 'Nzz')

-- Clear highlight text when pressing Esc
keymap.set({ 'i', 'n' }, '<Esc>', '<esc>:nohl<cr>')

-- Moving around windows using s + h,j,k,l
keymap.set('n', 'sh', '<C-w>h')
keymap.set('n', 'sj', '<C-w>j')
keymap.set('n', 'sk', '<C-w>k')
keymap.set('n', 'sl', '<C-w>l')

-- move up-down but keep center
keymap.set('n', 'j', 'jzz')
keymap.set('n', 'k', 'kzz')

-- Split windows
keymap.set('n', 'ss', ':split<cr><C-w>w')
keymap.set('n', 'sv', ':vsplit<cr><C-w>w')


-- Next/Prev tab page
keymap.set('n', '<leader>l', ':BufferLineCycleNext<CR>')
keymap.set('n', '<leader>h', ':BufferLineCyclePrev<CR>')

-- Close all tabs
keymap.set('n', '<leader>ta', [[:tabedit<cr>:BufferLineCloseLeft<cr>:BufferLineCloseRight<cr>]])
-- Keep current tab and close the others
keymap.set('n', '<leader>to', [[:BufferLineCloseLeft<cr>:BufferLineCloseRight<cr>]])

-- Format code
-- this keymap only work if you setting lsp
-- please see /plugin/lspconfig.lua
keymap.set('n', '<leader>fm', ':lua vim.lsp.buf.format()<cr>')

-- Save file
keymap.set('n', '<C-s>', ':w<cr>')
keymap.set('i', '<c-s>', '<esc>:w<cr>a')

-- Move lines and group lines left, right
keymap.set('v', '>', '>gv')
keymap.set('v', '<', '<gv')

-- Move lines and group lines up, down
keymap.set('n', 'K', ':m .-2<cr>')
keymap.set('n', 'J', ':m .+1<cr>')

keymap.set('v', 'K', ":m '<-2<CR>gv=gv")
keymap.set('v', 'J', ":m '>+1<CR>gv=gv")

-- Resize with arrows
keymap.set("n", "<C-k>", ":resize -2<CR>")
keymap.set("n", "<C-j>", ":resize +2<CR>")
keymap.set("n", "<C-h>", ":vertical resize -2<CR>")
keymap.set("n", "<C-l>", ":vertical resize +2<CR>")

-- Find file in NvimTree
keymap.set('n', '<leader>ff', ':NvimTreeFindFile<cr>zz')
keymap.set('n', '@', ':NvimTreeFindFile<cr>')

-- Open hop for jumping into anywhere inside buffer
keymap.set('n', '<leader>j', ':HopLine<cr>')
keymap.set('n', '<leader>ja', ':HopAnywhere<cr>')
keymap.set('n', '<leader>jl', ':HopAnywhereCurrentLine<cr>')

-- Duplicate line
keymap.set('n', '<C-d>', 'yyp')

-- Pick any tab
keymap.set('n', ';t', ':BufferLinePick<cr>')

-- Trigger code action by nvim-code-action-menu
keymap.set('n', '<leader>ca', ':CodeActionMenu<cr>')

-- Open/close resolve conflict windows
keymap.set('n', '<leader>dv', ':DiffviewOpen<cr>')
keymap.set('n', '<leader>dvv', ':DiffviewClose<cr>')

-- copy to clipboard
keymap.set('v', '<leader>y', '"+y')
keymap.set('n', '<leader>Y', '"+yg_')
keymap.set('n', '<leader>y', '"+y')
keymap.set('n', '<leader>yy', '"+yy')

-- paste from clipboard
keymap.set('n', '<leader>p', '"+p')
keymap.set('n', '<leader>P', '"+P')
keymap.set('v', '<leader>p', '"+p')
keymap.set('v', '<leader>p', '"+P')

-- start macro and save it to 'h'
keymap.set('n', '<leader>sm', 'qh')
-- apply macro immediately
keymap.set('n', '<leader>amn', ':norm! @h<cr>')
-- open apply macro input, not run it
keymap.set('n', '<leader>am', ':norm! @h')

