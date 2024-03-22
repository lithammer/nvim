local lsp = require('lsp')
local ws = require('lsp.ws')

lsp.start({
  name = 'jinja-lsp',
  cmd = { 'jinja-lsp' },
  workspace_folders = ws.git() or ws.cwd(),
  settings = {},
})
