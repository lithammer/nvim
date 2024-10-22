local lsp = require('lsp')

local fn, fs = vim.fn, vim.fs

lsp.start({
  name = 'protobuf-language-server',
  cmd = {
    'protobuf-language-server',
    '-logs',
    fs.joinpath(fn.stdpath('log') --[[@as string]], 'protobuf-language-server.log'),
  },
})
