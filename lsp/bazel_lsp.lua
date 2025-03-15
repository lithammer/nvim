---@type vim.lsp.Config
return {
  cmd = { 'bazel-lsp' },
  filetypes = { 'bzl' },
  root_markers = { 'WORKSPACE' },
}
