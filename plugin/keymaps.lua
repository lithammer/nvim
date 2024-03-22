local set = vim.keymap.set

-- local function noremap(mode, lhs, rhs, opts)
--   opts = opts or {}
--   opts['noremap'] = true
--   set(mode, lhs, rhs, opts)
--   -- set(mode, lhs, rhs, vim.tbl_extend('keep', { noremap = true }, opts or {}))
-- end

local function noremap(mode, lhs, rhs, ...)
  local opts = vim.tbl_extend('error', { noremap = true }, ...)
  set(mode, lhs, rhs, opts)
end

-- stylua: ignore start
local function cnoremap(...) noremap('c', ...) end
local function inoremap(...) noremap('i', ...) end
local function nnoremap(...) noremap('n', ...) end
local function onoremap(...) noremap('o', ...) end
local function vnoremap(...) noremap('v', ...) end
local function xnoremap(...) noremap('x', ...) end
-- stylua: ignore end

vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local bufnr = args.buf

    local code_action_source = function()
      vim.lsp.buf.code_action({
        context = {
          only = {
            'source',
          },
          diagnostics = {},
        },
      })
    end

    -- local keymaps = {
    --   { 'n', 'K', vim.lsp.buf.hover },
    --   { 'n', 'gd', vim.lsp.buf.definition },
    --   { 'n', 'gP', '<cmd>Glance definitions<cr>' },
    --   { 'n', 'gD', vim.lsp.buf.declaration },
    --   -- { 'n', 'gy', vim.lsp.buf.type_definition },
    --   { 'n', 'gy', '<cmd>Glance type_definitions<cr>' },
    --   -- { 'n', 'gI', vim.lsp.buf.implementation },
    --   { 'n', 'gI', '<cmd>Glance implementations<cr>' },
    --   { 'n', 'gK', vim.lsp.buf.signature_help },
    --   { 'i', '<c-k>', vim.lsp.buf.signature_help },
    --   { 'n', '<leader>r', vim.lsp.buf.rename },
    --   -- { 'n', 'gr', vim.lsp.buf.references },
    --   { 'n', 'gr', '<cmd>Glance references<cr>' },
    --   { 'n', 'gO', vim.lsp.buf.document_symbol },
    --   { 'n', 'gW', vim.lsp.buf.workspace_symbol },
    --   { { 'n', 'v' }, 'ga', vim.lsp.buf.code_action },
    --   { 'n', 'gA', code_action_source },
    --   {
    --     'n',
    --     '[g',
    --     function()
    --       vim.diagnostic.goto_prev({ wrap = false, float = false })
    --     end,
    --   },
    --   {
    --     'n',
    --     ']g',
    --     function()
    --       vim.diagnostic.goto_next({ wrap = false, float = false })
    --     end,
    --   },
    -- }

    -- for _, keymap in pairs(keymaps) do
    --   local mode, lhs, rhs, extra_opts = unpack(keymap)
    --   local default_opts = { buffer = bufnr, silent = true }
    --   local opts = vim.tbl_extend('error', default_opts, extra_opts or {})
    --   set(mode, lhs, rhs, opts)
    -- end

    local opts = { buffer = bufnr, silent = true }

    nnoremap('K', vim.lsp.buf.hover, opts)
    nnoremap('gd', vim.lsp.buf.definition, opts)
    nnoremap('gP', '<cmd>Glance definitions<cr>', opts)
    nnoremap('gD', vim.lsp.buf.declaration, opts)
    nnoremap('gy', '<cmd>Glance type_definitions<cr>', opts)
    nnoremap('gI', '<cmd>Glance implementations<cr>', opts)
    nnoremap('gK', vim.lsp.buf.signature_help, opts)
    inoremap('<c-k>', vim.lsp.buf.signature_help, opts)
    nnoremap('<leader>r', vim.lsp.buf.rename, opts)
    nnoremap('gr', '<cmd>Glance references<cr>', opts)
    nnoremap('gO', vim.lsp.buf.document_symbol, opts)
    nnoremap('gW', vim.lsp.buf.workspace_symbol, opts)
    nnoremap('ga', vim.lsp.buf.code_action, opts)
    vnoremap('ga', vim.lsp.buf.code_action, opts)
    nnoremap('gA', code_action_source, opts)
    nnoremap('[g', function()
      vim.diagnostic.goto_prev({ wrap = false, float = false })
    end, opts)
    nnoremap(']g', function()
      vim.diagnostic.goto_next({ wrap = false, float = false })
    end, opts)
  end,
})

-- vim-qf
nnoremap('<leader>q', '<plug>(qf_qf_toggle)', { desc = 'Toggle quickfix window' })
nnoremap(']q', '<plug>(qf_qf_next)', { desc = 'Go down the quickfix list' })
nnoremap('[q', '<plug>(qf_qf_previous)', { desc = 'Go up the quickfix list' })
nnoremap(']l', '<plug>(qf_loc_next)', { desc = 'Go down the current location list' })
nnoremap('[l', '<plug>(qf_loc_previous)', { desc = 'Go up the current location list' })
-- set('n', '<leader>q', '<plug>(qf_qf_toggle)', { desc = 'Toggle quickfix window' })
-- set('n', ']q', '<plug>(qf_qf_next)', { desc = 'Go down the quickfix list' })
-- set('n', '[q', '<plug>(qf_qf_previous)', { desc = 'Go up the quickfix list' })
-- set('n', ']l', '<plug>(qf_loc_next)', { desc = 'Go down the current location list' })
-- set('n', '[l', '<plug>(qf_loc_previous)', { desc = 'Go up the current location list' })

-- flash
-- stylua: ignore start
set({ 'n', 'x', 'o' }, 's',  require('flash').jump, { desc = 'Flash' })
set({ 'n', 'x', 'o' }, 'S', require('flash').treesitter, { desc = 'Flash Treesitter' })
set('o', 'r', require('flash').remote, { desc = 'Remote Flash' })
set({ 'o', 'x' }, 'R', require('flash').treesitter_search, { desc = 'Treesitter Search' })
set({ 'c' }, '<c-s>', require('flash').toggle, { desc = 'Toggle Flash Search' })
-- stylua: ignore end
