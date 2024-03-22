local lsp = require('lsp')
local ws = require('lsp.ws')

vim.cmd.packadd('neodev.nvim')
require('neodev').setup({ lspconfig = false })

lsp.start({
  name = 'lua-language-server',
  cmd = { 'lua-language-server' },
  before_init = require('neodev.lsp').before_init,
  workspace_folders = ws.find({
    '.luarc.json',
    '.luarc.jsonc',
    '.luacheckrc',
    '.stylua.toml',
    'stylua.toml',
    'selene.toml',
    'selene.yml',
  }),
  settings = {
    Lua = {
      completion = {
        -- callSnippet = 'Replace',
        -- keywordSnippet = 'Replace',
        callSnippet = 'Disable',
        keywordSnippet = 'Disable',
      },
      diagnostics = {
        unusedLocalExclude = { '_*' },
      },
      format = {
        enable = false,
        defaultConfig = {
          indent_style = 'space',
          indent_size = '2',
          continuation_indent_size = '2',
          quote_style = 'single',
        },
      },
      hint = {
        enable = true,
        arrayIndex = 'Disable',
      },
      workspace = {
        checkThirdParty = false,
      },
    },
  },
})

-- lsp.start({
--   name = 'diagnostic-languageserver',
--   cmd = { 'diagnostic-languageserver', '--stdio' },
--   workspace_folders = ws.git() or ws.cwd(),
--   init_options = {
--     formatters = {
--       stylua = {
--         command = 'stylua',
--         args = { '-' },
--         rootPatterns = { 'stylua.toml', '.stylua.toml', '.editorconfig' },
--         requiredFiles = { 'stylua.toml', '.stylua.toml', '.editorconfig' },
--       },
--     },
--     formatFiletypes = {
--       lua = { 'stylua' },
--     },
--   },
-- })
