-- https://github.com/astral-sh/ruff

---@type vim.lsp.Config
return {
  cmd = { 'ruff', 'server' },
  filetypes = { 'python' },
  root_markers = { 'pyproject.toml', 'ruff.toml', '.ruff.toml' },
  on_attach = function(client)
    -- Disable hover in favour of Pyright.
    client.server_capabilities.hoverProvider = false
  end,
  init_options = {
    settings = {
      args = {},
    },
  },
}
