-- https://github.com/withered-magic/starpls

---@type vim.lsp.Config
return {
  cmd = { 'starpls' },
  filetypes = { 'bzl' },
  root_markers = { 'WORKSPACE' },
}
