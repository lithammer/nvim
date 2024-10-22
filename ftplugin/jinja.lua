local lsp = require('lsp')

lsp.start({
  name = 'jinja-lsp',
  cmd = { 'jinja-lsp' },
  settings = {},
})
