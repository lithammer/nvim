local lsp = require('lsp')

lsp.start({
  name = 'yaml-language-server',
  cmd = { 'yaml-language-server', '--stdio' },
  root_dir = vim.fs.root(0, { '.yamllint', '.yamllint.yaml', '.yamllint.yml' }),
  settings = {},
})
