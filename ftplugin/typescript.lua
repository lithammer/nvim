local finders = require('lsp.finders')
local lsp = require('lsp')
local ws = require('lsp.ws')

lsp.start({
  name = 'typescript-language-server',
  cmd = { 'typescript-language-server', '--stdio' },
  workspace_folders = ws.find('package.json'),
})

-- local biome_json = ws.find({ 'biome.json', 'biome.jsonc' })
-- if biome_json then
--   lsp.start({
--     name = 'biome',
--     cmd = { finders.node_modules_bin('biome'), 'lsp-proxy' },
--     workspace_folders = biome_json,
--   })
-- end
