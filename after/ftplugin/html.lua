local lsp = require('lsp')

local has_superhtml = lsp.has_server('superhtml') == 1
local root_dir = vim.fs.root(0, 'package.json')

lsp.start({
  name = 'html',
  cmd = { 'vscode-html-language-server', '--stdio' },
  root_dir = root_dir,
  init_options = {
    provideFormatter = not has_superhtml,
  },
})

if has_superhtml then
  lsp.start({
    name = 'superhtml',
    cmd = { 'superhtml', 'lsp' },
    root_dir = root_dir,
  })
end
