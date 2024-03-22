local lsp = require('lsp')
local ws = require('lsp.ws')

do
  local opt_local = vim.opt_local
  opt_local.commentstring = '# %s'
  opt_local.expandtab = true
  opt_local.shiftwidth = 2
  opt_local.softtabstop = 2
  opt_local.tabstop = 2
  opt_local.textwidth = 80
end

lsp.start({
  name = 'nimlangserver',
  cmd = { 'nimlangserver' },
  workspace_folders = ws.find(function(name, _path)
    return name:match('.*%.nimble$') ~= nil
  end),
})
