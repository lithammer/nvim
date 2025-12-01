-- https://github.com/bufbuild/buf

---@type vim.lsp.Config
return {
  cmd = { 'buf', 'lsp', 'serve', '--timeout=0', '--log-format=text' },
  filetypes = { 'proto' },
  root_markers = { 'buf.yaml' },
  workspace_required = true,
  reuse_client = function(client, config)
    -- `buf lsp serve` is meant to be used with multiple workspaces.
    return client.name == config.name
  end,
}
