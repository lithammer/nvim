local lsp = require('lsp')

lsp.start({
  name = 'vim-language-server',
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
