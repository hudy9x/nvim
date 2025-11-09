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

CI / rules
- There is a GitHub action for `stylua` at `.github/workflows/stylua.yml`.
- No Cursor rules or Copilot instructions detected in this repo; none included.