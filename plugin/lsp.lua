local add, later = MiniDeps.add, MiniDeps.later

local Methods = vim.lsp.protocol.Methods
local CodeActionKind = vim.lsp.protocol.CodeActionKind

add('j-hui/fidget.nvim')
later(function()
  require('fidget').setup({})
end)

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

---@param mode string
local function trouble(mode)
  local width = vim.o.columns
  local is_small_window = width < 100
  ---@diagnostic disable-next-line: missing-fields, missing-parameter
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

  --- Override default 'K' mapping to add border.
  if client:supports_method(Methods.textDocument_hover) then
    map('n', 'K', function()
      vim.lsp.buf.hover({ border = 'rounded' })
    end, { desc = 'Show hover information' })
  end

  map('n', 'gD', vim.lsp.buf.declaration, { desc = 'Jump to declaration' })

  if client:supports_method(Methods.textDocument_typeDefinition) then
    map('n', 'gy', vim.lsp.buf.type_definition, { desc = 'Jump to type definition' })
  end

  if client:supports_method(Methods.textDocument_implementation) then
    map('n', 'gI', function()
      trouble('lsp_implementations')
    end, { desc = 'List implementations' })
  end

  if client:supports_method(Methods.workspace_symbol) then
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

  map({ 'n', 'x' }, '<leader>rr', function()
    code_action_kind(CodeActionKind.Refactor)
  end, { desc = 'List refactor code actions' })
end

---@param bufnr number The buffer number.
local function enable_document_highlight(bufnr)
  local group =
    vim.api.nvim_create_augroup(string.format('lsp_document_highlight_%d', bufnr), { clear = true })

  vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
    callback = vim.lsp.buf.document_highlight,
    buffer = bufnr,
    group = group,
  })

  vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI', 'BufLeave' }, {
    callback = vim.lsp.buf.clear_references,
    buffer = bufnr,
    group = group,
  })
end

---@param client vim.lsp.Client The client to disable document highlight for.
---@param bufnr number The buffer number.
local function disable_document_highlight(client, bufnr)
  if client:supports_method(Methods.textDocument_documentHighlight) then
    local group = string.format('lsp_document_highlight_%d', bufnr)
    local autocmds = vim.api.nvim_get_autocmds({ group = group, buffer = bufnr })
    if not vim.tbl_isempty(autocmds) then
      vim.api.nvim_del_augroup_by_id(autocmds[1].group)
    end
  end
end

---@param client vim.lsp.Client The client to enable completion for.
---@param bufnr number The buffer number.
local function enable_completion(client, bufnr)
  vim.bo[bufnr].completeopt = 'menu,fuzzy,noselect,popup'

  -- Remove annoying trigger characters from LuaLS.
  if client.name == 'lua_ls' then
    -- { "\t", "\n", ".", ":", "(", "'", '"', "[", ",", "#", "*", "@", "|", "=", "-", "{", " ", "+", "?" }
    local trigger_characters = client.server_capabilities.completionProvider.triggerCharacters
    if trigger_characters then
      for _, c in pairs({ '\t', '\n', ' ' }) do
        for i, v in ipairs(trigger_characters) do
          if c == v then
            table.remove(trigger_characters, i)
          end
        end
      end
    end
  end

  vim.lsp.completion.enable(true, client.id, bufnr, { autotrigger = true })
end

vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local bufnr = args.buf --[[@as number]]
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if not client then
      return
    end

    vim.bo[bufnr].tagfunc = [[v:lua.require'lsp.tagfunc']]

    setup_mappings(bufnr, client)

    if client:supports_method(Methods.textDocument_documentHighlight) then
      enable_document_highlight(bufnr)
    end

    if client:supports_method(Methods.textDocument_inlayHint) then
      vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
    end

    if client:supports_method(Methods.textDocument_completion) then
      enable_completion(client, bufnr)
    end
  end,
})

vim.api.nvim_create_autocmd('LspDetach', {
  callback = function(args)
    local bufnr = args.buf --[[@as number]]
    if not vim.api.nvim_buf_is_loaded(bufnr) then
      return
    end

    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if not client then
      return
    end

    if client:supports_method(Methods.textDocument_inlayHint) then
      vim.lsp.inlay_hint.enable(false, { bufnr = bufnr })
    end

    if client:supports_method(Methods.textDocument_completion) then
      vim.lsp.completion.enable(false, client.id, bufnr, {})
      vim.bo[bufnr].completeopt = nil
    end

    disable_document_highlight(client, bufnr)
  end,
})

vim.api.nvim_create_user_command('LspRestart', function(params)
  local bufnr = vim.api.nvim_get_current_buf()
  local name = params.args
  vim.notify('Restarting LSP server: ' .. name)

  local clients = vim.lsp.get_clients({ bufnr = bufnr, name = name })
  for _, client in pairs(clients) do
    local attached_buffers = vim.tbl_keys(client.attached_buffers)
    client:stop()
    ---@diagnostic disable-next-line: redefined-local
    require('lsp').start(client.config, function(client)
      for _, ab in pairs(attached_buffers) do
        vim.lsp.buf_attach_client(ab, client.id)
      end
    end)
  end
end, {
  nargs = 1,
  complete = function()
    local bufnr = vim.api.nvim_get_current_buf()
    return vim
      .iter(vim.lsp.get_clients({ bufnr = bufnr }))
      :map(function(client)
        return client.name
      end)
      :totable()
  end,
})
