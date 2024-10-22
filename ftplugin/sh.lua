local lsp = require('lsp')

lsp.start({
  name = 'bash-language-server',
  cmd = { 'bash-language-server', 'start' },
})
