local Methods = vim.lsp.protocol.Methods
local CodeActionKind = vim.lsp.protocol.CodeActionKind

---@param input string
local function trouble(input)
  local width = vim.o.columns
  local is_small_window = width < 100
  local preview = {
    type = 'split',
    relative = 'win',
    position = is_small_window and 'top' or 'right',
    size = is_small_window and 100 or 0.3,
  }

  local ret = require('trouble.command').parse(input)
  ret.action = ret.action or 'open'
  ret.opts.mode = ret.opts.mode or ret.mode
  if not ret.opts.preview then
    ret.opts.preview = preview
  end
  require('trouble')[ret.action](ret.opts)
end

---@param kind lsp.CodeActionKind
local function code_action_kind(kind)
  ---@diagnostic disable-next-line: missing-fields
  vim.lsp.buf.code_action({ context = { only = { kind } } })
end

---@module 'snacks'

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

  if client:supports_method(Methods.textDocument_implementation) then
    map('n', 'gri', function()
      trouble('lsp_implementations first focus=true auto_refresh=false')
    end, { desc = 'List implementations' })
  end

  map('n', 'grr', function()
    trouble('lsp_references first focus=true auto_refresh=false')
  end, { desc = 'List references' })

  map('n', '<leader>d', function()
    trouble('diagnostics toggle filter.buf=0')
  end, { desc = 'List buffer diagnostics' })

  map('n', '<leader>D', function()
    trouble('diagnostics toggle')
  end, { desc = 'List workspace diagnostics' })

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
    vim.api.nvim_create_augroup(string.format('lsp_document_highlight:%d', bufnr), { clear = true })

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
    local group = string.format('lsp_document_highlight:%d', bufnr)
    local autocmds = vim.api.nvim_get_autocmds({ group = group, buffer = bufnr })
    if not vim.tbl_isempty(autocmds) then
      vim.api.nvim_del_augroup_by_id(autocmds[1].group)
    end
  end
end

vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local bufnr = args.buf --[[@as number]]
    local client = assert(vim.lsp.get_client_by_id(args.data.client_id))

    vim.bo[bufnr].tagfunc = [[v:lua.require'lspextras.tagfunc']]

    setup_mappings(bufnr, client)

    if client:supports_method(Methods.textDocument_documentHighlight) then
      enable_document_highlight(bufnr)
    end

    if client:supports_method(Methods.textDocument_inlayHint) then
      vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
    end

    if client:supports_method(Methods.textDocument_codeLens) then
      vim.keymap.set(
        'n',
        '<leader>Ln',
        vim.lsp.codelens.run,
        { buffer = bufnr, desc = 'Run codelens' }
      )
      local group = vim.api.nvim_create_augroup(
        string.format('lsp_document_codelens:%d', bufnr),
        { clear = true }
      )
      vim.api.nvim_create_autocmd({ 'BufEnter', 'CursorHold', 'InsertLeave' }, {
        group = group,
        buffer = bufnr,
        callback = function()
          vim.lsp.codelens.refresh({ bufnr = bufnr })
        end,
      })
      vim.api.nvim_create_autocmd('InsertLeave', {
        group = group,
        buffer = bufnr,
        callback = function()
          vim.lsp.codelens.display(nil, bufnr, client.id)
        end,
      })
    end

    if client:supports_method(Methods.textDocument_rangeFormatting) then
      -- vim.bo[bufnr].formatexpr = 'v:lua.vim.lsp.formatexpr()'
      vim.bo[bufnr].formatexpr = [[v:lua.require'conform'.formatexpr()]]
    end

    if client:supports_method(Methods.textDocument_foldingRange) then
      local winid = vim.fn.bufwinid(bufnr)
      if vim.api.nvim_win_is_valid(winid) then
        vim.wo[winid].foldmethod = 'expr'
        vim.wo[winid].foldexpr = 'v:lua.vim.lsp.foldexpr()'
        vim.wo[winid].foldtext = 'v:lua.vim.lsp.foldtext()'
      end
    end

    if client:supports_method(Methods.workspace_didChangeConfiguration) then
      require('lspextras').apply_local_settings(client)
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
  local name = params.args
  vim.notify('Restarting LSP server: ' .. name)

  local clients = vim.lsp.get_clients({ name = name })
  for _, client in pairs(clients) do
    local attached_buffers = vim.lsp.get_buffers_by_client_id(client.id)
    client:stop()

    vim.defer_fn(function()
      local config =
        vim.tbl_extend('force', vim.lsp.config[client.name], { root_dir = client.root_dir })
      for _, bufnr in pairs(attached_buffers) do
        vim.lsp.start(config, { bufnr = bufnr })
      end
    end, 1000)
  end
end, {
  nargs = 1,
  complete = function()
    local names = {}
    for _, client in ipairs(vim.lsp.get_clients()) do
      table.insert(names, client.name)
    end
    return names
  end,
})

vim.lsp.config('*', {
  root_markers = { '.git' },
  capabilities = {
    workspace = {
      didChangeWatchedFiles = {
        -- Enable dynamic registration of watched files. However might not work great on Linux.
        -- https://github.com/neovim/neovim/pull/28690
        -- https://github.com/neovim/neovim/pull/29374
        dynamicRegistration = true,
      },
    },
  },
})

vim.lsp.enable({
  'ansiblels',
  'awkls',
  -- 'basedpyright',
  'bashls',
  'bazel_lsp',
  'biome',
  'bufls',
  'clangd',
  'crystalline',
  'cssls',
  'dockerls',
  -- 'emmylua_ls',
  'gleam',
  'gopls',
  'html',
  'jinja_lsp',
  'jsonls',
  'jsonnet_ls',
  'lua_ls',
  -- 'oxc',
  'markdown',
  'nimlangserver',
  'postgrestools',
  'protols',
  'pyrefly',
  -- 'pyright',
  'ruff',
  'rust_analyzer',
  -- 'starlark',
  'starpls',
  'superhtml',
  -- 'taplo',
  'terraformls',
  'tombi',
  -- 'tsgo',
  -- 'ty',
  'typos_lsp',
  'vimls',
  'vtsls',
  'yamlls',
  'zls',
})
