local lsp = require('lsp')
local ws = require('lsp.ws')

lsp.start({
  name = 'vim-language-server',
  cmd = { 'vim-language-server', '--stdio' },
  workspace_folders = ws.git(),
  init_options = {
    isNeovim = true,
    indexes = {
      projectRootPatterns = {
        '.git',
        'nvim',
        'autoload',
        'plugin',
      },
    },
  },
})
