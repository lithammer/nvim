require('lint').linters_by_ft = {
  bzl = { 'buildifier' },
  go = { 'golangcilint' },
  javascript = { 'biomejs' },
  typescript = { 'biomejs' },
}

vim.api.nvim_create_autocmd({ 'BufWritePost' }, {
  callback = function()
    require('lint').try_lint()
  end,
})
