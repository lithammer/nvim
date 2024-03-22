local function set_user_hl()
  local get_hl = vim.api.nvim_get_hl
  local set_hl = vim.api.nvim_set_hl

  local bg = get_hl(0, { name = 'StatusLine', link = false }).bg
  -- local bg_nc = get_hl(0, { name = 'StatusLineNC' }).bg

  local fg_error = get_hl(0, { name = 'DiagnosticError', link = false }).fg
  local fg_warn = get_hl(0, { name = 'DiagnosticWarn', link = false }).fg
  local fg_info = get_hl(0, { name = 'DiagnosticInfo', link = false }).fg
  local fg_hint = get_hl(0, { name = 'DiagnosticHint', link = false }).fg

  set_hl(0, 'User1', { fg = fg_error, bg = bg })
  set_hl(0, 'User2', { fg = fg_warn, bg = bg })
  set_hl(0, 'User3', { fg = fg_info, bg = bg })
  set_hl(0, 'User4', { fg = fg_hint, bg = bg })
end

vim.api.nvim_create_autocmd('ColorScheme', {
  pattern = '*',
  callback = set_user_hl,
})

set_user_hl()

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
    -- [vim.diagnostic.severity.HINT] = ' ',
    [vim.diagnostic.severity.HINT] = ' ',
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

vim.opt.statusline = '%!v:lua.Statusline()'
