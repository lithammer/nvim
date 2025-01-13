local lsp = require('lsp')

local fn, fs, uv = vim.fn, vim.fs, vim.uv
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
    enabled = function(root_dir)
      local luarc_path = fs.joinpath(root_dir, '.luarc.json')

      if uv.fs_stat(luarc_path) then
        local luarc = vim.json.decode(fn.readblob(luarc_path))
        local lib = vim.tbl_get(luarc, 'workspace', 'library')
        if lib and not vim.tbl_isempty(lib) then
          return false
        end
      end

      return true
    end,
  })
end)

lsp.start({
  name = 'lua_ls',
  cmd = { 'lua-language-server' },
  root_dir = vim.fs.root(0, { '.luarc.json', '.luarc.jsonc' }),
  settings = {},
})
