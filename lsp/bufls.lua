-- https://github.com/bufbuild/buf

---@type vim.lsp.Config
return {
  cmd = { 'buf', 'lsp', 'serve', '--timeout=0', '--log-format=text' },
  filetypes = { 'proto' },
  root_markers = { 'buf.yaml' },
  workspace_required = true,
}
