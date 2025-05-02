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
  virtual_lines = {
    current_line = true,
  },
  jump = {
    float = false,
  },
})

vim.keymap.set('n', 'gK', function()
  local virtual_lines_enabled = vim.diagnostic.config().virtual_lines ~= nil

  if virtual_lines_enabled then
    vim.diagnostic.config({
      jump = {
        float = true,
      },
      virtual_lines = false,
      virtual_text = { current_line = true },
    })
  else
    vim.diagnostic.config({
      jump = {
        float = true,
      },
      virtual_lines = { current_line = true },
      virtual_text = false,
    })
  end
end, { desc = 'Toggle between diagnostic virtual_lines and virtual_text' })
