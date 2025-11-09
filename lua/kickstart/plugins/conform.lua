return { -- Autoformat
  'stevearc/conform.nvim',
  event = { 'BufWritePre' },
  cmd = { 'ConformInfo' },
  keys = {
    {
      '<leader>fm',
      function()
        local ft = vim.bo.filetype
        -- if ft == 'typescript' or ft == 'typescriptreact' or ft == 'javascript' or ft == 'javascriptreact' then
        --   vim.lsp.buf.format { async = true, filter = function(client) return client.name == 'ts_ls' end }
        -- else
          require('conform').format { async = true, lsp_format = 'fallback' }
        -- end
      end,
      mode = '',
      desc = '[F]ormat buffer',
    },
  },
  opts = {
    notify_on_error = false,
    format_on_save = false,
    formatters_by_ft = {
      lua = { 'stylua' },
      -- Conform can also run multiple formatters sequentially
      -- python = { "isort", "black" },
      --
      -- You can use 'stop_after_first' to run the first available formatter from the list
      javascript = { 'prettierd', 'prettier', stop_after_first = true },
    },
  },
}
