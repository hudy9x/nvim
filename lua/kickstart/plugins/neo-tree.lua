-- Neo-tree is a Neovim plugin to browse the file system
-- https://github.com/nvim-neo-tree/neo-tree.nvim

return {
  'nvim-neo-tree/neo-tree.nvim',
  version = '*',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
    'MunifTanjim/nui.nvim',
  },
  lazy = false,
  keys = {
    { '\\', ':Neotree reveal<CR>', desc = 'NeoTree reveal', silent = true },
  },
  opts = {
    window = { position = 'right' },
    filesystem = {
      -- Display hidden folders/files
      filtered_items = {
        visible = true,
        hide_dotfiles = false,
        hide_gitignored = false,
        hide_by_name = { ".git", "node_modules" },
        never_show = { ".DS_Store" }
      },

      -- Mapping functions
      window = {
        mappings = {
          ['\\'] = 'close_window',
          -- disable `s` because it's used by user mappings (e.g. `sh`)
          ['s'] = false,
        },
      },
    },
  },
}
