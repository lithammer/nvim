local lsp = require('lsp')

lsp.start({
  name = 'awk-language-server',
  cmd = { 'awk-language-server' },
})
