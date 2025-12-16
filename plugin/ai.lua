vim.g.copilot_filetypes = {
  gitcommit = true,
}

require('codecompanion').setup({})

do
  vim.keymap.set({ 'n', 'x' }, '<leader>oa', function()
    require('opencode').ask('@this: ', { submit = true })
  end, { desc = 'Ask OpenCode' })
  vim.keymap.set({ 'n', 'x' }, '<leader>ox', function()
    require('opencode').select()
  end, { desc = 'Execute OpenCode action' })
  vim.keymap.set({ 'n', 't' }, '<C-.>', function()
    require('opencode').toggle()
  end, { desc = 'Toggle OpenCode' })

  vim.keymap.set({ 'n', 'x' }, 'go', function()
    return require('opencode').operator('@this ')
  end, { expr = true, desc = 'Add range to OpenCode' })
  vim.keymap.set('n', 'goo', function()
    return require('opencode').operator('@this ') .. '_'
  end, { expr = true, desc = 'Add line to OpenCode' })

  vim.keymap.set('n', '<S-C-u>', function()
    require('opencode').command('session.half.page.up')
  end, { desc = 'OpenCode half page up' })
  vim.keymap.set('n', '<S-C-d>', function()
    require('opencode').command('session.half.page.down')
  end, { desc = 'OpenCode half page down' })
end

do
  require('sidekick').setup()
  vim.keymap.set('n', '<tab>', function()
    if not require('sidekick').nes_jump_or_apply() then
      return '<Tab>'
    end
  end, {
    expr = true,
    desc = 'Goto/Apply Next Edit Suggestion',
  })
end
