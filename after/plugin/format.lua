require('conform').setup({
  formatters = {
    buf = {
      -- Override to add `--path` argument:
      -- https://github.com/bufbuild/buf/issues/3593
      args = { 'format', '-w', '--path', '$FILENAME' },
    },
  },
  formatters_by_ft = {
    bzl = { 'buildifier' },
    css = { 'biome' },
    fish = { 'fish_indent' },
    hurl = { 'hurlfmt' },
    javascript = { 'biome-check', 'prettier', stop_after_first = true },
    lua = { 'stylua' },
    make = { 'bake' },
    nim = { 'nph', 'nimpretty', stop_after_first = true },
    perl = { 'perltidy' },
    proto = { 'buf' },
    python = { 'ruff_format', 'ruff_organize_imports' },
    sh = { 'shfmt' },
    toml = { 'tombi', 'taplo', stop_after_first = true },
    terraform = { 'terraform_fmt' },
    typescript = { 'biome-check', 'prettier', stop_after_first = true },
  },
  format_on_save = function(bufnr)
    if
      vim.b[bufnr].disable_autoformat == false -- Prefer buffer local settings.
      or not (vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat)
    then
      return {
        lsp_format = 'fallback',
        timeout_ms = 1000,
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
