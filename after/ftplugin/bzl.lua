local lsp = require('lsp')

local root_dir = vim.fs.root(0, 'WORKSPACE')

lsp.start({
  name = 'bazel-lsp',
  cmd = { 'bazel-lsp' },
  root_dir = root_dir,
  settings = {},
})

lsp.start({
  name = 'starpls',
  cmd = { 'starpls' },
  root_dir = root_dir,
  settings = {},
})

-- lsp.start({
--   name = 'starlark',
--   cmd = { 'starlark', '--lsp' },
--   root_dir = root_dir,
--   settings = {},
-- })
