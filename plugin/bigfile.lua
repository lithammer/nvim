local MAX_SIZE = 1.5 * 1024 * 1024 -- 1.5MB
local MAX_AVERAGE_LINE_LENGTH = 1000 -- Average line length (useful for minified files).

vim.filetype.add({
  pattern = {
    ['.*'] = {
      function(path, bufnr)
        if not path or not bufnr or vim.bo[bufnr].filetype == 'bigfile' then
          return
        end
        if path ~= vim.api.nvim_buf_get_name(bufnr) then
          return
        end
        local size = vim.fn.getfsize(path)
        if size <= 0 then
          return
        end
        if size > MAX_SIZE then
          return 'bigfile'
        end
        local lines = vim.api.nvim_buf_line_count(bufnr)
        return (size - lines) / lines > MAX_AVERAGE_LINE_LENGTH and 'bigfile' or nil
      end,
    },
  },
})

vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('snacks_bigfile', { clear = true }),
  pattern = 'bigfile',
  callback = function(event)
    local bufnr = event.buf
    local path = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(bufnr), ':p:~:.')
    vim.notify(
      ('Big file detected `%s`. Some Neovim features have been **disabled**.'):format(path),
      vim.log.levels.WARN
    )

    vim.api.nvim_buf_call(bufnr, function()
      local ft = vim.filetype.match({ buf = bufnr }) or ''
      if vim.fn.exists(':NoMatchParen') ~= 0 then
        vim.cmd([[NoMatchParen]])
      end

      local winid = vim.api.nvim_get_current_win()
      vim.wo[winid][bufnr].conceallevel = 0
      vim.wo[winid][bufnr].foldmethod = 'manual'
      vim.wo[winid][bufnr].statuscolumn = ''

      vim.b.minianimate_disable = true
      vim.schedule(function()
        if vim.api.nvim_buf_is_valid(bufnr) then
          vim.bo[bufnr].syntax = ft
        end
      end)
    end)
  end,
})
