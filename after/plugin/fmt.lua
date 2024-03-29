require('conform').setup({
  formatters = {
    nimpretty = {
      command = 'nimpretty',
      args = { '$FILENAME' },
      stdin = false,
    },
    nph = {
      command = 'nph',
      args = { '-' },
    },
  },
  formatters_by_ft = {
    javascript = { { 'biome-check', 'prettier' } },
    lua = { 'stylua' },
    nim = { { 'nph', 'nimpretty' } },
    python = { { 'ruff_format', 'black' } },
    sh = { 'shfmt' },
    toml = { 'taplo' },
    typescript = { { 'biome-check', 'prettier' } },
  },
  format_on_save = function(bufnr)
    if
      vim.b[bufnr].disable_autoformat == false -- Prefer buffer local settings.
      or not (vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat)
    then
      return {
        timeout_ms = 500,
        lsp_fallback = true,
      }
    end
  end,
  notify_on_error = false,
})

vim.api.nvim_create_user_command('FormatDisable', function(args)
  if args.bang then
    vim.b.disable_autoformat = true
  else
    vim.g.disable_autoformat = true
  end
end, {
  desc = 'Disable format-on-save',
  bang = true,
})

vim.api.nvim_create_user_command('FormatEnable', function(args)
  if args.bang then
    vim.b.disable_autoformat = false
  else
    vim.g.disable_autoformat = false
  end
end, {
  desc = 'Enable format-on-save',
  bang = true,
})
