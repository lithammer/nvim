local lsp = require('lsp')
local ws = require('lsp.ws')

lsp.start({
  name = 'awk-language-server',
  cmd = { 'awk-language-server' },
  workspace_folders = ws.cwd(),
})
