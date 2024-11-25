local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

local theme = require('theme')

-- PLugins load
require("lazy").setup({
  theme,
  {
    -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    dependencies = {
      'JoosepAlviste/nvim-ts-context-commentstring',
      'nvim-treesitter/nvim-treesitter-textobjects',
    }
  },
  -- Additional lua configuration, makes nvim stuff amazing!
  -- it should be installed before lspconfig
  { 'folke/neodev.nvim', opts = {} },

  -- Jumping to anywhere by two characters
  { 'ggandor/leap.nvim' },
  { 'tpope/vim-repeat' },

  -- Jumping to anywhere
  { 'phaazon/hop.nvim',  version = "v2" },

  -- Dim inactive window
  { 'levouh/tint.nvim' },

  {
    -- make Neovim's fold look modern and keep high performance
    'kevinhwang91/nvim-ufo',
    dependencies = {
      'kevinhwang91/promise-async'
    }
  },


  -- Adds git releated signs to the gutter, as well as utilities for managing changes
  'lewis6991/gitsigns.nvim',

  -- Git diff
  'sindrets/diffview.nvim',

  -- Surround selections
  {
    "kylechui/nvim-surround",
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy",
  },

  -- Auto pairs {}, '', "", ()
  'windwp/nvim-ts-autotag',
  {
    "windwp/nvim-autopairs",
    dependencies = { "hrsh7th/nvim-cmp" },
    config = function()
      require("nvim-autopairs").setup {}
    end
  },

  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 200
    end,
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
    }
  },

  -- Tab pages
  {
    'akinsho/bufferline.nvim',
    version = "*",
    dependencies = 'nvim-tree/nvim-web-devicons'
  },

  -- Browse files/ folder
  -- It works well with bufferline
  {
    'nvim-tree/nvim-tree.lua',
    dependencies = {
      "nvim-tree/nvim-web-devicons"
    }
  },

  -- Status line
  {
    'nvim-lualine/lualine.nvim',
    opts = {
      options = {
        icons_enabled = false,
        theme = 'tokyonight',
        component_separators = '|',
        section_separators = '',
      }
    }
  },

  -- Add indentiation guides even on blank lines
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    ---@module "ibl"
    ---@type ibl.config
    opts = {
      -- char = '|',
      -- show_trailing_blankline_indent = false,
      -- -- context highlighting
      -- show_current_context = true,
      -- show_current_context_start = true,
    }
  },

  -- Vim plugin for automatically highlighting other uses
  -- of the word under the cursor using either LSP, Tree-sitter, or regex matching.
  {
    'RRethy/vim-illuminate'
  },

  -- "gc" to comment visual regions/lines
  -- Press `gcc` to toggle comments
  { 'numToStr/Comment.nvim', opts = {} },

  -- fuzzy finder (files, lsp, etc)
  {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim'
    }
  },

  -- LSP configuration & plugins
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      { 'williamboman/mason.nvim', config = true },
      'williamboman/mason-lspconfig.nvim',

      -- Useful status updates for LSP
      { 'j-hui/fidget.nvim',       branch = 'legacy', opts = {} }
    }
  },

  'onsails/lspkind-nvim',

  {
    -- Autocompletion
    'hrsh7th/nvim-cmp',
    dependencies = {
      -- Snippet Engine & its associated nvim-cmp source
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip',

      -- Adds LSP completion capabilities
      'hrsh7th/cmp-nvim-lsp',

      -- Adds a number of user-friendly snippets
      'rafamadriz/friendly-snippets',
    },
  },

  'weilbith/nvim-code-action-menu',

  -- Formatter
  {
    'jose-elias-alvarez/null-ls.nvim',
    dependencies = {
      "nvim-lua/plenary.nvim"
    }
  }

})
