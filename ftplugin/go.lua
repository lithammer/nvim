local lsp = require('lsp')
local ws = require('lsp.ws')

lsp.start({
  name = 'gopls',
  cmd = { 'gopls', 'serve' },
  workspace_folders = ws.find('go.work') or ws.find('go.mod'),
  settings = {
    gopls = {
      analyses = {
        nilness = true,
        unusedparams = true,
        unusedwrite = true,
        useany = true,
      },
      hoverKind = 'FullDocumentation',
      linksInHover = false,
      gofumpt = true,
      completeUnimported = true,
      -- https=//github.com/yegappan/lsp/issues/126
      semanticTokens = true,
      staticcheck = true,
      usePlaceholders = true,
      completionDocumentation = true,
      codelenses = {
        generate = true,
        test = true,
        run_vulncheck_exp = true,
      },
      hints = {
        assignVariableTypes = true,
        compositeLiteralFields = true,
        compositeLiteralTypes = true,
        constantValues = true,
        functionTypeParameters = true,
        parameterNames = true,
        rangeVariableTypes = true,
      },
    },
  },
})
