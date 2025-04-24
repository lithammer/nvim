---@type vim.lsp.Config
return {
  cmd = { 'basedpyright-langserver', '--stdio' },
  filetypes = { 'python' },
  root_markers = {
    'pyrightconfig.json',
    'pyproject.toml',
    'setup.py',
    'setup.cfg',
    'requirements.txt',
  },
  settings = {
    -- https://docs.basedpyright.com/latest/configuration/language-server-settings/
    basedpyright = {
      analysis = {
        autoSearchPaths = true,
        diagnosticMode = 'openFilesOnly',
        fileEnumerationTimeout = 30,
        typeCheckingMode = 'basic',
        useLibraryCodeForTypes = true,
      },
      disableOrganizeImports = true, -- Disable in favour of Ruff.
    },
  },
}
