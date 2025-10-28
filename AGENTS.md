AGENTS.md — Agent guidance for this Neovim config

Purpose
- Short: guidelines for agents editing this repo (Neovim Lua config)

Build / lint / test
- Load config headless: `nvim --headless -u ./init.lua +qa`
- Format all Lua: `stylua .` (single file: `stylua path/to/file.lua`)
- Lint: `luacheck . --globals vim --std lua54`
- Run tests (busted): `busted` (single test: `busted spec/path/to_spec.lua`)
- Quick require-check: `lua -e "print(require('plenary.reload').reload_module('your.module'))"`

Code style (summary)
- Formatting: run `stylua` before commits; follow existing indent and alignment.
- Imports/modules: use `local M = {}`; `local mod = require('mod')`; avoid polluting globals (use `return M`).
- Naming: use `snake_case` for functions/vars, `PascalCase` or `ModuleName` for module tables, `UPPER_SNAKE` for constants.
- Types & annotations: add EmmyLua annotations when helpful: `---@param`, `---@return` for LSP support.
- Error handling: prefer `local ok, mod = pcall(require, 'mod')` and `if not ok then vim.notify(mod, vim.log.levels.ERROR) end`.
- Side effects: minimize global state; prefer returning functions/tables from modules.
- Tests: keep specs under `spec/` and run single specs with `busted spec/name_spec.lua`.

Cursor/Copilot rules
- No `.cursor` or Copilot instruction files detected in repo; follow repository defaults.

Notes
- Respect existing file layout under `lua/` and `plugin/` when adding modules.
- Ask before broad refactors; keep changes minimal and focused.