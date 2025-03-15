---@type vim.lsp.Config
return {
  cmd = { 'crystalline', '--stdio' },
  filetypes = { 'crystal' },
  root_markers = { 'shard.yml' },
}
