vim.loader.enable()

local g, o, opt = vim.g, vim.o, vim.opt

-- Disable providers.
g.loaded_node_provider = 0
g.loaded_perl_provider = 0
g.loaded_python3_provider = 0
g.loaded_ruby_provider = 0

o.breakindent = true
o.breakindentopt = 'shift:2,sbr'
o.completeopt = 'menu,fuzzy'
o.conceallevel = 2
o.cursorline = true
o.expandtab = true
opt.fillchars:append({ diff = '╱' })
-- opt.formatoptions:append({ 'r', 'o', 'n', '1' })
opt.grepformat:prepend({ '%f:%l:%c:%m' })
o.grepprg = 'rg --vimgrep'
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
o.wrap = false

o.foldenable = false
o.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
-- o.foldlevel = 1
o.foldlevelstart = 99
o.foldmethod = 'expr'
o.foldtext = 'v:lua.vim.treesitter.foldtext()'

do
  ---@diagnostic disable-next-line: param-type-mismatch
  local mini_path = vim.fs.joinpath(vim.fn.stdpath('data'), 'site/pack/deps/start/mini.nvim')
  if not vim.uv.fs_stat(mini_path) then
    vim.notify('Installing `mini.nvim`')
    vim
      .system({
        'git',
        'clone',
        '--filter=blob:none',
        'https://github.com/echasnovski/mini.nvim',
        mini_path,
      })
      :wait()
    vim.cmd [[packadd mini.nvim | helptags ALL]]
  end
end

require('mini.deps').setup()
local add, now = MiniDeps.add, MiniDeps.now
add('echasnovski/mini.nvim')

now(function()
  require('mini.notify').setup({ lsp_progress = { enable = false } })
  vim.notify = MiniNotify.make_notify()
end)

add('brenoprata10/nvim-highlight-colors')
add('folke/lazydev.nvim')
add('folke/trouble.nvim')
add('folke/twilight.nvim')
add('github/copilot.vim')
add('mfussenegger/nvim-ansible')
add({
  source = 'nvim-treesitter/nvim-treesitter',
  hooks = {
    post_checkout = function()
      vim.cmd('TSUpdate')
    end,
  },
})
add('stevearc/oil.nvim')
add('tpope/vim-fugitive')
add('tpope/vim-sleuth')
add('tpope/vim-vinegar')

-- Colorschemes.
add({ source = 'catppuccin/nvim', name = 'catppuccin' })
add('rebelot/kanagawa.nvim')
add('sainnhe/gruvbox-material')
add({ source = 'zenbones-theme/zenbones.nvim', depends = { 'rktjmp/lush.nvim' } })

do
  g.netrw_altfile = 1
  g.netrw_list_hide = vim.fn['netrw_gitignore#Hide']()
  g.netrw_liststyle = 3
  g.netrw_preview = 1
end
