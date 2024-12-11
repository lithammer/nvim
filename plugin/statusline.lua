-- https://www.w3.org/TR/AERT/#color-contrast
local function color_brightness(int_color)
  local hex_color = string.format('%06x', int_color)
  local r = tonumber(hex_color:sub(1, 2), 16)
  local g = tonumber(hex_color:sub(3, 4), 16)
  local b = tonumber(hex_color:sub(5, 6), 16)
  return (r * 299 + g * 587 + b * 114) / 1000
end

local function update_diagnostic_statusline_hl()
  local statusline = vim.api.nvim_get_hl(0, { name = 'StatusLine', link = false })

  for i, suffix in ipairs({ 'Error', 'Warn', 'Info', 'Hint' }) do
    local hl = vim.api.nvim_get_hl(0, {
      name = 'DiagnosticStatusLine' .. suffix,
      link = false,
      create = false,
    })
    if not vim.tbl_isempty(hl) then
      vim.api.nvim_set_hl(0, 'User' .. i, { link = 'DiagnosticStatusLine' .. suffix })
    else
      -- This assumes the relevant color (red, yellow etc) is the foreground color.
      local bg = vim.api.nvim_get_hl(0, { name = 'Diagnostic' .. suffix, link = false }).fg
      -- Pick the darker color as foreground.
      local fg = color_brightness(statusline.fg) < color_brightness(statusline.bg) and statusline.fg
        or statusline.bg
      vim.api.nvim_set_hl(0, 'User' .. i, vim.tbl_extend('force', statusline, { bg = bg, fg = fg }))
    end
  end
end

do
  local group = vim.api.nvim_create_augroup('statusline_redraw', { clear = true })

  vim.api.nvim_create_autocmd('DiagnosticChanged', {
    group = group,
    callback = update_diagnostic_statusline_hl,
    once = true,
  })

  vim.api.nvim_create_autocmd('ColorScheme', {
    group = group,
    pattern = '*',
    callback = update_diagnostic_statusline_hl,
  })

  vim.api.nvim_create_autocmd('DiagnosticChanged', {
    group = group,
    command = 'redrawstatus!',
    -- XXX: nvim__redraw() is corrupting the blink.cmp menu.
    -- callback = function()
    --   vim.api.nvim__redraw({
    --     statusline = true,
    --     flush = true,
    --   })
    -- end,
  })

  vim.api.nvim_create_autocmd('User', {
    group = group,
    pattern = { 'GutentagsUpdating', 'GutentagsUpdated' },
    command = 'redrawstatus!',
  })
end

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
    "%{gutentags#statusline('[', ']')}",
    '%=',
    '%-14.(%l,%c%V%)',
    '%P',
  })
end

vim.o.statusline = '%!v:lua.Statusline()'
