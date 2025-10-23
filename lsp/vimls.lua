-- https://github.com/iamcco/vim-language-server

---@type vim.lsp.Config
return {
  cmd = { 'vim-language-server', '--stdio' },
  filetypes = { 'vim' },
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
}
