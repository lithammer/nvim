local lsp = require('lsp')

lsp.start({
  name = 'vimls',
  cmd = { 'vim-language-server', '--stdio' },
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
