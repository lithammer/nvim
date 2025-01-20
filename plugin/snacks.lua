local later = MiniDeps.later

later(function()
  require('snacks').setup({
    dim = { enabled = true },
    picker = { enabled = true, ui_select = false },
    zen = { enabled = true },
  })

  vim.keymap.set('n', '<c-p>', function()
    ---@diagnostic disable-next-line: missing-fields
    Snacks.picker.files({ layout = 'select' })
  end, { desc = 'Find Files' })
end)
