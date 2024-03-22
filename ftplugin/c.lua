local lsp = require('lsp')
local ws = require('lsp.ws')

lsp.start({
  name = 'clangd',
  cmd = { 'clangd', '--clang-tidy' },
  workspace_folders = ws.find({ '.clangd', 'compile_commands.json' }) or ws.git(),
})
