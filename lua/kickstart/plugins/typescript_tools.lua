return {
  'pmizio/typescript-tools.nvim',
  dependencies = { 'nvim-lua/plenary.nvim', 'neovim/nvim-lspconfig' },
  ft = { 'typescript', 'typescriptreact', 'javascript', 'javascriptreact' },
  opts = {
    settings = {
      -- tsserver_file_preferences = {
      --   includeInlayParameterNameHints = 'all',
      --   includeCompletionsForModuleExports = true,
      --   quotePreference = 'auto',
      --
      -- },

      tsserver_format_options = {
        tabSize = 2,
        indentSize = 2,
      },
    },
  },
  config = function(_, opts)
    require('typescript-tools').setup(opts or {})
  end,
}
