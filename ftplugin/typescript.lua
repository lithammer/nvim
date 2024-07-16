local finders = require('lsp.finders')
local lsp = require('lsp')
local ws = require('lsp.ws')

lsp.start({
  name = 'vtsls',
  cmd = { 'vtsls', '--stdio' },
  workspace_folders = ws.find('package.json'),
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

-- Buggy together with vtsls'. Removes completetion after dot.
vim.opt.completeopt:remove({ 'longest' })

-- local biome_json = ws.find({ 'biome.json', 'biome.jsonc' })
-- if biome_json then
--   lsp.start({
--     name = 'biome',
--     cmd = { finders.node_modules_bin('biome'), 'lsp-proxy' },
--     workspace_folders = biome_json,
--   })
-- end
