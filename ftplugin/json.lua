local lsp = require('lsp')
local ws = require('lsp.ws')

lsp.start({
  name = 'vscode-json-language-server',
  cmd = { 'vscode-json-language-server', '--stdio' },
  workspace_folders = ws.git() or ws.cwd(),
  init_options = {
    provideFormatter = true,
  },
  settings = {
    json = {
      format = { enable = true },
    },
  },
})

-- local biome_json = ws.find('biome.json', 'biome.jsonc')
-- if biome_json then
--   lsp.start({
--     name = 'biome',
--     cmd = { 'biome', 'lsp-proxy' },
--     workspace_folders = biome_json,
--   })
-- end
