local lsp = require('lsp')
local ws = require('lsp.ws')

local now = MiniDeps.now
local fn = vim.fn

now(function()
  require('lazydev').setup({
    library = {
      { path = 'luvit-meta/library', words = { 'vim%.uv' } },
    },
    integrations = {
      lspconfig = false,
      cmp = false,
      coq = false,
    },
  })
end)

local workspace_folders = ws.find({ '.luarc.json', '.luarc.jsonc' }) or ws.git()
if not workspace_folders then
  if fn.getcwd() ~= vim.env.HOME then
    workspace_folders = ws.cwd()
  else
    workspace_folders = ws.bufdir()
  end
end

lsp.start({
  name = 'lua_ls',
  cmd = { 'lua-language-server' },
  workspace_folders = workspace_folders,
  settings = {},
})
