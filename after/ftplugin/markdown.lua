local lsp = require('lsp')

lsp.start({
  name = 'vscode-markdown-language-server',
  cmd = { 'vscode-markdown-language-server', '--stdio' },
  init_options = {
    provideFormatter = true,
  },
})
