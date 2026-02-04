vim.loader.enable()

-- Disable providers.
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0

-- Force OSC52 clipboard over SSH.
if vim.env.SSH_TTY then
  vim.g.clipboard = 'osc52'
end

vim.o.breakindent = true
vim.o.breakindentopt = 'shift:2,sbr'
vim.o.busy = 1
vim.o.conceallevel = 2
vim.o.cursorline = true
vim.opt.diffopt:append({ 'inline:char', 'algorithm:histogram' })
vim.o.expandtab = true
vim.o.exrc = true
vim.opt.fillchars:append({ diff = '╱', fold = ' ' })
-- vim.opt.formatoptions:append({ 'r', 'o', 'n', '1' })
vim.opt.grepformat:prepend({ '%f:%l:%c:%m' })
vim.o.grepprg = 'rg --vimgrep'
vim.o.guifont = 'PragmataPro Mono Liga:h14'
vim.o.ignorecase = true
vim.o.inccommand = 'split'
vim.o.list = true
vim.opt.listchars:append({ tab = '│ ', trail = '·' })
vim.o.number = true
vim.o.pumblend = 10
vim.o.scrolloff = 4
vim.o.shiftwidth = 4
vim.o.showbreak = '↪'
vim.o.sidescrolloff = 8
vim.o.signcolumn = 'number'
vim.o.smartcase = true
vim.o.smartindent = true
vim.o.tabstop = 4
vim.o.tabstop = 4
vim.o.termguicolors = true
vim.o.undofile = true
vim.o.updatetime = 300
vim.o.wildignorecase = true
vim.o.winborder = 'single'
vim.o.wrap = false

vim.o.foldenable = false
-- vim.o.foldlevel = 1
vim.o.foldlevelstart = 99

vim.cmd [[
  packadd nvim.undotree
]]

vim.pack.add({
  'https://github.com/barrettruth/diffs.nvim',
  'https://github.com/nvim-mini/mini.nvim',
  'https://github.com/folke/trouble.nvim',
  'https://github.com/j-hui/fidget.nvim',
  'https://github.com/ludovicchabant/vim-gutentags',
  'https://github.com/mfussenegger/nvim-ansible',
  'https://github.com/mfussenegger/nvim-lint',
  'https://github.com/nvim-treesitter/nvim-treesitter',
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

vim.cmd [[
  colorscheme habamax_plus
]]

vim.api.nvim_create_user_command('PackUpdate', function()
  vim.pack.update()
end, {})

vim.g.netrw_altfile = 1
vim.g.netrw_preview = 1
