local lsp = require('lsp')
local ws = require('lsp.ws')

lsp.start({
  name = 'taplo',
  cmd = { 'taplo', 'lsp', 'stdio' },
  workspace_folders = ws.git() or ws.cwd(),
})
