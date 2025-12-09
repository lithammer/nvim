local modules = {
  'mini.icons', -- Loaded early since it's used by other plugins.
  'mini.comment',
  'mini.extra',
  'mini.splitjoin',
  'mini.surround',
}
for _, module in ipairs(modules) do
  require(module).setup()
end

require('mini.ai').setup({
  mappings = {
    goto_left = '',
    goto_right = '',
    -- These conflict with LSP incremental selection bindings.
    -- :help lsp-defaults
    around_next = '', -- an
    inside_next = '', -- in
  },
})

require('mini.bracketed').setup({
  buffer = { suffix = '' }, -- :help default-mappings
  comment = { suffix = '' },
  diagnostic = { suffix = '' }, -- :help default-mappings
  indent = { suffix = '' },
  location = { suffix = '' }, -- :help default-mappings
  quickfix = { suffix = '' }, -- :help default-mappings
  treesitter = { suffix = '' },
  undo = { suffix = '' },
})

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

do
  local disable = vim.schedule_wrap(function()
    -- Disable autopeek when command-line is opened from visual selection.
    local is_from_visual = vim.startswith(vim.fn.getcmdline(), "'<,'>")
    MiniCmdline.config.autopeek.enable = not is_from_visual
  end)
  local reenable = function()
    MiniCmdline.config.autopeek.enable = true
  end

  vim.api.nvim_create_autocmd('CmdlineEnter', { callback = disable })
  vim.api.nvim_create_autocmd('CmdlineLeave', { callback = reenable })
  require('mini.cmdline').setup()
end

require('mini.diff').setup({
  mappings = {
    apply = '',
    reset = '',
    textobject = '',
    goto_first = '[C',
    goto_prev = '[c',
    goto_next = ']c',
    goto_last = ']C',
  },
})

require('mini.notify').setup({
  lsp_progress = {
    enable = false,
  },
})

do
  local vim_ui_select = vim.ui.select
  require('mini.pick').setup()
  vim.ui.select = vim_ui_select
  vim.keymap.set('n', '<c-p>', MiniPick.builtin.files, { desc = 'Find files' })
  vim.keymap.set('n', '<leader>/', MiniPick.builtin.grep_live, { desc = 'Grep' })
  vim.keymap.set('n', '<leader>s', function()
    MiniExtra.pickers.lsp({ scope = 'document_symbol' })
  end, { desc = 'Search document symbols' })
  vim.keymap.set('n', '<leader>S', function()
    MiniExtra.pickers.lsp({ scope = 'workspace_symbol' })
  end, { desc = 'Search workspace symbols' })
end
