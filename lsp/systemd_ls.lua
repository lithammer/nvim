-- https://github.com/JFryy/systemd-lsp

---@type vim.lsp.Config
return {
  cmd = { 'systemd-lsp' }, -- Update this path to your systemd-lsp binary
  filetypes = { 'systemd' },
  root_markers = { '.git' },
}
