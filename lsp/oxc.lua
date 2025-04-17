local finders = require('lspextras.finders')

local oxc_bin = finders.node_modules_bin('oxc_language_server') or 'oxc_language_server'

---@type vim.lsp.Config
return {
  cmd = { oxc_bin },
  filetypes = {
    'javascript',
    'javascriptreact',
    'typescript',
    'typescriptreact',
  },
  root_dir = function(bufnr, cb)
    local oxlint_root_dir = vim.fs.root(bufnr, { '.oxlintrc.json' })
    if oxlint_root_dir then
      cb(oxlint_root_dir)
    end
  end,
}
