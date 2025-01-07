local add, later = MiniDeps.add, MiniDeps.later

local on_exit = function(obj)
  if obj.code == 0 then
    vim.notify('Building blink.cmp done', vim.log.levels.INFO)
  else
    vim.notify('Building blink.cmp failed', vim.log.levels.ERROR)
  end
end

local build_blink = function(params, async)
  vim.notify('Building blink.cmp', vim.log.levels.INFO)
  local cmd = { 'cargo', 'build', '--release' }
  local env = { CARGO_NET_GIT_FETCH_WITH_CLI = 'true' }
  local opts = { cwd = params.path, env = env }
  if async then
    vim.system(cmd, opts, on_exit)
  else
    local obj = vim.system(cmd, opts):wait()
    on_exit(obj)
  end
end

add({
  source = 'Saghen/blink.cmp',
  hooks = {
    post_install = function(params)
      build_blink(params, false)
    end,
    post_checkout = function(params)
      build_blink(params, true)
    end,
  },
})

later(function()
  require('blink-cmp').setup({
    keymap = {
      preset = 'default',
      ['<cr>'] = { 'select_and_accept', 'fallback' },
    },
    appearance = {
      use_nvim_cmp_as_default = false,
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
      cmdline = {},
    },
  })
end)
