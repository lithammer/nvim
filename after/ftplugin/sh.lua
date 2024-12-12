local lsp = require('lsp')

lsp.start({
  name = 'bashls',
  cmd = { 'bash-language-server', 'start' },
})
