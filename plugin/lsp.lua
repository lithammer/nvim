vim.diagnostic.config({ signs = true, severity_sort = true })

do
  local signs = {
    -- Error = ' ',
    -- Warn = ' ',
    -- Hint = ' ',
    -- Info = ' ',
    Error = ' ',
    Warn = ' ',
    Info = ' ',
    Hint = ' ',
  }
  for type, icon in pairs(signs) do
    local hl = 'DiagnosticSign' .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = '' })
  end
end

local function on_attach(args)
  local lsp = require('lsp')

  local bufnr = args.buf
  local client = vim.lsp.get_client_by_id(args.data.client_id)
  if not client then
    return
  end

  if client.server_capabilities.documentHighlightProvider then
    lsp.setup_document_highlight(bufnr)
  end

  vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
end

vim.api.nvim_create_autocmd('LspAttach', { callback = on_attach })
