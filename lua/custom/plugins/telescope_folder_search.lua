-- Two-input Telescope UI: Keyword + Folder picker
-- This module registers two keymaps:
--  <leader>Sf -> live_grep (shows both inputs)
--  <leader>Ff -> find_files (shows both inputs)
local builtin = require('telescope.builtin')

local M = {}

local function open_two_input(mode)
  -- mode: 'live_grep' or 'find_files'
  local buf = vim.api.nvim_create_buf(false, true)
  local width = math.max(60, math.floor(vim.o.columns * 0.6))
  local height = 6
  local row = math.floor((vim.o.lines - height) / 2 - 1)
  local col = math.floor((vim.o.columns - width) / 2)
  local cwd = vim.fn.getcwd()
  local lines = {
    'Keyword: ',
    'Folder: ' .. cwd,
    '',
    'Tab: switch | <C-s>: suggestions | Enter: run | Esc: cancel',
  }
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  local win = vim.api.nvim_open_win(buf, true, {
    relative = 'editor', row = row, col = col, width = width, height = height,
    style = 'minimal', border = 'single',
  })
  vim.bo[buf].modifiable = true
  vim.bo[buf].buftype = ''
  vim.bo[buf].filetype = 'TelescopeTwoInput'

  local function get_inputs()
    local l1 = vim.api.nvim_buf_get_lines(buf, 0, 1, false)[1] or ''
    local l2 = vim.api.nvim_buf_get_lines(buf, 1, 2, false)[1] or ''
    local keyword = l1:gsub('^Keyword:%s*', '')
    local folder = l2:gsub('^Folder:%s*', '')
    if folder == '' then folder = cwd end
    return keyword, folder
  end

  local function close()
    if vim.api.nvim_win_is_valid(win) then vim.api.nvim_win_close(win, true) end
    if vim.api.nvim_buf_is_valid(buf) then pcall(vim.api.nvim_buf_delete, buf, { force = true }) end
  end

  local function run()
    local kw, folder = get_inputs()
    close()
    if mode == 'live_grep' then
      builtin.live_grep {
        search_dirs = { folder },
        default_text = kw,
        additional_args = function() return { '--hidden', '--no-ignore' } end,
      }
    else
      builtin.find_files {
        cwd = folder,
        hidden = true,
        no_ignore = true,
        no_ignore_vcs = true,
        prompt_title = 'Find Files in ' .. folder,
        default_text = kw or '',
      }
    end
  end

  -- Gather folder suggestions (depth-limited)
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
    -- include base and cwd
    table.insert(res, 1, base)
    -- limit
    local limit = 200
    if #res > limit then
      local s = {}
      for i = 1, limit do s[i] = res[i] end
      return s
    end
    return res
  end

  local function show_suggestions()
    local _, folder = get_inputs()
    local base = folder ~= '' and folder or cwd
    local dirs = gather_dirs(base, 2)
    if #dirs == 0 then
      vim.notify('No folders found for suggestions', vim.log.levels.INFO)
      return
    end
    vim.ui.select(dirs, { prompt = 'Select folder:' }, function(choice)
      if not choice then return end
      -- update folder line
      local new_line = 'Folder: ' .. choice
      vim.api.nvim_buf_set_lines(buf, 1, 2, false, { new_line })
      -- move cursor to folder line end and enter insert
      local col = #new_line
      vim.api.nvim_win_set_cursor(win, { 2, col })
      vim.cmd('startinsert')
    end)
  end

  local function switch_line()
    local pos = vim.api.nvim_win_get_cursor(win)
    local target = (pos[1] == 1) and 2 or 1
    local line_text = vim.api.nvim_buf_get_lines(buf, target - 1, target, false)[1] or ''
    local col = #line_text
    vim.api.nvim_win_set_cursor(win, { target, col })
    vim.cmd('startinsert')
  end

  -- buffer-local mappings (work in both normal and insert modes)
  local map_opts = { noremap = true, silent = true, buffer = buf }
  vim.keymap.set({ 'n', 'i' }, '<Tab>', function() switch_line() end, map_opts)
  vim.keymap.set({ 'n', 'i' }, '<C-s>', function() show_suggestions() end, map_opts)
  vim.keymap.set({ 'n', 'i' }, '<CR>', function() run() end, map_opts)
  -- Do not close on <Esc>; use 'q' in normal to close and <C-c> in insert to close
  vim.keymap.set('n', 'q', function() close() end, map_opts)
  vim.keymap.set('i', '<C-c>', function() close() end, map_opts)

  -- position cursor at start of Keyword line in normal mode (do not enter insert)
  vim.api.nvim_win_set_cursor(win, { 1, #('Keyword: ') })
end

-- Register keymaps
vim.keymap.set('n', ';fiff', function() open_two_input('live_grep') end, { desc = 'Live grep in a specified folder' })
vim.keymap.set('n', ';fif', function() open_two_input('find_files') end, { desc = 'Find files in a specified folder' })

return M
