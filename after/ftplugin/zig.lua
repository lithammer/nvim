local lsp = require('lsp')

local root_dir = vim.fs.root(0, 'build.zig')
local zls_json = vim.fs.joinpath(root_dir, 'zls.json')
local args = vim.uv.fs_stat(zls_json) and { '--config-path', zls_json } or {}

lsp.start({
  name = 'zls',
  cmd = { 'zls', unpack(args) },
  root_dir = root_dir,
})
