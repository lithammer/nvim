local lsp = require('lsp')
local ws = require('lsp.ws')

local has_superhtml = lsp.has_server('superhtml') == 1
local workspace_folders = ws.find('package.json') or ws.git() or ws.cwd()

lsp.start({
  name = 'vscode-html-language-server',
  cmd = { 'vscode-html-language-server', '--stdio' },
  workspace_folders = workspace_folders,
  init_options = {
    provideFormatter = not has_superhtml,
  },
})

if has_superhtml then
  lsp.start({
    name = 'superhtml',
    cmd = { 'superhtml', 'lsp' },
    workspace_folders = workspace_folders,
  })
end
