local ok, null_ls = pcall(require, 'null-ls')
if not ok then return end

null_ls.setup({
  debug = true,
  sources = {
    null_ls.builtins.formatting.prettierd,
    -- null_ls.builtins.diagnostics.eslint_d,

    -- golang
    null_ls.builtins.formatting.gofmt,
    null_ls.builtins.formatting.goimports,

  }
})
