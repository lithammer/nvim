local add, later = MiniDeps.add, MiniDeps.later

add('mfussenegger/nvim-lint')

later(function()
  require('lint').linters_by_ft = {
    go = { 'golangcilint' },
    javascript = { 'biomejs' },
    typescript = { 'biomejs' },
  }
end)

vim.api.nvim_create_autocmd({ 'BufWritePost' }, {
  callback = function()
    require('lint').try_lint()
  end,
})
