local status, mason = pcall(require, 'mason')
if not status then return end

local stt_mason_conf, mason_config = pcall(require, 'mason-lspconfig')
if not stt_mason_conf then return end

local stt_lspconfig, lspconfig = pcall(require, 'lspconfig')
if not stt_lspconfig then return end

local lspkind = require('lspkind')

local servers = {
  lua_ls = {
    Lua = {
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
      diagnostics = {
        globals = { 'vim' }
      }
    }
  },
  rust_analyzer = {},
  ts_ls = {},
  tailwindcss = {},
  dockerls = {},
  prismals = {},
  gopls = {},
  bashls = {},
}

local on_attach = function(_, bufnr)
  local nmap = function(keys, func, desc)
    if desc then
      desc = 'LSP: ' .. desc
    end

    vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
  end

  nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')

  -- use nvim-code-action-menu for displaying options
  -- nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

  nmap('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
  -- nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
  -- nmap('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
  -- nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
  nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
  nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

  -- See `:help K` for why this keymap
  nmap('sd', vim.lsp.buf.hover, 'Hover Documentation')
  nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

  nmap(']d', vim.diagnostic.goto_next, 'Go to next diagnostic message')
  nmap('[d', vim.diagnostic.goto_prev, 'Go to previous diagnostic message')

  -- Lesser used LSP functionality
  nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
  nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
  nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
  nmap('<leader>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, '[W]orkspace [L]ist Folders')

  -- Create a command `:Format` local to the LSP buffer
  vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
    vim.lsp.buf.format()
  end, { desc = 'Format current buffer with LSP' })
end

-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

mason.setup()
mason_config.setup {
  ensure_installed = vim.tbl_keys(servers)
}

mason_config.setup_handlers {
  function(server_name)
    -- if (server_name == "tsserver") then
    --  lspconfig.tsserver.setup {
    --    capabilities = capabilities,
    --    on_attach = on_attach,
    --    cmd = { "typescript-language-server.cmd", "--stdio" }
    --  }
    --  return
    -- end


    lspconfig[server_name].setup {
      capabilities = capabilities,
      on_attach = on_attach,
      settings = servers[server_name]
    }
  end,
}

-- [[ Configure nvim-cmp ]]
-- See `:help cmp`
local cmp = require 'cmp'
local luasnip = require 'luasnip'
local cmpMenu = require 'utils.cmp-menu-appearance'
require('luasnip.loaders.from_vscode').lazy_load()
luasnip.config.setup {}

cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert {
    ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete {},
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_locally_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.locally_jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  },

  formatting = {
    -- format = lspkind.cmp_format({ with_text = false, maxwidth = 50 })

    -- how to get types on the left and offset the menu:
    -- https://github.com/hrsh7th/nvim-cmp/wiki/Menu-Appearance#how-to-get-types-on-the-left-and-offset-the-menu
    fields = { "kind", "abbr", "menu" },
    format = cmpMenu.format,

  }
}
