local lsp = require('lsp')
local ws = require('lsp.ws')

lsp.start({
  name = 'vscode-css-language-server',
  cmd = { 'vscode-css-language-server', '--stdio' },
  workspace_folders = ws.find('package.json'),
  init_options = { provideFormatter = true },
  settings = {
    css = { validate = true },
    scss = { validate = true },
    less = { validate = true },
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
