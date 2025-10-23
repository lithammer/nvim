-- https://github.com/nim-lang/langserver

---@type vim.lsp.Config
return {
  cmd = { 'nimlangserver' },
  filetypes = { 'nim' },
  root_dir = function(bufnr, on_dir)
    local root = vim.fs.root(bufnr, function(name, _path)
      return name:match('.*%.nimble$') ~= nil
    end)
    on_dir(root)
  end,
}
