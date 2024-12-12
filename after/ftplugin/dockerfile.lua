local lsp = require('lsp')

lsp.start({
  name = 'dockerls',
  cmd = { 'docker-langserver', '--stdio' },
})
