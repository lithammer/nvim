local lsp = require('lsp')

lsp.start({
  name = 'gleam',
  cmd = { 'gleam', 'lsp' },
  root_dir = vim.fs.root(0, 'gleam.toml'),
})
