-- https://github.com/cameron-martin/bazel-lsp

---@type vim.lsp.Config
return {
  cmd = { 'bazel-lsp' },
  filetypes = { 'bzl' },
  root_markers = { 'WORKSPACE' },
}
