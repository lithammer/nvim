local keymap = vim.keymap

local Methods = vim.lsp.protocol.Methods

vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local bufnr = args.buf
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if not client then
      return
    end

    ---@param kind string
    local function code_action_kind(kind)
      ---@diagnostic disable-next-line: missing-fields
      vim.lsp.buf.code_action({ context = { only = { kind } } })
    end

    keymap.set('n', 'gd', vim.lsp.buf.definition, { buffer = bufnr })
    keymap.set('n', 'gP', '<cmd>Glance definitions<cr>', { buffer = bufnr })
    keymap.set('n', 'gD', vim.lsp.buf.declaration, { buffer = bufnr })
    keymap.set('n', 'gy', '<cmd>Glance type_definitions<cr>', { buffer = bufnr })

    if client.supports_method(Methods.textDocument_implementation) then
      keymap.set('n', 'gI', '<cmd>Glance implementations<cr>', { buffer = bufnr })
      -- keymap.set('n', 'gI', vim.lsp.buf.implementation, { buffer = bufnr })
      -- keymap.set('n', 'g<C-I>', vim.lsp.buf.implementation, { buffer = bufnr })
    end

    -- keymap.set('n', 'gy', vim.lsp.buf.type_definition, { buffer = bufnr })
    keymap.set('n', 'grr', '<cmd>Glance references<cr>', { buffer = bufnr })
    keymap.set('n', 'gO', vim.lsp.buf.document_symbol, { buffer = bufnr })
    keymap.set('n', 'gW', vim.lsp.buf.workspace_symbol, { buffer = bufnr })
    keymap.set('n', 'crR', function()
      code_action_kind('source')
    end, { buffer = bufnr })
    keymap.set('n', '<leader>r', function()
      code_action_kind('refactor')
    end, { buffer = bufnr })
  end,
})
