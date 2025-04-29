local finders = require('lspextras.finders')

---@type vim.lsp.Config
return {
  cmd = finders.node_modules_cmd({ 'oxc_language_server' }),
  filetypes = {
    'javascript',
    'javascriptreact',
    'typescript',
    'typescriptreact',
  },
  root_markers = { '.oxlintrc.json' },
  workspace_required = true,
}
