local opt = vim.opt
local g = vim.g

opt.breakindent = true
opt.breakindentopt = { 'shift:2', 'sbr' }
-- opt.completeopt:append('noselect')
opt.completeopt:remove('preview')
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
opt.undofile = true
opt.wrap = false

if vim.fn.has('nvim-0.10') == 1 then
  opt.foldenable = false
  opt.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
  -- opt.foldlevel = 1
  opt.foldlevelstart = 99
  opt.foldmethod = 'expr'
  opt.foldtext = 'v:lua.vim.treesitter.foldtext()'
end

-- netrw
g.netrw_altfile = 1
g.netrw_liststyle = 3

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'netrw',
  callback = function()
    local ok, ignore = vim.fn['netrw_gitignore#Hide']()
    if ok then
      g.netrw_list_hide = ignore
    end
  end,
})
