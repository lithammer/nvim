-- https://github.com/oxc-project/oxc
-- https://oxc.rs/docs/guide/usage/formatter

local npm = require('lspextras.npm')

---@type vim.lsp.Config
return {
  cmd = npm.node_modules_cmd({ 'oxfmt', '--lsp' }),
  filetypes = {
    'javascript',
    'javascriptreact',
    'typescript',
    'typescriptreact',
  },
  root_dir = function(bufnr, on_dir)
    on_dir(vim.fs.root(bufnr, '.oxfmtrc.json') or npm.find_package_json(bufnr, 'oxfmt'))
  end,
  workspace_required = true,
  init_options = {
    {
      options = {
        ['fmt.experimental'] = true,
      },
    },
  },
}
