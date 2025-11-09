-- Custom LSP overrides: safe monkeypatch for floating previews and hover mapping
if vim.g._user_lsp_overrides_done then
  return
end

-- Monkeypatch open_floating_preview safely to default a border
if vim.lsp and vim.lsp.util and vim.lsp.util.open_floating_preview then
  local orig_open = vim.lsp.util.open_floating_preview
  vim.lsp.util.open_floating_preview = function(contents, syntax, opts, ...)
    opts = opts or {}
    if opts.border == nil then
      opts.border = 'rounded'
    end
    return orig_open(contents, syntax, opts, ...)
  end
end

-- Buffer-local mapping for hover on 'K' when LSP attaches
local aug = vim.api.nvim_create_augroup('user_lsp_overrides', { clear = true })
vim.api.nvim_create_autocmd('LspAttach', {
  group = aug,
  callback = function(ev)
    local bufnr = ev.buf or (ev.data and ev.data.buf)
    if bufnr and bufnr ~= 0 then
      vim.keymap.set('n', 'K', vim.lsp.buf.hover, { buffer = bufnr, desc = 'LSP: Hover' })
    end
  end,
})

-- Global fallback mapping for 'K' to call hover (works even if LspAttach didn't set buffer-local mapping)
-- This avoids cases where the buffer-local mapping isn't present but LSP hover is available.
vim.keymap.set('n', 'K', function()
  pcall(vim.lsp.buf.hover)
end, { desc = 'LSP: Hover (global fallback)' })

vim.g._user_lsp_overrides_done = true
