local lsp = require('lsp')
local ws = require('lsp.ws')

local marksman_toml = ws.find('.marksman.toml')

if marksman_toml then
  lsp.start({
    name = 'marksman',
    cmd = { 'marksman', 'server' },
    workspace_folders = { marksman_toml },
  })
else
  -- lsp.start({
  --   name = 'vscode-markdown-language-server',
  --   cmd = { 'vscode-markdown-language-server', '--stdio' },
  --   init_options = {
  --     provideFormatter = true,
  --   },
  --   settings = {
  --     markdown = {
  --       validate = {
  --         enabled = true,
  --       },
  --     },
  --   },
  -- })
end
