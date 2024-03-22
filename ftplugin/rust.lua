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
        features = 'all',
      },
      cargo = {
        features = 'all',
      },
      completion = {
        postfix = { enable = false },
        callable = { snippets = 'none' },
      },
    },
  },
})
