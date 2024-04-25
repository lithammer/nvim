local keymap = vim.keymap

vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local bufnr = args.buf

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
    keymap_set('n', 'gI', '<cmd>Glance implementations<cr>')
    -- keymap_set('n', 'gy', vim.lsp.buf.type_definition)
    -- keymap_set('n', 'gI', vim.lsp.buf.implementation)
    keymap_set('i', '<c-s>', vim.lsp.buf.signature_help)
    keymap_set('n', 'crn', vim.lsp.buf.rename)
    -- keymap_set('n', 'gr', vim.lsp.buf.references)
    keymap_set('n', 'gr', '<cmd>Glance references<cr>')
    keymap_set('n', 'gO', vim.lsp.buf.document_symbol)
    keymap_set('n', 'gW', vim.lsp.buf.workspace_symbol)
    keymap_set('n', 'cra', vim.lsp.buf.code_action)
    keymap_set('n', 'crA', function()
      code_action_kind('source')
    end)
    keymap_set('n', '<leader>r', function()
      code_action_kind('refactor')
    end)

    keymap_set('n', '[d', function()
      vim.diagnostic.goto_prev({ wrap = false, float = false })
    end)
    keymap_set('n', ']d', function()
      vim.diagnostic.goto_next({ wrap = false, float = false })
    end)

    keymap_set('n', '<c-w>d', function()
      vim.diagnostic.open_float({ border = 'rounded' })
    end, {
      desc = 'Open a floating window showing diagnostics under the cursor',
    })
    keymap_set('n', '<c-w><c-d>', function()
      vim.diagnostic.open_float({ border = 'rounded' })
    end, {
      desc = 'Open a floating window showing diagnostics under the cursor',
    })
  end,
})
