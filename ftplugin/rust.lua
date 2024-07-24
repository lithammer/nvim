local lsp = require('lsp')
local ws = require('lsp.ws')

local settings = {
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
}

lsp.start({
  name = 'rust-analyzer',
  cmd = { 'rust-analyzer' },
  workspace_folders = ws.find('Cargo.toml'),
  settings = settings,
  init_options = settings['rust-analyzer'],
})
