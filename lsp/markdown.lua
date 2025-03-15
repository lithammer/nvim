---@type vim.lsp.Config
return {
  cmd = { 'vscode-markdown-language-server', '--stdio' },
  filetypes = { 'markdown' },
  init_options = {
    provideFormatter = true,
  },
}
