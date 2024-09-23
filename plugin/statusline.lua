vim.api.nvim_create_autocmd({ 'ColorScheme', 'VimEnter' }, {
  pattern = '*',
  callback = function()
    vim.api.nvim_set_hl(0, 'StatusLine', { bg = 'NvimDarkGrey3', fg = 'NvimLightGrey3' })

    local statusline = vim.api.nvim_get_hl(0, { name = 'StatusLine', link = false })

    for i, suffix in ipairs({ 'Error', 'Warn', 'Info', 'Hint' }) do
      local fg = vim.api.nvim_get_hl(0, { name = 'Diagnostic' .. suffix, link = false }).fg
      vim.api.nvim_set_hl(0, 'User' .. i, vim.tbl_extend('force', statusline, { fg = fg }))
    end
  end,
})

---@return string
local function diagnostic()
  local levels = {
    vim.diagnostic.severity.ERROR,
    vim.diagnostic.severity.WARN,
    vim.diagnostic.severity.INFO,
    vim.diagnostic.severity.HINT,
  }

  local icons = {
    [vim.diagnostic.severity.ERROR] = ' ',
    [vim.diagnostic.severity.WARN] = ' ',
    [vim.diagnostic.severity.INFO] = ' ',
    [vim.diagnostic.severity.HINT] = ' ',
    -- [vim.diagnostic.severity.HINT] = ' ',
  }

  local bufnr = vim.api.nvim_get_current_buf()

  local counts = {}
  for _, level in ipairs(levels) do
    counts[level] = vim.tbl_count(vim.diagnostic.get(bufnr, { severity = level }))
  end

  local result = {}
  for severity, count in pairs(counts) do
    if count > 0 then
      table.insert(result, string.format('%%%d*[%s %d]%%*', severity, icons[severity], count))
    end
  end

  return table.concat(result)
end

local function is_current_window()
  return vim.g.statusline_winid == vim.api.nvim_get_current_win()
end

---@return string
function Statusline()
  local focused = is_current_window()
  return table.concat({
    '%<',
    '%f',
    ' ',
    '%h',
    '%m',
    '%r',
    focused and diagnostic() or '',
    '%=',
    '%-14.(%l,%c%V%)',
    '%P',
  })
end

vim.o.statusline = '%!v:lua.Statusline()'
