local lsp = require('lsp')

lsp.start({
  name = 'taplo',
  cmd = { 'taplo', 'lsp', 'stdio' },
})