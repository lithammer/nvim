require('blink-cmp').setup({
  keymap = {
    preset = 'default',
    ['<cr>'] = { 'select_and_accept', 'fallback' },
  },
  completion = {
    documentation = {
      auto_show = true,
      auto_show_delay_ms = 500,
    },
    menu = {
      draw = {
        treesitter = {},
        columns = { { 'label', 'label_description', gap = 1 }, { 'kind' } },
      },
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
