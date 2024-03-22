local lsp = require('lsp')
local ws = require('lsp.ws')

lsp.start({
  name = 'vscode-html-language-server',
  cmd = { 'vscode-html-language-server', '--stdio' },
  workspace_folders = ws.find('package.json') or ws.git() or ws.cwd(),
  init_options = {
    provideFormatter = true,
  },
})
