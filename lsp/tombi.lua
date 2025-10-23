-- https://github.com/tombi-toml/tombi

---@type vim.lsp.Config
return {
  cmd = { 'tombi', 'lsp' },
  filetypes = { 'toml' },
  root_markers = { 'tombi.toml', 'pyproject.toml' },
}
