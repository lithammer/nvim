-- https://github.com/oxc-project/oxc
-- https://oxc.rs/docs/guide/usage/linter.html

local npm = require('lspextras.npm')

---@type vim.lsp.Config
return {
  cmd = npm.node_modules_cmd({ 'oxlint', '--lsp' }),
  filetypes = {
    'javascript',
    'javascriptreact',
    'typescript',
    'typescriptreact',
  },
  root_dir = function(bufnr, on_dir)
    on_dir(vim.fs.root(bufnr, '.oxlintrc.json') or npm.find_package_json(bufnr, 'oxlint'))
  end,
  workspace_required = true,
}
