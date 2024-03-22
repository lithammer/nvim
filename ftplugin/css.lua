local lsp = require('lsp')
local ws = require('lsp.ws')

lsp.start({
  name = 'vscode-css-language-server',
  cmd = { 'vscode-css-language-server', '--stdio' },
  workspace_folders = ws.find('package.json') or ws.git(),
  init_options = { provideFormatter = true },
  settings = {
    css = { validate = true },
    scss = { validate = true },
    less = { validate = true },
  },
})
