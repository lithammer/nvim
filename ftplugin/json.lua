local lsp = require('lsp')

lsp.start({
  name = 'vscode-json-language-server',
  cmd = { 'vscode-json-language-server', '--stdio' },
  init_options = {
    provideFormatter = true,
  },
  settings = {
    json = {
      format = { enable = true },
    },
  },
})
