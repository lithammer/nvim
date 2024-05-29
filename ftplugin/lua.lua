local lsp = require('lsp')
local ws = require('lsp.ws')

require('neodev').setup({ lspconfig = false })

lsp.start({
  name = 'lua-language-server',
  cmd = { 'lua-language-server' },
  before_init = require('neodev.lsp').before_init,
  workspace_folders = ws.find({ '.luarc.json', '.luarc.jsonc' }),
  settings = {
    Lua = {
      completion = {
        callSnippet = 'Replace',
        keywordSnippet = 'Replace',
      },
    },
  },
})
