local lsp = require('lsp')

lsp.start({
  name = 'yaml-language-server',
  cmd = { 'yaml-language-server', '--stdio' },
  settings = {},
})
