do
  require('codecompanion').setup({})
end

do
  vim.keymap.set({ 'n', 'x' }, '<leader>oa', function()
    require('opencode').ask('@this: ', { submit = true })
  end, { desc = 'Ask OpenCode' })
  vim.keymap.set({ 'n', 'x' }, '<leader>ox', function()
    require('opencode').select()
  end, { desc = 'Execute OpenCode action' })
  vim.keymap.set({ 'n', 'x' }, 'ga', function()
    require('opencode').prompt('@this')
  end, { desc = 'Add to OpenCode' })
  vim.keymap.set({ 'n', 't' }, '<C-.>', function()
    require('opencode').toggle()
  end, { desc = 'Toggle OpenCode' })
  vim.keymap.set('n', '<S-C-u>', function()
    require('opencode').command('session.half.page.up')
  end, { desc = 'opencode half page up' })

  vim.keymap.set('n', '<S-C-d>', function()
    require('opencode').command('session.half.page.down')
  end, { desc = 'opencode half page down' })
end
