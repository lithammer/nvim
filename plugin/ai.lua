vim.g.copilot_filetypes = {
  gitcommit = true,
}

do
  -- Schedule to work ensure v18 breaking changes warning is using mini.notify.
  -- Otherwise it blocks loading.
  -- https://github.com/olimorris/codecompanion.nvim/pull/2439
  vim.schedule(function()
    require('codecompanion').setup({})
  end)
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
