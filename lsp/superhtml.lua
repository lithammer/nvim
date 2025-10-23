-- https://github.com/kristoff-it/superhtml

---@type vim.lsp.Config
return {
  cmd = { 'superhtml', 'lsp' },
  filetypes = { 'html' },
  root_markers = { 'package.json' },
}
