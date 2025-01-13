-- local finders = require('lsp.finders')
local lsp = require('lsp')

lsp.start({
  name = 'vtsls',
  cmd = { 'vtsls', '--stdio' },
  root_dir = vim.fs.root(0, 'package.json'),
  settings = {
    typescript = {
      inlayHints = {
        parameterNames = { enabled = 'literals' },
        parameterTypes = { enabled = true },
        variableTypes = { enabled = true },
        propertyDeclarationTypes = { enabled = true },
        functionLikeReturnTypes = { enabled = true },
        enumMemberValues = { enabled = true },
      },
    },
  },
})
