AGENTS - repository agent rules

Build / lint / test (local)
- Format: `stylua .` (uses .stylua.toml). Check-only: `stylua --check .`
- Lint (optional): `luacheck .` (if installed)
- Run config (headless): `nvim --headless -c 'luafile ./init.lua' -c 'quit'`
- Tests (Lua): use `busted` in `spec/` (convention)
  - Run a single file: `busted spec/some_spec.lua`
  - Run a single test: `busted -g "pattern"` or `busted spec/some_spec.lua:LINE`

Style guidelines
- Formatting: rely on `stylua` (2-space indent, configured via .stylua.toml).
- Imports: `local mod = require('module')`; prefer top-level requires or lazy `pcall(require, ...)`.
- File/module names: use `snake_case` for `lua/` filenames and module paths; keep `lua/custom/*.lua` for user splits.
- Locals/functions: prefer `camelCase` for local variables and functions; use `PascalCase` only for module/table constructors.
- Types/annotations: use EmmyLua (`---@param`, `---@return`, `---@type`) for public APIs.
- Error handling: prefer `pcall` for optional requires; validate returns and check `vim.v.shell_error` after shell calls.

Notes for agents
- Keymaps and settings are modularized: `lua/custom/map.lua` and `lua/custom/setting.lua` exist.
  - Load them from `init.lua` with `require('custom.map')` and `require('custom.setting')`.
  - Keep mapping-only logic in `map.lua` and option-only logic in `setting.lua`.

Adding plugins and themes
- Create a plugin module in `lua/kickstart/plugins/` using a `snake_case` filename, e.g. `lua/kickstart/plugins/my_plugin.lua`.
  - The module should return a plugin spec table or call `require('lazy').setup`-compatible entries. Example minimal file:

    -- lua/kickstart/plugins/my_plugin.lua
    return { 'owner/repo', opts = {}, config = function() end }

  - To load it from `init.lua`, add the module to the `require('lazy').setup({ ... })` list, for example:

    require 'kickstart.plugins.my_plugin',

  - Alternatively, add plugin specs to `lua/custom/plugins/*.lua` and enable automatic import by uncommenting the line `{ import = 'custom.plugins' },` in `init.lua`.

- Themes: create `lua/themes/<theme>.lua` (snake_case) and require it inside the plugins list, matching existing pattern, e.g. `require 'themes.my_theme'`.
  - Example: `lua/themes/tokyonight.lua` and in `init.lua` use `require 'themes.tokyonight'`.

- After adding files, restart Neovim and run `:Lazy` to view/install/manage plugins. Use `:Lazy install`, `:Lazy sync`, or `:Lazy update` as needed.
- Quick config test (headless): `nvim --headless -c 'luafile ./init.lua' -c 'quit'`.
- Format changes with `stylua .` and check with `stylua --check .`.

CI / rules
- There is a GitHub action for `stylua` at `.github/workflows/stylua.yml`.
- No Cursor rules or Copilot instructions detected in this repo; none included.

Telescope: updating excluded folders/files
- File: `lua/kickstart/plugins/telescope.lua:79` (keymaps and find overrides)
- To show files that are normally gitignored but still exclude specific folders, update the `find_command` used in the keymap that calls `builtin.find_files`.

```

    vim.keymap.set('n', ';f', function()
      builtin.find_files {
        hidden = true,
        no_ignore = true,
        no_ignore_vcs = true,
        -- Use fd to explicitly exclude certain directories
        find_command = {
          'fd',
          '--type',
          'f',
          '--hidden',
          '--follow',

          '--exclude',
          '.git',

          '--exclude',
          'node_modules',

          '--exclude',
          '.vercel',

          '--exclude',
          '.next'
        },
      }
    end, { desc = '[S]earch [F]iles' })
```


- Notes:
  - `find_command` runs an external program directly (e.g. `fd` or `rg`) — ensure the program is installed.
  - `--exclude` for `fd` or `--glob '!<path>/**'` for `rg` will hide those paths even when `no_ignore = true`.
  - Restart Neovim or reload your config after changes and test the keymap (e.g. `;f` or `;F`).
