vim.loader.enable()

local g, o, opt = vim.g, vim.o, vim.opt

-- Disable providers.
g.loaded_node_provider = 0
g.loaded_perl_provider = 0
g.loaded_python3_provider = 0
g.loaded_ruby_provider = 0

o.breakindent = true
o.breakindentopt = 'shift:2,sbr'
o.completeopt = 'menu,fuzzy,nosort'
-- o.completeopt = 'menuone,fuzzy,nosort,noinsert'
o.conceallevel = 2
o.cursorline = true
opt.diffopt:append({ 'inline:char', 'algorithm:histogram' })
o.expandtab = true
opt.fillchars:append({ diff = '╱', fold = ' ' })
-- opt.formatoptions:append({ 'r', 'o', 'n', '1' })
opt.grepformat:prepend({ '%f:%l:%c:%m' })
o.grepprg = 'rg --vimgrep'
o.guifont = 'PragmataPro Mono Liga:h14'
o.ignorecase = true
o.inccommand = 'split'
o.list = true
opt.listchars:append({ tab = '│ ', trail = '·' })
o.number = true
o.pumblend = 10
o.scrolloff = 4
o.shiftwidth = 4
o.showbreak = '↪'
o.sidescrolloff = 8
o.signcolumn = 'number'
o.smartcase = true
o.smartindent = true
o.tabstop = 4
o.tabstop = 4
o.termguicolors = true
o.undofile = true
o.updatetime = 300
o.wildignorecase = true
o.winborder = 'single'
o.wrap = false

o.foldenable = false
-- o.foldlevel = 1
o.foldlevelstart = 99
o.foldmethod = 'expr'

vim.pack.add({
  'https://github.com/echasnovski/mini.nvim',
  'https://github.com/folke/flash.nvim',
  'https://github.com/folke/lazydev.nvim',
  'https://github.com/folke/snacks.nvim',
  'https://github.com/folke/trouble.nvim',
  'https://github.com/folke/ts-comments.nvim',
  'https://github.com/github/copilot.vim',
  'https://github.com/j-hui/fidget.nvim',
  'https://github.com/ludovicchabant/vim-gutentags',
  'https://github.com/mfussenegger/nvim-ansible',
  'https://github.com/mfussenegger/nvim-lint',
  { src = 'https://github.com/nvim-treesitter/nvim-treesitter', version = 'main' },
  'https://github.com/nvim-treesitter/nvim-treesitter-context',
  { src = 'https://github.com/nvim-treesitter/nvim-treesitter-textobjects', version = 'main' },
  'https://github.com/romainl/vim-qf',
  'https://github.com/sphamba/smear-cursor.nvim',
  'https://github.com/stevearc/conform.nvim',
  'https://github.com/stevearc/oil.nvim',
  'https://github.com/tpope/vim-fugitive',
  'https://github.com/tpope/vim-sleuth',
})

vim.pack.add({
  'https://github.com/nvim-lua/plenary.nvim',
  'https://github.com/olimorris/codecompanion.nvim',
})

-- Colorschemes.
vim.pack.add({
  { src = 'https://github.com/catppuccin/nvim', name = 'catppuccin' },
  'https://github.com/rebelot/kanagawa.nvim',
  'https://github.com/sainnhe/gruvbox-material',
  'https://github.com/zenbones-theme/zenbones.nvim',
  'https://github.com/rktjmp/lush.nvim',
})

require('mini.deps').setup()
local later, now = MiniDeps.later, MiniDeps.now

now(function()
  require('mini.notify').setup({
    lsp_progress = {
      enable = false,
    },
  })
  vim.notify = MiniNotify.make_notify({
    INFO = { hl_group = 'MiniNotifyNormal' },
  })
end)

later(function()
  require('oil').setup()
  vim.keymap.set('n', '-', '<CMD>Oil<CR>', { desc = 'Open parent directory' })
end)

later(function()
  local flash = require('flash')
  vim.keymap.set({ 'n', 'x', 'o' }, 's', flash.jump, { desc = 'Flash' })
  vim.keymap.set({ 'n', 'x', 'o' }, 'S', flash.treesitter, { desc = 'Flash Treesitter' })
  vim.keymap.set('o', 'r', flash.remote, { desc = 'Remote Flash' })
  vim.keymap.set({ 'o', 'x' }, 'R', flash.treesitter_search, { desc = 'Treesitter Search' })
  vim.keymap.set({ 'c' }, '<c-s>', flash.toggle, { desc = 'Toggle Flash Search' })
end)

later(function()
  require('fidget').setup({})
end)

later(function()
  require('ts-comments').setup()
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
  local smear_cursor = require('smear_cursor')
  smear_cursor.setup({
    smear_to_cmd = false,
  })
  smear_cursor.enabled = not (vim.env.TERM:match('kitty') or vim.env.TERM:match('ghostty'))
end)

g.gutentags_add_default_project_roots = 0
g.gutentags_project_root = { '.git' }
g.gutentags_file_list_command = {
  markers = {
    ['.git'] = 'git ls-files',
  },
}

do
  g.netrw_altfile = 1
  -- g.netrw_list_hide = vim.fn['netrw_gitignore#Hide']()
  g.netrw_preview = 1
end

-- Fugitive.
vim.keymap.set('n', '<leader>gf', ':G<cr>', { desc = 'Open Fugitive in a split' })
vim.keymap.set('n', '<leader>gF', ':tab G<cr>', { desc = 'Open Fugitive in a tab' })
