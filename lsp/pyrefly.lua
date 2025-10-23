-- https://github.com/facebook/pyrefly

---@type vim.lsp.Config
return {
  cmd = { 'pyrefly', 'lsp' },
  filetypes = { 'python' },
  root_markers = {
    'pyrefly.toml',
    'pyproject.toml',
    'setup.py',
    'setup.cfg',
    'requirements.txt',
  },
}
