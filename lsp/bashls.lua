-- https://github.com/bash-lsp/bash-language-server

---@type vim.lsp.Config
return {
  cmd = { 'bash-language-server', 'start' },
  filetypes = { 'sh' },
}
