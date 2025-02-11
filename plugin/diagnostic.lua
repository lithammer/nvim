vim.diagnostic.config({
  severity_sort = true,
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = ' ',
      [vim.diagnostic.severity.WARN] = ' ',
      [vim.diagnostic.severity.INFO] = ' ',
      [vim.diagnostic.severity.HINT] = ' ',
    },
  },
  virtual_text = { current_line = true },
  jump = {
    float = true,
  },
})

local virtual_text = vim.diagnostic.config().virtual_text

vim.keymap.set('n', 'gK', function()
  local virtual_lines = not vim.diagnostic.config().virtual_lines
  vim.diagnostic.config({ virtual_lines = virtual_lines })
  if virtual_lines then
    vim.diagnostic.config({ virtual_text = false })
  else
    vim.diagnostic.config({ virtual_text = virtual_text })
  end
end, { desc = 'Toggle diagnostic virtual_lines' })
