---@diagnostic disable-next-line: missing-fields
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
    local luarc_path = vim.fs.joinpath(root_dir, '.luarc.json')

    if vim.uv.fs_stat(luarc_path) then
      local luarc = vim.json.decode(vim.fn.readblob(luarc_path))
      local lib = vim.tbl_get(luarc, 'workspace', 'library')
      if lib and not vim.tbl_isempty(lib) then
        return false
      end
    end

    return true
  end,
})
