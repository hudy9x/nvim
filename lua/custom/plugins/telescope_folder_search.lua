-- Telescope folder chooser UI (single folder input)
-- Opens a floating prompt to pick/enter a folder, then opens Telescope.
local builtin = require('telescope.builtin')

local M = {}

local function gather_dirs(base, maxdepth)
  maxdepth = maxdepth or 2
  local res = {}
  local function scan(path, depth)
    if depth > maxdepth then return end
    local entries = pcall(vim.fn.readdir, path) and vim.fn.readdir(path) or {}
    for _, name in ipairs(entries) do
      local full = path .. '/' .. name
      if vim.fn.isdirectory(full) == 1 then
        table.insert(res, full)
        scan(full, depth + 1)
      end
    end
  end
  local ok = pcall(scan, base, 0)
  if not ok then return {} end
  table.insert(res, 1, base)
  local limit = 200
  if #res > limit then
    local s = {}
    for i = 1, limit do s[i] = res[i] end
    return s
  end
  return res
end

local function open_folder_prompt(mode)
  -- mode: 'live_grep' or 'find_files'
  local buf = vim.api.nvim_create_buf(false, true)
  local width = math.max(50, math.floor(vim.o.columns * 0.5))
  local height = 4
  local row = math.floor((vim.o.lines - height) / 2 - 1)
  local col = math.floor((vim.o.columns - width) / 2)
  local cwd = vim.fn.getcwd()
  local title = (mode == 'live_grep') and 'Live Grep in Folder' or 'Find Files in Folder'
  local lines = { title, 'Folder: ' .. cwd, '', "<C-s>: suggestions | Enter: open | q: close" }
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  local win = vim.api.nvim_open_win(buf, true, {
    relative = 'editor', row = row, col = col, width = width, height = height,
    style = 'minimal', border = 'single',
  })
  vim.bo[buf].modifiable = true
  vim.bo[buf].buftype = ''
  vim.bo[buf].filetype = 'TelescopeFolderSearch'

  local function get_folder()
    local line = vim.api.nvim_buf_get_lines(buf, 1, 2, false)[1] or ''
    local folder = line:gsub('^Folder:%s*', '')
    if folder == '' then folder = cwd end
    return folder
  end

  local function close()
    if vim.api.nvim_win_is_valid(win) then vim.api.nvim_win_close(win, true) end
    if vim.api.nvim_buf_is_valid(buf) then pcall(vim.api.nvim_buf_delete, buf, { force = true }) end
  end

  local function run()
    local folder = get_folder()
    close()
    if mode == 'live_grep' then
      builtin.live_grep({ search_dirs = { folder }, additional_args = function() return { '--hidden', '--no-ignore' } end })
    else
      builtin.find_files({ cwd = folder, hidden = true, no_ignore = true, no_ignore_vcs = true })
    end
  end

  local function show_suggestions()
    local folder = get_folder()
    local base = (folder ~= '') and folder or cwd
    local dirs = gather_dirs(base, 2)
    if #dirs == 0 then
      vim.notify('No folders found for suggestions', vim.log.levels.INFO)
      return
    end
    vim.ui.select(dirs, { prompt = 'Select folder:' }, function(choice)
      if not choice then return end
      local new_line = 'Folder: ' .. choice
      vim.api.nvim_buf_set_lines(buf, 1, 2, false, { new_line })
      local col = #new_line
      vim.api.nvim_win_set_cursor(win, { 2, col })
      vim.cmd('startinsert')
    end)
  end

  -- mappings
  local map_opts = { noremap = true, silent = true, buffer = buf }
  vim.keymap.set({ 'n', 'i' }, '<C-s>', function() show_suggestions() end, map_opts)
  vim.keymap.set({ 'n', 'i' }, '<CR>', function() run() end, map_opts)
  vim.keymap.set('n', 'q', function() close() end, map_opts)
  vim.keymap.set('n', '<esc>', function() close() end, map_opts)
  vim.keymap.set('i', '<C-c>', function() close() end, map_opts)
  -- allow entering insert with 'i'
  vim.keymap.set('n', 'i', function()
    local line = vim.api.nvim_buf_get_lines(buf, 1, 2, false)[1] or ''
    vim.api.nvim_win_set_cursor(win, { 2, #line })
    vim.cmd('startinsert')
  end, map_opts)

  -- position cursor at end of folder line in normal mode
  local initial_col = #lines[2]
  vim.api.nvim_win_set_cursor(win, { 2, initial_col })
end

-- keymaps
vim.keymap.set('n', '<leader>fg', function() open_folder_prompt('live_grep') end, { desc = 'Telescope: live_grep in folder' })
vim.keymap.set('n', '<leader>ff', function() open_folder_prompt('find_files') end, { desc = 'Telescope: find_files in folder' })

return M
