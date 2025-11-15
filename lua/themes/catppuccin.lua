return {
  'catppuccin/nvim',
  name = 'catppuccin',
  priority = 1000,
  opts = {
    flavour = 'mocha',
    integrations = {
      cmp = true,
      gitsigns = true,
      treesitter = true,
      telescope = true,
      native_lsp = { enabled = true },
      indent_blankline = { enabled = true },
      which_key = true,
    },
  },
  config = function(_, opts)
    ---@diagnostic disable-next-line: missing-fields
    require('catppuccin').setup(opts)
    vim.cmd.colorscheme 'catppuccin'
  end,
}
