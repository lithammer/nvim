local finders = require('lspextras.finders')

local biome_bin = finders.node_modules_bin('biome') or 'biome'

---@type vim.lsp.Config
return {
  cmd = { biome_bin, 'lsp-proxy' },
  filetypes = {
    'javascript',
    'javascriptreact',
    'typescript',
    'typescriptreact',
  },
  root_dir = function(bufnr, cb)
    local biome_root_dir = vim.fs.root(bufnr, { 'biome.json', 'biome.jsonc' })
    if biome_root_dir then
      cb(biome_root_dir)
    end
  end,
}
