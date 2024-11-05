local finders = require('lsp.finders')
local lsp = require('lsp')
local ws = require('lsp.ws')

local zls_json = finders.find('zls.json')
local args = zls_json and { '--config-path', zls_json } or {}

lsp.start({
  name = 'zls',
  cmd = { 'zls', unpack(args) },
  workspace_folders = ws.find('build.zig'),
})
