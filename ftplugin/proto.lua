local lsp = require('lsp')
local ws = require('lsp.ws')

local fn, fs = vim.fn, vim.fs

lsp.start({
  name = 'protobuf-language-server',
  cmd = {
    'protobuf-language-server',
    '-logs',
    fs.joinath(fn.stdpath('log'), 'protobuf-language-server.log'),
  },
  workspace_folders = ws.git() or ws.cwd(),
})
