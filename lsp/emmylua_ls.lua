-- https://github.com/EmmyLuaLs/emmylua-analyzer-rust

---@type vim.lsp.Config
return {
  cmd = { 'emmylua_ls' },
  filetypes = { 'lua' },
  root_markers = { '.emmyrc.json', '.luarc.json', '.luarc.jsonc' },
  settings = {},
}
