local later = MiniDeps.later

later(function()
  require('lint').linters_by_ft = {
    bzl = { 'buildifier' },
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
