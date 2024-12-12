local lsp = require('lsp')
local ws = require('lsp.ws')

lsp.start({
  name = 'gleam',
  cmd = { 'gleam', 'lsp' },
  workspace_folders = ws.find('gleam.toml'),
})
