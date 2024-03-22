local lsp = require('lsp')
local ws = require('lsp.ws')

lsp.start({
  name = 'zls',
  cmd = { 'zls' },
  workspace_folders = ws.find({ 'zls.json', 'build.zig' }) or ws.cwd(),
  settings = {
    -- zls = {
    -- enable_build_on_save = true,
    -- warn_style = true,
    -- },
  },
})
