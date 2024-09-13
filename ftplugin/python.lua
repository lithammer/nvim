local lsp = require('lsp')
local ws = require('lsp.ws')

local has_ruff = lsp.has_server('ruff')

lsp.start({
  name = 'pyright',
  cmd = { 'pyright-langserver', '--stdio' },
  workspace_folders = ws.find({
    'pyrightconfig.json',
    'pyproject.toml',
    'setup.py',
    'setup.cfg',
    'requirements.txt',
  }) or ws.cwd(),
  settings = {
    pyright = {
      disableOrganizeImports = has_ruff,
    },
    python = {
      analysis = {
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
        diagnosticMode = 'workspace',
      },
    },
  },
})

-- https://docs.astral.sh/ruff/editors/setup/#neovim
if has_ruff then
  lsp.start({
    name = 'ruff',
    cmd = { 'ruff', 'server' },
    workspace_folders = ws.find({ 'pyproject.toml', 'ruff.toml', '.ruff.toml' }),
    on_attach = function(client)
      -- Disable hover in favour of Pyright.
      client.server_capabilities.hoverProvider = false
    end,
    init_options = {
      settings = {
        args = {},
      },
    },
  })
end
