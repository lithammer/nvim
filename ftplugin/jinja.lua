local lsp = require('lsp')

lsp.start({
  name = 'jinja_lsp',
  cmd = { 'jinja-lsp' },
  settings = {},
})
