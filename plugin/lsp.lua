local Methods = vim.lsp.protocol.Methods
local CodeActionKind = vim.lsp.protocol.CodeActionKind

vim.diagnostic.config({
  severity_sort = true,
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = ' ',
      [vim.diagnostic.severity.WARN] = ' ',
      [vim.diagnostic.severity.INFO] = ' ',
      [vim.diagnostic.severity.HINT] = ' ',
    },
  },
  virtual_text = false,
  jump = {
    float = true,
  },
})

local function trouble(mode)
  local width = vim.o.columns
  local is_small_window = width < 100
  require('trouble').first({
    mode = mode,
    auto_refresh = false,
    focus = true,
    preview = {
      type = 'split',
      relative = 'win',
      position = is_small_window and 'top' or 'right',
      size = is_small_window and 100 or 0.3,
    },
  })
end

---@param kind lsp.CodeActionKind
local function code_action_kind(kind)
  ---@diagnostic disable-next-line: missing-fields
  vim.lsp.buf.code_action({ context = { only = { kind } } })
end

---@param bufnr number The buffer number.
---@param client vim.lsp.Client
local function setup_mappings(bufnr, client)
  ---@param mode string|string[]
  ---@param lhs string
  ---@param rhs string|function
  ---@param opts? vim.keymap.set.Opts
  local function map(mode, lhs, rhs, opts)
    vim.keymap.set(mode, lhs, rhs, vim.tbl_extend('keep', { buffer = bufnr }, opts or {}))
  end

  map('n', 'gD', vim.lsp.buf.declaration, { desc = 'Jump to declaration' })

  if client.supports_method(Methods.textDocument_typeDefinition) then
    map('n', 'gy', vim.lsp.buf.type_definition, { desc = 'Jump to type definition' })
  end

  if client.supports_method(Methods.textDocument_implementation) then
    map('n', 'gI', function()
      trouble('lsp_implementations')
    end, { desc = 'List implementations' })
  end

  if client.supports_method(Methods.textDocument_documentSymbol) then
    map('n', 'gO', vim.lsp.buf.document_symbol, { desc = 'List all symbols in the buffer' })
  end

  if client.supports_method(Methods.workspace_symbol) then
    map(
      'n',
      '<leader>s',
      vim.lsp.buf.workspace_symbol,
      { desc = 'List all symbols in the workspace' }
    )
  end

  map('n', 'grr', function()
    trouble('lsp_references')
  end, { desc = 'List references' })

  map('n', '<leader>rs', function()
    code_action_kind(CodeActionKind.Source)
  end, { desc = 'List source code actions' })

  map('n', '<leader>rr', function()
    code_action_kind(CodeActionKind.Refactor)
  end, { desc = 'List refactor code actions' })
end

local function on_attach(args)
  local lsp = require('lsp')

  local bufnr = args.buf
  local client = vim.lsp.get_client_by_id(args.data.client_id)
  if not client then
    return
  end

  setup_mappings(bufnr, client)

  if client.supports_method(Methods.textDocument_documentHighlight) then
    lsp.setup_document_highlight(bufnr)
  end

  vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })

  if vim.lsp.completion then
    vim.opt.completeopt:append({ 'noselect', 'popup' })
    vim.lsp.completion.enable(true, client.id, bufnr, { autotrigger = true })
  end
end

vim.api.nvim_create_autocmd('LspAttach', { callback = on_attach })
