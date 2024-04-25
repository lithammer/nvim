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
    pyright = {
      disableOrganizeImports = true,
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

if vim.fn.executable('ruff') == 1 then
  lsp.start({
    name = 'ruff',
    cmd = { 'ruff', 'server', '--preview' },
    workspace_folders = ws.find({ 'pyproject.toml', 'ruff.toml', '.ruff.toml' }),
    -- https://github.com/astral-sh/ruff/blob/main/crates/ruff_server/docs/setup/NEOVIM.md#tips
    on_attach = function(client)
      if client.name == 'ruff' then
        client.server_capabilities.hoverProvider = false
      end
    end,
    init_options = {
      settings = {
        args = {},
      },
    },
  })
end
