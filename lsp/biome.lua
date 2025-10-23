-- https://github.com/biomejs/biome

local npm = require('lspextras.npm')

---@type vim.lsp.Config
return {
  cmd = npm.node_modules_cmd({ 'biome', 'lsp-proxy' }),
  filetypes = {
    'css',
    'javascript',
    'javascriptreact',
    'typescript',
    'typescriptreact',
  },
  root_markers = { 'biome.json', 'biome.jsonc' },
  root_dir = function(bufnr, on_dir)
    on_dir(
      vim.fs.root(bufnr, { 'biome.json', 'biome.jsonc' })
        or npm.find_package_json(bufnr, '@biomejs/biome')
    )
  end,
  workspace_required = true,
}
