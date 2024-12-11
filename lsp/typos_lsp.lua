vim.lsp.config('typos_lsp', {
  cmd = { 'typos-lsp' },
  cmd_env = { RUST_LOG = 'error' },
  root_markers = { 'typos.toml', '_typos.toml', '.typos.toml' },
  init_options = {
    diagnosticSeverity = 'Information',
  },
  filetypes = { 'lua', 'go', 'yaml' },
})
