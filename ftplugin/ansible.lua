local lsp = require('lsp')
local ws = require('lsp.ws')

lsp.start({
  name = 'ansible-language-server',
  cmd = { 'ansible-language-server', '--stdio' },
  workspace_folders = ws.find({ 'ansible.cfg', 'requirements.yml', '.ansible-lint' })
    or ws.git()
    or ws.cwd(),
  settings = {},
})
