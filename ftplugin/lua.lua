local lsp = require('lsp')
local ws = require('lsp.ws')

local now = MiniDeps.now

now(function()
  require('lazydev').setup()
end)

lsp.start({
  name = 'lua-language-server',
  cmd = { 'lua-language-server' },
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
