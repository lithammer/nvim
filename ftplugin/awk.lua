local lsp = require('lsp')

lsp.start({
  name = 'awkls',
  cmd = { 'awk-language-server' },
})
