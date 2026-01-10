do
  require('oil').setup()
  vim.keymap.set('n', '-', '<CMD>Oil<CR>', { desc = 'Open parent directory' })
end

do
  require('fidget').setup({})
end

do
  require('trouble').setup({
    keys = {
      j = 'next',
      k = 'prev',
    },
  })
end

do
  local smear_cursor = require('smear_cursor')
  smear_cursor.setup({
    smear_to_cmd = false,
  })
  smear_cursor.enabled = not vim.env.TERM:match('kitty')
end

vim.g.gutentags_add_default_project_roots = 0
vim.g.gutentags_project_root = { '.git' }
vim.g.gutentags_file_list_command = {
  markers = {
    ['.git'] = 'git ls-files',
  },
}

-- Fugitive.
vim.keymap.set('n', '<leader>g', ':G<cr>', { desc = 'Open Fugitive in a split', silent = true })
vim.keymap.set('n', '<leader>G', ':tab G<cr>', { desc = 'Open Fugitive in a tab', silent = true })
