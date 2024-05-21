local keymap = vim.keymap

local Methods = vim.lsp.protocol.Methods

-- Tentative Neovim 0.11 LSP mappings.
do
  vim.keymap.set('n', 'gln', function()
    vim.lsp.buf.rename()
  end, { desc = 'vim.lsp.buf.rename()' })

  vim.keymap.set({ 'n', 'x' }, 'gll', function()
    vim.lsp.buf.code_action()
  end, { desc = 'vim.lsp.buf.code_action()' })

  vim.keymap.set('n', 'glr', function()
    vim.lsp.buf.references()
  end, { desc = 'vim.lsp.buf.references()' })

  vim.keymap.set('i', '<C-S>', function()
    vim.lsp.buf.signature_help()
  end, { desc = 'vim.lsp.buf.signature_help()' })
end

vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local bufnr = args.buf
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if not client then
      return
    end

    local function keymap_set(mode, lhs, rhs, opts)
      opts = vim.tbl_extend('force', opts or {}, { buffer = bufnr })
      keymap.set(mode, lhs, rhs, opts)
    end

    ---@param kind string
    local function code_action_kind(kind)
      ---@diagnostic disable-next-line: missing-fields
      vim.lsp.buf.code_action({ context = { only = { kind } } })
    end

    keymap_set('n', 'gd', vim.lsp.buf.definition)
    keymap_set('n', 'gP', '<cmd>Glance definitions<cr>')
    keymap_set('n', 'gD', vim.lsp.buf.declaration)
    keymap_set('n', 'gy', '<cmd>Glance type_definitions<cr>')

    if client.supports_method(Methods.textDocument_implementation) then
      keymap_set('n', 'gI', '<cmd>Glance implementations<cr>')
      -- keymap_set('n', 'gI', vim.lsp.buf.implementation)
      -- keymap_set('n', 'g<C-I>', vim.lsp.buf.implementation, { buffer = args.buf })
    end

    -- keymap_set('n', 'gy', vim.lsp.buf.type_definition)
    -- keymap_set('n', 'gr', vim.lsp.buf.references)
    keymap_set('n', 'gr', '<cmd>Glance references<cr>')
    keymap_set('n', 'gO', vim.lsp.buf.document_symbol)
    keymap_set('n', 'gW', vim.lsp.buf.workspace_symbol)
    keymap_set('n', 'crR', function()
      code_action_kind('source')
    end)
    keymap_set('n', '<leader>r', function()
      code_action_kind('refactor')
    end)
  end,
})
