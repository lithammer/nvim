vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0

vim.g.zenbones = { darkness = 'warm' }
vim.g.zenwritten = { darkness = 'warm' }

vim.opt.termguicolors = true

-- vim.g.bones_compat = 1
vim.cmd.packadd('lush.nvim')
-- vim.cmd.colorscheme('zenwritten')
require('kanagawa').setup({
  overrides = function(_colors)
    return {
      NormalFloat = { bg = 'none' },
      FloatBorder = { bg = 'none' },
      FloatTitle = { bg = 'none' },
    }
  end,
})
vim.cmd.colorscheme('kanagawa-dragon')

-- :h last-position-jump
vim.api.nvim_create_autocmd('BufRead', {
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
do
  local group = vim.api.nvim_create_augroup('yank_highlight', {})
  vim.api.nvim_create_autocmd('TextYankPost', {
    group = group,
    callback = function()
      require('vim.highlight').on_yank()
    end,
    desc = 'Highlight yanked text',
  })
end
