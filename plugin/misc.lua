local keymap = vim.keymap

local add, later = MiniDeps.add, MiniDeps.later

add('romainl/vim-qf')

add('folke/flash.nvim')
later(function()
  local flash = require('flash')
  keymap.set({ 'n', 'x', 'o' }, 's', flash.jump, { desc = 'Flash' })
  keymap.set({ 'n', 'x', 'o' }, 'S', flash.treesitter, { desc = 'Flash Treesitter' })
  keymap.set('o', 'r', flash.remote, { desc = 'Remote Flash' })
  keymap.set({ 'o', 'x' }, 'R', flash.treesitter_search, { desc = 'Treesitter Search' })
  keymap.set({ 'c' }, '<c-s>', flash.toggle, { desc = 'Toggle Flash Search' })
end)

add('dgagn/diagflow.nvim')
later(function()
  require('diagflow').setup({
    padding_top = 3,
    toggle_event = { 'InsertEnter', 'InsertLeave' },
  })
end)

later(function()
  require('trouble').setup({
    keys = {
      j = 'next',
      k = 'prev',
    },
  })
end)

later(function()
  require('ts-comments').setup()
end)
