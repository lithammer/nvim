local lsp = require('lsp')
local ws = require('lsp.ws')

lsp.start({
  name = 'yaml-language-server',
  cmd = { 'yaml-language-server', '--stdio' },
  workspace_folders = ws.find({ '.yamllint', '.yamllint.yaml', '.yamllint.yml' }),
  settings = {},
})
