-- dim_unused: visually dim unused / unnecessary diagnostics and tokens
-- Provides:
--  - links for `DiagnosticUnnecessary` and related groups
--  - tries to tag LSP diagnostics with DiagnosticTag.Unnecessary when messages contain "unused"-like text
--  - fallback highlighter that highlights diagnostic ranges with the `Comment` group
--  - user command `:DimUnusedExplain` to show what the module does

if vim.g._user_dim_unused_done then
  return
end

local M = {}

local function apply_dim()
  pcall(vim.cmd, [[
    highlight! link DiagnosticUnnecessary Comment
    highlight! link DiagnosticVirtualTextHint Comment
    highlight! link DiagnosticUnderlineHint Comment
    highlight! link DiagnosticSignHint Comment
  ]])
  pcall(function()
    vim.api.nvim_set_hl(0, "DiagnosticUnnecessary", { fg = "#6c6f78", italic = true })
  end)
  pcall(function()
    vim.api.nvim_set_hl(0, "@variable.deprecated", { link = "Comment" })
    vim.api.nvim_set_hl(0, "@variable.unused", { link = "Comment" })
    vim.api.nvim_set_hl(0, "@parameter.unused", { link = "Comment" })
  end)
end

-- attach after colorscheme changes since some colorschemes overwrite links
apply_dim()
local hl_aug = vim.api.nvim_create_augroup('user_dim_unused_hl', { clear = true })
vim.api.nvim_create_autocmd('ColorScheme', { group = hl_aug, callback = apply_dim })

-- try to tag diagnostics that look unused as Unnecessary so LSP-aware highlighting works
if vim.lsp and vim.lsp.handlers and vim.lsp.protocol and vim.lsp.protocol.DiagnosticTag then
  local orig_pub = vim.lsp.handlers["textDocument/publishDiagnostics"]
  vim.lsp.handlers["textDocument/publishDiagnostics"] = function(err, result, ctx, config)
    if result and result.diagnostics then
      for _, d in ipairs(result.diagnostics) do
        local msg = d.message or ""
        local lmsg = msg:lower()
        if lmsg:match('unused') or lmsg:match('never read') or lmsg:match('assigned but never used') or lmsg:match('is never used') then
          d.tags = d.tags or {}
          local found = false
          for _, t in ipairs(d.tags) do
            if t == vim.lsp.protocol.DiagnosticTag.Unnecessary then
              found = true
              break
            end
          end
          if not found then
            table.insert(d.tags, vim.lsp.protocol.DiagnosticTag.Unnecessary)
          end
        end
      end
    end
    return orig_pub(err, result, ctx, config)
  end
end

-- Fallback: add buffer highlights for diagnostics whose message looks like "unused" (covers LSPs that don't set tags)
local dim_ns = vim.api.nvim_create_namespace('user_dim_unused')
local function dim_unnecessary_in_buf(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  pcall(vim.api.nvim_buf_clear_namespace, bufnr, dim_ns, 0, -1)
  local diags = vim.diagnostic.get(bufnr)
  for _, d in ipairs(diags) do
    local msg = d.message or ''
    local lmsg = msg:lower()
    if lmsg:match('unused') or lmsg:match('never read') or lmsg:match('assigned but never used') or lmsg:match('is never used') then
      local srow = (d.lnum or (d.range and d.range.start and d.range.start.line) or 0)
      local scol = (d.col or (d.range and d.range.start and d.range.start.character) or 0)
      local erow = (d.end_lnum or (d.range and d.range['end'] and d.range['end'].line) or srow)
      local ecol = (d.end_col or (d.range and d.range['end'] and d.range['end'].character) or (scol + 1))
      if srow == erow then
        pcall(vim.api.nvim_buf_add_highlight, bufnr, dim_ns, 'Comment', srow, scol, ecol)
      else
        pcall(vim.api.nvim_buf_add_highlight, bufnr, dim_ns, 'Comment', srow, scol, -1)
      end
    end
  end
end

local diag_aug = vim.api.nvim_create_augroup('user_dim_unused_diag', { clear = true })
vim.api.nvim_create_autocmd({'DiagnosticChanged'}, { group = diag_aug, callback = function(ev)
  local bufnr = ev and ev.buf or vim.api.nvim_get_current_buf()
  dim_unnecessary_in_buf(bufnr)
end })
vim.api.nvim_create_autocmd({'LspAttach'}, { group = diag_aug, callback = function(ev)
  local bufnr = ev and (ev.buf or (ev.data and ev.data.buf)) or vim.api.nvim_get_current_buf()
  dim_unnecessary_in_buf(bufnr)
end })

-- User command that explains what this module does
vim.api.nvim_create_user_command('DimUnusedExplain', function()
  local lines = {
    'DimUnused: what it does:',
    '- Links `DiagnosticUnnecessary` and related groups to `Comment` to make unused items look faded',
    '- Tries to add the `Unnecessary` diagnostic tag to diagnostics whose message contains "unused"-like text',
    '- Adds a fallback buffer highlight (using `Comment`) for diagnostics with "unused" messages',
    '',
    'If you still see undimmed tokens: check the diagnostic message with `:lua =vim.diagnostic.get(0)[1]`',
    'Report it so the matching can be improved.',
  }
  vim.notify(table.concat(lines, '\n'), vim.log.levels.INFO)
end, { desc = 'Explain what DimUnused does' })

vim.g._user_dim_unused_done = true

return M
