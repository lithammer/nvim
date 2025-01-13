local lsp = require('lsp')

lsp.start({
  name = 'cssls',
  cmd = { 'vscode-css-language-server', '--stdio' },
  root_dir = vim.fs.root(0, 'package.json'),
  init_options = { provideFormatter = true },
  settings = {
    css = { validate = true },
    scss = { validate = true },
    less = { validate = true },
  },
})
