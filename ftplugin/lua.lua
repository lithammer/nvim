local lsp = require('lsp')
local ws = require('lsp.ws')

local now = MiniDeps.now

now(function()
  require('lazydev').setup({
    library = {
      { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
    },
    integrations = {
      lspconfig = false,
      cmp = false,
      coq = false,
    },
  })
end)

lsp.start({
  name = 'lua_ls',
  cmd = { 'lua-language-server' },
  workspace_folders = ws.find({ '.luarc.json', '.luarc.jsonc' }),
  settings = {},
})
