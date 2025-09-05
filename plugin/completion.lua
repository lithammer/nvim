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
