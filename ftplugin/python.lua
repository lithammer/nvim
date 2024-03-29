local lsp = require('lsp')
local ws = require('lsp.ws')

lsp.start({
  name = 'pyright',
  cmd = { 'pyright-langserver', '--stdio' },
  workspace_folders = ws.find({
    'pyrightconfig.json',
    'pyproject.toml',
    'setup.py',
    'setup.cfg',
    'requirements.txt',
  }),
  settings = {
    python = {
      analysis = {
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
        diagnosticMode = 'workspace',
      },
    },
  },
})
