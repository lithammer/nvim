---@type vim.lsp.Config
return {
  cmd = { 'nimlangserver' },
  filetypes = { 'nim' },
  root_dir = function(bufnr, cb)
    local root = vim.fs.root(bufnr, function(name, _path)
      return name:match('.*%.nimble$') ~= nil
    end)
    cb(root)
  end,
}
