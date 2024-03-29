local lsp = require('lsp')
local ws = require('lsp.ws')

lsp.start({
  name = 'bash-language-server',
  cmd = { 'bash-language-server', 'start' },
  workspace_folders = ws.git() or ws.cwd(),
})
