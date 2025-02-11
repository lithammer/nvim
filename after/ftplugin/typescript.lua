local finders = require('lsp.finders')
local lsp = require('lsp')

lsp.start({
  name = 'vtsls',
  cmd = { 'vtsls', '--stdio' },
  root_dir = vim.fs.root(0, 'package.json'),
  settings = {
    typescript = {
      inlayHints = {
        parameterNames = { enabled = 'literals' },
        parameterTypes = { enabled = true },
        variableTypes = { enabled = true },
        propertyDeclarationTypes = { enabled = true },
        functionLikeReturnTypes = { enabled = true },
        enumMemberValues = { enabled = true },
      },
    },
  },
})

local biome_root_dir = vim.fs.root(0, { 'biome.json', 'biome.jsonc' })
local biome_bin = finders.node_modules_bin('biome')
if biome_root_dir and biome_bin then
  lsp.start({
    name = 'biome',
    cmd = { biome_bin, 'lsp-proxy' },
    root_dir = biome_root_dir,
  })
end
