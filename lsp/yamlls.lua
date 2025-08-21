---@type vim.lsp.Config
return {
  cmd = { 'yaml-language-server', '--stdio' },
  filetypes = { 'yaml' },
  root_markers = { '.yamllint', '.yamllint.yaml', '.yamllint.yml' },
  settings = {
    yaml = {
      format = {
        enable = true,
      },
    },
  },
  on_init = function(client)
    -- https://github.com/redhat-developer/yaml-language-server/issues/486
    client.server_capabilities.documentFormattingProvider = true
  end,
}
