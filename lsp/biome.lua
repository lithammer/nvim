local finders = require('lspextras.finders')

---@type vim.lsp.Config
return {
  cmd = finders.node_modules_cmd({ 'biome', 'lsp-proxy' }),
  filetypes = {
    'css',
    'javascript',
    'javascriptreact',
    'typescript',
    'typescriptreact',
  },
  root_markers = { 'biome.json', 'biome.jsonc' },
  workspace_required = true,
}
