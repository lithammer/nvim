-- https://github.com/redhat-developer/yaml-language-server

---@type vim.lsp.Config
return {
  cmd = { 'yaml-language-server', '--stdio' },
  filetypes = { 'yaml' },
  root_markers = {
    '.yamllint',
    '.yamllint.yaml',
    '.yamllint.yml',
    '.git',
  },
  settings = {
    yaml = {
      format = {
        enable = true,
      },
    },
  },
  capabilities = {
    workspace = {
      didChangeConfiguration = {
        dynamicRegistration = true,
      },
    },
  },
  on_init = function(client)
    -- https://github.com/redhat-developer/yaml-language-server/issues/486
    client.server_capabilities.documentFormattingProvider = true

    ---@diagnostic disable-next-line: param-type-mismatch
    client:notify('yaml/supportSchemaSelection', vim.NIL)
  end,
  handlers = {
    ['yaml/schema/store/initialized'] = function(_, _, _)
      vim.notify('Schema store ready', vim.log.levels.INFO)
    end,
  },
  end,
}
