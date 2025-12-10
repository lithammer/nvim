vim.loader.enable()

local g, o, opt = vim.g, vim.o, vim.opt

-- Disable providers.
g.loaded_node_provider = 0
g.loaded_perl_provider = 0
g.loaded_python3_provider = 0
g.loaded_ruby_provider = 0

o.breakindent = true
o.breakindentopt = 'shift:2,sbr'
o.busy = 1
o.conceallevel = 2
o.cursorline = true
opt.diffopt:append({ 'inline:char', 'algorithm:histogram' })
o.expandtab = true
o.exrc = true
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

vim.cmd [[
  packadd nvim.undotree
]]

vim.pack.add({
  'https://github.com/nvim-mini/mini.nvim',
  'https://github.com/folke/lazydev.nvim',
  'https://github.com/folke/trouble.nvim',
  'https://github.com/j-hui/fidget.nvim',
  'https://github.com/ludovicchabant/vim-gutentags',
  'https://github.com/mfussenegger/nvim-ansible',
  'https://github.com/mfussenegger/nvim-lint',
  { src = 'https://github.com/nvim-treesitter/nvim-treesitter', version = 'main' },
  'https://github.com/nvim-treesitter/nvim-treesitter-context',
  { src = 'https://github.com/nvim-treesitter/nvim-treesitter-textobjects', version = 'main' },
  'https://github.com/romainl/vim-qf',
  { src = 'https://github.com/saghen/blink.cmp', version = vim.version.range('1') },
  'https://github.com/sphamba/smear-cursor.nvim',
  'https://github.com/stevearc/conform.nvim',
  'https://github.com/stevearc/oil.nvim',
  'https://github.com/tpope/vim-fugitive',
  'https://github.com/tpope/vim-sleuth',
})

vim.pack.add({
  'https://github.com/folke/sidekick.nvim',
  'https://github.com/github/copilot.vim',
  'https://github.com/nickvandyke/opencode.nvim',
  'https://github.com/nvim-lua/plenary.nvim', -- Dependency of codecompanion.
  'https://github.com/olimorris/codecompanion.nvim',
})

-- Colorschemes.
vim.pack.add({
  'https://github.com/rktjmp/lush.nvim', -- Used by zenbones.

  { src = 'https://github.com/catppuccin/nvim', name = 'catppuccin' },
  'https://github.com/rebelot/kanagawa.nvim',
  'https://github.com/sainnhe/gruvbox-material',
  'https://github.com/zenbones-theme/zenbones.nvim',
})

vim.api.nvim_create_user_command('PackUpdate', function()
  vim.pack.update()
end, {})

do
  require('oil').setup()
  vim.keymap.set('n', '-', '<CMD>Oil<CR>', { desc = 'Open parent directory' })
end

do
  require('fidget').setup({})
end

do
  require('trouble').setup({
    keys = {
      j = 'next',
      k = 'prev',
    },
  })
end

do
  local smear_cursor = require('smear_cursor')
  smear_cursor.setup({
    smear_to_cmd = false,
  })
  smear_cursor.enabled = not vim.env.TERM:match('kitty')
end

g.gutentags_add_default_project_roots = 0
g.gutentags_project_root = { '.git' }
g.gutentags_file_list_command = {
  markers = {
    ['.git'] = 'git ls-files',
  },
}

g.netrw_altfile = 1
g.netrw_preview = 1

-- Fugitive.
vim.keymap.set('n', '<leader>g', ':G<cr>', { desc = 'Open Fugitive in a split', silent = true })
vim.keymap.set('n', '<leader>G', ':tab G<cr>', { desc = 'Open Fugitive in a tab', silent = true })
