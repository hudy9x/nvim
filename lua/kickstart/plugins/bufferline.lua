-- lua/kickstart/plugins/bufferline.lua
return {
  'akinsho/bufferline.nvim',
  version = '*',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  opts = {
    options = {
      numbers = 'none',
      diagnostics = 'nvim_lsp',
      offsets = {
        { filetype = 'neo-tree', text = 'Explorer', text_align = 'left' },
      },
      show_buffer_icons = true,
      show_close_icon = false,
      separator_style = 'thin',
    },
  },
}
