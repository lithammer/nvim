local lsp = require('lsp')
local ws = require('lsp.ws')

local fn, fs = vim.fn, vim.fs

lsp.start({
  name = 'protobuf-language-server',
  cmd = {
    'protobuf-language-server',
    '-logs',
    fs.joinpath(fn.stdpath('log') --[[@as string]], 'protobuf-language-server.log'),
  },
  workspace_folders = ws.git() or ws.cwd(),
})
