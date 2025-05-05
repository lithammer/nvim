local npm = require('lspextras.npm')

---@type vim.lsp.Config
return {
  cmd = npm.node_modules_cmd({ 'oxc_language_server' }),
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
