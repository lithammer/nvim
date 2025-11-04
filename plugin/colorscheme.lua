---@param name string
---@param val vim.api.keyset.highlight
local function hi(name, val)
  val.force = true
  val.cterm = val.cterm or {}
  vim.api.nvim_set_hl(0, name, val)
end

---@param name string
---@param to string
local function link(name, to)
  hi(name, { link = to })
end

---@param name string
local function clear(name)
  vim.api.nvim_set_hl(0, name, {})
end

local group = vim.api.nvim_create_augroup('on_colorscheme_change', {})

vim.api.nvim_create_autocmd('ColorScheme', {
  group = group,
  pattern = 'lunaperche',
  callback = function()
    vim.cmd [[hi VertSplit guibg=NONE ctermbg=NONE]]

    hi('DiagnosticStatusLineError', { fg = '#000000', bg = '#ff0000' })
    hi('DiagnosticStatusLineWarn', { fg = '#000000', bg = '#ffa500' })
    hi('DiagnosticStatusLineInfo', { fg = '#000000', bg = '#add8e6' })
    hi('DiagnosticStatusLineHint', { fg = '#000000', bg = '#d3d3d3' })

    do
      -- local pmenu = vim.api.nvim_get_hl(0, { name = 'Pmenu', link = false })
      -- local pmenu_sel = vim.api.nvim_get_hl(0, { name = 'PmenuSel', link = false })
      local pmenu_match = vim.api.nvim_get_hl(0, { name = 'PmenuMatch', link = false })
      -- local pmenu_match_sel = vim.api.nvim_get_hl(0, { name = 'PmenuMatchSel', link = false })
      local pmenu_kind = vim.api.nvim_get_hl(0, { name = 'PmenuKind', link = false })
      -- local pmenu_kind_sel = vim.api.nvim_get_hl(0, { name = 'PmenuKindSel', link = false })
      local pmenu_extra = vim.api.nvim_get_hl(0, { name = 'PmenuExtra', link = false })
      -- local pmenu_extra_sel = vim.api.nvim_get_hl(0, { name = 'PmenuExtraSel', link = false })

      hi('BlinkCmpLabel', { default = true })
      hi('BlinkCmpLabelMatch', { fg = pmenu_match.fg })
      hi('BlinkCmpLabelDetail', { fg = pmenu_extra.fg })
      hi('BlinkCmpLabelDescription', { fg = pmenu_extra.fg })
      hi('BlinkCmpKind', { fg = pmenu_kind.fg })
    end

    link('SnacksPicker', 'Normal')

    -- Fix yaml property highlight. The default link is @property.yaml -> @property -> Identifier.
    -- But Identifier is cleared in lunaperche. Map to Statement instead since that's what
    -- the vanilla syntax engine does.
    link('@property.yaml', 'Statement')
  end,
})

vim.api.nvim_create_autocmd('ColorScheme', {
  group = group,
  pattern = 'habamax',
  callback = function()
    link('FloatBorder', 'PmenuBorder')

    -- Treesitter.
    clear('@function')
    link('@keyword.function', 'Identifier') -- Blue instead of purple.
    clear('@property')
    clear('@variable')
    clear('@variable.member')
    link('@punctuation.delimiter', 'NonText')

    -- Treesitter (JSON).
    link('@conceal.json', 'NonText')
    link('@property.json', 'Statement')

    -- Treesitter (Lua).
    link('@punctuation.bracket.lua', 'NonText')

    -- Treesitter (YAML).
    link('@property.yaml', 'Statement')
    clear('@string.yaml')

    -- LSP.
    clear('@lsp.type.function')
    clear('@lsp.type.method')
    clear('@lsp.type.parameter')
    clear('@lsp.type.property')
    clear('@lsp.type.variable')
  end,
})

vim.cmd [[colorscheme habamax]]
