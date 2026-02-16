require('blink-cmp').setup({
  keymap = {
    preset = 'default',
    ['<cr>'] = { 'select_and_accept', 'fallback' },
    ['<Tab>'] = {
      'snippet_forward',
      function() -- sidekick next edit suggestion
        return require('sidekick').nes_jump_or_apply()
      end,
      -- function() -- if you are using Neovim's native inline completions
      --   return vim.lsp.inline_completion.get()
      -- end,
      'fallback',
    },
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
    default = { 'lsp', 'path', 'snippets', 'buffer' },
  },
})
