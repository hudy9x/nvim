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
- Imports: `local mod = require('module')`; require only at top-level or lazily via `pcall(require, ...)`.
- File/module names: use `snake_case` for `lua/` filenames and module paths.
- Locals/functions: prefer `camelCase` for local variables and functions; use `PascalCase` only for module/table constructors.
- Constants: `UPPER_SNAKE` for global/constant values (rare in config).
- Types/annotations: use EmmyLua annotations (`---@param`, `---@return`, `---@type`) for public APIs and complex functions.
- Error handling: prefer `pcall` for optional requires; validate return values and propagate errors with clear messages; check `vim.v.shell_error` after shell calls.

CI / rules
- There is a GitHub action for `stylua` at `.github/workflows/stylua.yml`.
- No Cursor rules or Copilot instructions detected in this repo; none included.

Keep edits minimal and follow existing patterns in `init.lua` and `lua/` modules.