---@type vim.lsp.Config
return {
  cmd = { 'docker-language-server', 'start', '--stdio' },
  filetypes = { 'dockerfile', 'yaml.docker-compose' },
  root_markers = {
    'Dockerfile',
    'docker-compose.yaml',
    'docker-compose.yml',
  },
}
