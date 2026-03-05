vim.g.copilot_filetypes = {
  gitcommit = true,
}

do
  require('agentic').setup({
    provider = vim.env.AGENTIC_PROVIDER or 'codex-acp',
  })

  vim.keymap.set({ 'n', 'v', 'i' }, '<C-\\>', function()
    require('agentic').toggle()
  end, { desc = 'Toggle Agentic Chat' })

  vim.keymap.set({ 'n', 'v' }, "<C-'>", function()
    require('agentic').add_selection_or_file_to_context()
  end, { desc = 'Add file or selection to Agentic to Context' })

  vim.keymap.set({ 'n', 'v', 'i' }, '<C-,>', function()
    require('agentic').new_session()
  end, { desc = 'New Agentic Session' })
end

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

  -- vim.keymap.set({ 'n', 't', 'i', 'x' }, '<C-.>', function()
  --   require('sidekick.cli').toggle()
  -- end, { desc = 'Sidekick Toggle' })

  vim.keymap.set('n', '<leader>aa', function()
    require('sidekick.cli').toggle()
  end, { desc = 'Sidekick Toggle CLI' })

  vim.keymap.set('n', '<leader>as', function()
    require('sidekick.cli').select()
  end, { desc = 'Select CLI' })

  vim.keymap.set('n', '<leader>ad', function()
    require('sidekick.cli').close()
  end, { desc = 'Detach a CLI Session' })

  vim.keymap.set({ 'x', 'n' }, '<leader>at', function()
    require('sidekick.cli').send({ msg = '{this}' })
  end, { desc = 'Send This' })

  vim.keymap.set('n', '<leader>af', function()
    require('sidekick.cli').send({ msg = '{file}' })
  end, { desc = 'Send File' })

  vim.keymap.set('x', '<leader>av', function()
    require('sidekick.cli').send({ msg = '{selection}' })
  end, { desc = 'Send Visual Selection' })

  vim.keymap.set({ 'n', 'x' }, '<leader>ap', function()
    require('sidekick.cli').prompt()
  end, { desc = 'Sidekick Select Prompt' })

  vim.keymap.set('n', '<leader>ac', function()
    require('sidekick.cli').toggle({ name = 'claude', focus = true })
  end, { desc = 'Sidekick Toggle Claude' })
end
