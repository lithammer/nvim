local lsp = require('lsp')
local ws = require('lsp.ws')

lsp.start({
  name = 'ansiblels',
  cmd = { 'ansible-language-server', '--stdio' },
  workspace_folders = ws.find({ 'ansible.cfg', 'requirements.yml', '.ansible-lint' }),
  settings = {},
})
