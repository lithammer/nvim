-- https://github.com/tilt-dev/starlark-lsp

---@type vim.lsp.Config
return {
  cmd = { 'starlark', '--lsp' },
  filetypes = { 'bzl' },
  root_markers = { 'WORKSPACE' },
}
