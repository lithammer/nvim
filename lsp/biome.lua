local finders = require('lspextras.finders')

local biome_bin = finders.node_modules_bin('biome') or 'biome'

---@type vim.lsp.Config
return {
  cmd = { biome_bin, 'lsp-proxy' },
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
