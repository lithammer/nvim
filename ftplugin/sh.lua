local lsp = require('lsp')
local ws = require('lsp.ws')

lsp.start({
  name = 'bash-language-server',
  cmd = { 'bash-language-server', 'start' },
  workspace_folders = ws.git() or ws.cwd(),
})

lsp.start({
  name = 'diagnostic-languageserver',
  cmd = { 'diagnostic-languageserver', '--stdio' },
  workspace_folders = ws.find('.editorconfig') or ws.git() or ws.cwd(),
  init_options = {
    formatters = {
      shfmt = {
        command = 'shfmt',
        args = { '--filename', '%filepath' },
        rootPatterns = { '.editorconfig' },
      },
    },
    formatFiletypes = {
      sh = { 'shfmt' },
    },
  },
})
