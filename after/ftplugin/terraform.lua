local lsp = require('lsp')

lsp.start({
  name = 'terraformls',
  cmd = { 'terraform-ls', 'serve' },
  settings = {},
})
