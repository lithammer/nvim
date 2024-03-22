local lsp = require('lsp')
local ws = require('lsp.ws')

lsp.start({
  name = 'crystalline',
  cmd = { 'crystalline', '--stdio' },
  workspace_folders = ws.find('shard.yml'),
})
