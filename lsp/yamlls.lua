---@type vim.lsp.Config
return {
  cmd = { 'yaml-language-server', '--stdio' },
  filetypes = { 'yaml' },
  root_markers = { '.yamllint', '.yamllint.yaml', '.yamllint.yml' },
  settings = {},
}
