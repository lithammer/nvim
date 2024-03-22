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

-- vim.lsp.start({
--   name = 'diagnostic-languageserver',
--   cmd = { 'diagnostic-languageserver', '--stdio' },
--   workspace_folders = ws.find({
--     'ruff.toml',
--     '.ruff.toml',
--     'pyrightconfig.json',
--     'pyproject.toml',
--     'setup.py',
--     'setup.cfg',
--     'requirements.txt',
--   }),
--   init_options = {
--     formatters = {
--       ruff = {
--         command = 'ruff',
--         args = { 'format', '-' },
--         rootPatterns = { 'pyproject.toml', 'ruff.toml', '.ruff.toml' },
--         requiredFiles = { 'pyproject.toml', 'ruff.toml', '.ruff.toml' },
--       },
--     },
--     formatFiletypes = {
--       python = { 'ruff' },
--     },
--   },
-- })
