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

    -- Treesitter (Go).
    link('@keyword.function.go', 'Keyword')
    link('@keyword.type.go', 'Keyword')

    -- Treesitter (JSON).
    link('@conceal.json', 'NonText')
    link('@property.json', 'Statement')

    -- Treesitter (Lua).
    clear('@punctuation.bracket.lua')

    -- Treesitter (Protobuf).
    link('@keyword.type.proto', 'Keyword')

    -- Treesitter (Python).
    link('@keyword.type.python', 'Keyword')
    link('@keyword.function.python', 'Keyword')
    clear('@lsp.type.namespace.python')
    clear('@module.python')

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
