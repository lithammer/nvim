---@type vim.lsp.Config
return {
  cmd = { 'typos-lsp' },
  cmd_env = { RUST_LOG = 'error' },
  root_markers = { 'typos.toml', '_typos.toml', '.typos.toml' },
  filetypes = {
    'go',
    'lua',
    'python',
    'rust',
    'yaml',
  },
  init_options = {
    diagnosticSeverity = 'Information',
  },
}
