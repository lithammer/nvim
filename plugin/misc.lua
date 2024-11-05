local keymap = vim.keymap

local add, later = MiniDeps.add, MiniDeps.later

add('romainl/vim-qf')
later(function()
  keymap.set('n', '<leader>q', '<plug>(qf_qf_toggle)', { desc = 'Toggle quickfix window' })
  keymap.set('n', ']q', '<plug>(qf_qf_next)', { desc = 'Go down the quickfix list' })
  keymap.set('n', '[q', '<plug>(qf_qf_previous)', { desc = 'Go up the quickfix list' })
  keymap.set('n', ']l', '<plug>(qf_loc_next)', { desc = 'Go down the current location list' })
  keymap.set('n', '[l', '<plug>(qf_loc_previous)', { desc = 'Go up the current location list' })
end)

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
