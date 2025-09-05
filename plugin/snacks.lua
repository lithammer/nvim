---@module 'snacks'

require('snacks').setup({
  bigfile = { enabled = true },
  dim = { enabled = true },
  picker = { enabled = true, ui_select = false },
  toggle = { enabled = true },
  zen = { enabled = true },
})

vim.keymap.set('n', '<leader>gb', function()
  Snacks.git.blame_line()
end, { desc = 'Git Blame Line' })

vim.keymap.set('n', '<leader>z', function()
  Snacks.zen.zen()
end, { desc = 'Toggle zen mode' })

vim.keymap.set('n', '<leader>Z', function()
  Snacks.zen.zoom()
end, { desc = 'Toggle zoom' })

vim.keymap.set('n', '<c-p>', function()
  Snacks.picker.files({ layout = 'select' })
end, { desc = 'Find files' })

vim.keymap.set('n', '<leader>s', function()
  Snacks.picker.lsp_symbols({ layout = { preset = 'vscode', preview = 'main' } })
end, { desc = 'Search symbols' })

vim.keymap.set('n', '<leader>S', function()
  Snacks.picker.lsp_workspace_symbols()
end, { desc = 'Search workspace symbols' })

vim.keymap.set('n', '<leader>/', function()
  Snacks.picker.grep()
end, { desc = 'Grep' })
