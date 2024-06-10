local Methods = vim.lsp.protocol.Methods

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
})

local function on_attach(args)
  local lsp = require('lsp')

  local bufnr = args.buf
  local client = vim.lsp.get_client_by_id(args.data.client_id)
  if not client then
    return
  end

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
