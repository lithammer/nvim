local now, later = MiniDeps.now, MiniDeps.later

later(function()
  require('mini.ai').setup({
    mappings = {
      goto_left = '',
      goto_right = '',
    },
  })
end)

later(function()
  local miniclue = require('mini.clue')
  miniclue.setup({
    triggers = {
      -- Leader triggers
      { mode = 'n', keys = '<Leader>' },
      { mode = 'x', keys = '<Leader>' },

      -- Built-in completion
      { mode = 'i', keys = '<C-x>' },

      -- `g` key
      { mode = 'n', keys = 'g' },
      { mode = 'x', keys = 'g' },

      -- Marks
      { mode = 'n', keys = "'" },
      { mode = 'n', keys = '`' },
      { mode = 'x', keys = "'" },
      { mode = 'x', keys = '`' },

      -- Registers
      { mode = 'n', keys = '"' },
      { mode = 'x', keys = '"' },
      { mode = 'i', keys = '<C-r>' },
      { mode = 'c', keys = '<C-r>' },

      -- Window commands
      { mode = 'n', keys = '<C-w>' },

      -- `z` key
      { mode = 'n', keys = 'z' },
      { mode = 'x', keys = 'z' },
    },

    clues = {
      -- Enhance this by adding descriptions for <Leader> mapping groups
      miniclue.gen_clues.builtin_completion(),
      miniclue.gen_clues.g(),
      miniclue.gen_clues.marks(),
      miniclue.gen_clues.registers({ show_contents = true }),
      miniclue.gen_clues.windows(),
      miniclue.gen_clues.z(),
    },
  })
end)

if not vim.lsp.completion then
  now(function()
    require('mini.completion').setup({
      mappings = {
        force_twostep = '',
        force_fallback = '',
      },
      window = {
        info = {
          height = 25,
          width = 80,
          border = 'single',
        },
        signature = {
          height = 25,
          width = 80,
          border = 'single',
        },
      },
    })
  end)
end

later(function()
  require('mini.diff').setup({
    mappings = {
      apply = '',
      reset = '',
      textobject = '',
      goto_first = '',
      goto_prev = '[c',
      goto_next = ']c',
      goto_last = '',
    },
  })
end)

later(function()
  require('mini.extra').setup()
end)

later(function()
  require('mini.pick').setup()
  vim.keymap.set('n', '<c-p>', MiniPick.builtin.files)
end)

later(function()
  require('mini.splitjoin').setup()
end)

later(function()
  require('mini.surround').setup()
end)
