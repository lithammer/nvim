local lsp = require('lsp')

lsp.start({
  name = 'clangd',
  cmd = { 'clangd', '--clang-tidy' },
  root_dir = vim.fs.root(0, { '.clangd', 'compile_commands.json' }),
})
