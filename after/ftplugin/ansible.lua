local lsp = require('lsp')

lsp.start({
  name = 'ansiblels',
  cmd = { 'ansible-language-server', '--stdio' },
  root_dir = vim.fs.root(0, { 'ansible.cfg', 'requirements.yml', '.ansible-lint' }),
  settings = {},
})
