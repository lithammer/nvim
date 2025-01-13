local lsp = require('lsp')

lsp.start({
  name = 'crystalline',
  cmd = { 'crystalline', '--stdio' },
  root_dir = vim.fs.root(0, 'shard.yml'),
})
