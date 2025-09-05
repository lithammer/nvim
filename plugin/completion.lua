local build_blink = function(params)
  vim.notify('Building blink.cmp', vim.log.levels.INFO)
  local cmd = { 'cargo', 'build', '--release' }
  local env = { CARGO_NET_GIT_FETCH_WITH_CLI = 'true' }
  local opts = { cwd = params.path, env = env }

  vim.system(cmd, opts, function(obj)
    if obj.code == 0 then
      vim.notify('Building blink.cmp done', vim.log.levels.INFO)
    else
      vim.notify('Building blink.cmp failed', vim.log.levels.ERROR)
    end
  end)
end

do
  local group = vim.api.nvim_create_augroup('blink_cmp_update', { clear = true })
  vim.api.nvim_create_autocmd('PackChanged', {
    desc = 'Build blink.cmp',
    group = group,
    callback = function(event)
      local spec = event.data.spec
      local kind = event.data.kind

      if spec and spec.name == 'blink.cmp' and (kind == 'install' or kind == 'update') then
        build_blink(params)
      end
    end,
  })
end

require('blink-cmp').setup({
  keymap = {
    preset = 'default',
    ['<cr>'] = { 'select_and_accept', 'fallback' },
  },
  completion = {
    documentation = {
      auto_show = true,
    },
    menu = {
      draw = {
        treesitter = {},
        columns = { { 'label', 'label_description', gap = 1 }, { 'kind' } },
      },
    },
  },
  fuzzy = {
    prebuilt_binaries = {
      download = false, -- Always compile since we track 'main'
    },
  },
  sources = {
    default = { 'lazydev', 'lsp', 'path', 'snippets', 'buffer' },
    providers = {
      lazydev = {
        name = 'LazyDev',
        module = 'lazydev.integrations.blink',
        score_offset = 100,
      },
    },
  },
  cmdline = { enabled = false },
})
