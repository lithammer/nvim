local actions = require('telescope.actions')
local builtin = require('telescope.builtin')

require('telescope').setup({
  defaults = {
    mappings = {
      i = {
        ['<esc>'] = actions.close,
      },
    },
  },
})

local function pack(...)
  return { n = select('#', ...), ... }
end

local function bind(f, ...)
  local args1 = pack(...)
  return function(...)
    local args2 = pack(...)
    for i = 1, args2.n do
      args1[args1.n + i] = args2[i]
    end
    args1.n = args1.n + args2.n

    f(unpack(args1, 1, args1.n))
  end
end

local keymaps = {
  { 'n', '<leader>sm', builtin.marks, desc = 'Jump to Mark' },
  { 'n', '<leader>/', builtin.live_grep, desc = 'Grep (root dir)' },
  { 'n', '<leader>fb', '<cmd>Telescope buffers show_all_buffers=true<cr>', desc = 'Switch Buffer' },
  { 'n', '<leader>ff', builtin.find_files, desc = 'Find Files (root dir)' },
  {
    'n',
    '<leader>fg',
    '<cmd>Telescope git_files show_untracked=true<cr>',
    desc = 'Find Git Files (root dir)',
  },
  -- { 'n', '<leader>sw', '<cmd>Telescope grep_string word_match=-w<cr>', desc = 'Word (root dir)' },
  { 'n', '<leader>sw', bind(builtin.grep_string, { word_match = '-w' }), desc = 'Word (root dir)' },
  -- { 'n', '<leader>sW', Util.telescope('grep_string', { cwd = false, word_match = '-w' }), desc = 'Word (cwd)' },
  { 'v', '<leader>sw', builtin.grep_string, desc = 'Selection (root dir)' },
  -- { 'n', '<leader>sW', Util.telescope('grep_string', { cwd = false }), mode = 'v', desc = 'Selection (cwd)' },
  {
    'n',
    '<leader>ss',
    function()
      builtin.lsp_document_symbols({
        symbols = {
          'Class',
          'Function',
          'Method',
          'Constructor',
          'Interface',
          'Module',
          'Struct',
          'Trait',
          'Field',
          'Property',
          'Enum',
          'Constant',
        },
      })
    end,
    desc = 'Goto Symbol',
  },
  {
    'n',
    '<leader>sS',
    function()
      builtin.lsp_dynamic_workspace_symbols({
        symbols = {
          'Class',
          'Function',
          'Method',
          'Constructor',
          'Interface',
          'Module',
          'Struct',
          'Trait',
          'Field',
          'Property',
          'Enum',
          'Constant',
        },
      })
    end,
    desc = 'Goto Symbol (Workspace)',
  },
}

---@param t table
---@param predicate fun(k: any, v: any): boolean
---@return table, table
local function partition(t, predicate)
  local a, b = {}, {}

  for k, v in pairs(t) do
    if predicate(k, v) then
      a[k] = v
    else
      b[k] = v
    end
  end

  return a, b
end

for _, keymap in ipairs(keymaps) do
  local args, opts = partition(keymap, function(k, _)
    return type(k) == 'number'
  end)

  local mode, lhs, rhs = unpack(args)
  vim.keymap.set(mode, lhs, rhs, opts)
end
