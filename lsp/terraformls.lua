-- https://github.com/hashicorp/terraform-ls

---@type vim.lsp.Config
return {
  cmd = { 'terraform-ls', 'serve' },
  filetypes = { 'terraform' },
  settings = {},
}
