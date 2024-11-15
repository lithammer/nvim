local function update_diagnostic_statusline_hl()
  local statusline = vim.api.nvim_get_hl(0, { name = 'StatusLine', link = false })

  for i, suffix in ipairs({ 'Error', 'Warn', 'Info', 'Hint' }) do
    local hl = vim.api.nvim_get_hl(0, { name = 'DiagnosticStatusLine' .. suffix, link = false })
    if not vim.tbl_isempty(hl) then
      vim.api.nvim_set_hl(0, 'User' .. i, { link = 'DiagnosticStatusLine' .. suffix })
    else
      local fg = vim.api.nvim_get_hl(0, { name = 'Diagnostic' .. suffix, link = false }).fg
      vim.api.nvim_set_hl(0, 'User' .. i, vim.tbl_extend('force', statusline, { bg = fg }))
    end
  end
end

vim.api.nvim_create_autocmd('DiagnosticChanged', {
  callback = update_diagnostic_statusline_hl,
  once = true,
})

vim.api.nvim_create_autocmd('ColorScheme', {
  pattern = '*',
  callback = update_diagnostic_statusline_hl,
})

vim.api.nvim_create_autocmd('DiagnosticChanged', {
  command = 'redrawstatus!',
  -- XXX: nvim__redraw() causes the blink.cmp menu to linger.
  -- callback = function()
  --   vim.api.nvim__redraw({
  --     statusline = true,
  --     flush = true,
  --   })
  -- end,
})

---@param focused boolean
---@return string
local function diagnostic(focused)
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

  local bufnr = vim.api.nvim_win_get_buf(vim.g.statusline_winid)

  local counts = {}
  for _, level in ipairs(levels) do
    counts[level] = vim.tbl_count(vim.diagnostic.get(bufnr, { severity = level }))
  end

  local result = {}
  for severity, count in pairs(counts) do
    if count > 0 then
      local item = string.format('[%s %d]', icons[severity], count)
      if focused then
        item = string.format('%%%d*%s%%*', severity, item)
      end
      table.insert(result, item)
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
    diagnostic(focused),
    '%=',
    '%-14.(%l,%c%V%)',
    '%P',
  })
end

vim.o.statusline = '%!v:lua.Statusline()'
