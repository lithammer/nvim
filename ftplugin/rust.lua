local lsp = require('lsp')
local ws = require('lsp.ws')

lsp.start({
  name = 'rust-analyzer',
  cmd = { 'rust-analyzer' },
  workspace_folders = ws.find('Cargo.toml'),
  settings = {
    ['rust-analyzer'] = {
      check = {
        command = 'clippy',
      },
      cargo = {
        features = 'all',
      },
      completion = {
        postfix = { enable = false },
      },
    },
  },
})
