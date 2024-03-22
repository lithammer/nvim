local lsp = require('lsp')

lsp.start({
  name = 'docker-langserver',
  cmd = { 'docker-langserver', '--stdio' },
})
