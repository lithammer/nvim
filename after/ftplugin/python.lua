local lsp = require('lsp')

local has_ruff = lsp.has_server('ruff')

lsp.start({
  name = 'pyright',
  cmd = { 'pyright-langserver', '--stdio' },
  root_dir = vim.fs.root(0, {
    'pyrightconfig.json',
    'pyproject.toml',
    'setup.py',
    'setup.cfg',
    'requirements.txt',
  }),
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
    root_dir = vim.fs.root(0, { 'pyproject.toml', 'ruff.toml', '.ruff.toml' }),
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
