require('codecompanion').setup({})

vim.keymap.set({ 'n', 'x' }, '<leader>oa', function()
  require('opencode').ask('@this: ', { submit = true })
end, { desc = 'OC: Ask about this' })

vim.keymap.set({ 'n', 'x' }, '<leader>o+', function()
  require('opencode').prompt('@this')
end, { desc = 'OC: Add this' })

vim.keymap.set({ 'n', 'x' }, '<leader>os', function()
  require('opencode').select()
end, { desc = 'OC: Select prompt' })
