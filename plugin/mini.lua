local now, later = MiniDeps.now, MiniDeps.later

for _, plugin in ipairs({
  {
    'mini.ai',
    {
      mappings = {
        goto_left = '',
        goto_right = '',
      },
    },
  },
  {
    'mini.completion',
    {
      mappings = { force_twostep = '', force_fallback = '' },
      window = {
        info = { border = 'single' },
        signature = { border = 'single' },
      },
    },
  },
  {
    'mini.diff',
    {
      mappings = {
        apply = '',
        reset = '',
        textobject = '',
        goto_first = '',
        goto_prev = '[c',
        goto_next = ']c',
        goto_last = '',
      },
    },
  },
  'mini.extra',
  -- 'mini.files',
  'mini.pick',
  'mini.splitjoin',
  'mini.surround',
}) do
  local name
  local config = {}

  if type(plugin) == 'string' then
    name = plugin
  elseif type(plugin) == 'table' then
    name, config = plugin[1], plugin[2]
  end

  now(function()
    require(name).setup(config)
  end)
end

later(function()
  vim.keymap.set('n', '<c-p>', MiniPick.builtin.files)

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
