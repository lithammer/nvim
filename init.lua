vim.loader.enable()

local g, opt = vim.g, vim.opt

-- Disable providers.
g.loaded_node_provider = 0
g.loaded_perl_provider = 0
g.loaded_python3_provider = 0
g.loaded_ruby_provider = 0

opt.breakindent = true
opt.breakindentopt = { 'shift:2', 'sbr' }
opt.completeopt = { 'menu', 'fuzzy' }
opt.conceallevel = 2
opt.cursorline = true
opt.expandtab = true
opt.fillchars:append({ diff = '╱' })
-- opt.formatoptions:append({ 'r', 'o', 'n', '1' })
opt.grepformat:prepend({ '%f:%l:%c:%m' })
opt.grepprg = 'rg --vimgrep'
opt.inccommand = 'split'
opt.list = true
opt.listchars:append({ tab = '│ ', trail = '·' })
opt.number = true
opt.pumblend = 10
opt.scrolloff = 4
opt.shiftwidth = 4
opt.showbreak = '↪'
opt.sidescrolloff = 8
opt.signcolumn = 'number'
opt.smartcase = true
opt.smartindent = true
opt.tabstop = 4
opt.tabstop = 4
opt.termguicolors = true
opt.undofile = true
opt.wrap = false

opt.foldenable = false
opt.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
-- opt.foldlevel = 1
opt.foldlevelstart = 99
opt.foldmethod = 'expr'
opt.foldtext = 'v:lua.vim.treesitter.foldtext()'

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

g.netrw_altfile = 1
g.netrw_liststyle = 3

vim.api.nvim_create_user_command('W', 'w', { nargs = 0 })

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'netrw',
  callback = function()
    local ok, ignore = vim.fn['netrw_gitignore#Hide']()
    if ok then
      g.netrw_list_hide = ignore
    end
  end,
})

-- :h last-position-jump
vim.api.nvim_create_autocmd('BufRead', {
  group = vim.api.nvim_create_augroup('last_position_jump', {}),
  callback = function(opts)
    local buf = opts.buf
    vim.api.nvim_create_autocmd('BufWinEnter', {
      once = true,
      buffer = buf,
      callback = function()
        local ft = vim.bo[buf].filetype
        local last_known_line = vim.api.nvim_buf_get_mark(buf, '"')[1]
        if
          not (ft:match('commit') or ft:match('rebase'))
          and last_known_line > 1
          and last_known_line <= vim.api.nvim_buf_line_count(buf)
        then
          vim.api.nvim_feedkeys([[g`"]], 'nx', false)
        end
      end,
    })
  end,
})

-- :h vim.highlight
vim.api.nvim_create_autocmd('TextYankPost', {
  group = vim.api.nvim_create_augroup('yank_highlight', {}),
  callback = function()
    require('vim.highlight').on_yank()
  end,
  desc = 'Highlight yanked text',
})
