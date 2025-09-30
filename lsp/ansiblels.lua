---@type vim.lsp.Config
return {
  cmd = { 'ansible-language-server', '--stdio' },
  filetypes = { 'ansible', 'yaml.ansible' },
  root_markers = { 'ansible.cfg', 'requirements.yml', '.ansible-lint' },
  settings = {},
}
