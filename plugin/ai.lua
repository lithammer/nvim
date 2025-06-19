local add, later = MiniDeps.add, MiniDeps.later

add({
  source = 'olimorris/codecompanion.nvim',
  depends = {
    'echasnovski/mini.nvim', -- mini.diff
    'nvim-lua/plenary.nvim',
    'saghen/blink.cmp',
  },
})

later(function()
  require('codecompanion').setup({})
end)
