require('lint').linters_by_ft = {
  javascript = { 'biomejs' },
  python = { 'ruff' },
  typescript = { 'biomejs' },
}

vim.api.nvim_create_autocmd({ 'BufWritePost' }, {
  callback = function()
    require('lint').try_lint()
  end,
})
