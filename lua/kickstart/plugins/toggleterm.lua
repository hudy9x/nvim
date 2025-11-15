return {
  'akinsho/toggleterm.nvim',
  version = '*',
  opts = {--[[ things you want to change go here]]
    direction = 'float',

    float_opts = {
      border = 'curved', -- other options: 'single', 'double', 'shadow', 'rounded'
      width = 120,
      height = 30,
      winblend = 0, -- transparency (0 = solid, 100 = fully transparent)
    },
  },
}
