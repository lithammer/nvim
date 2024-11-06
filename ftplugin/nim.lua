local lsp = require('lsp')
local ws = require('lsp.ws')

do
  local bo = vim.bo
  bo.commentstring = '# %s'
  bo.expandtab = true
  bo.shiftwidth = 2
  bo.softtabstop = 2
  bo.tabstop = 2
  bo.textwidth = 80
end

lsp.start({
  name = 'nim_langserver',
  cmd = { 'nimlangserver' },
  workspace_folders = ws.find(function(name, _path)
    return name:match('.*%.nimble$') ~= nil
  end),
})
