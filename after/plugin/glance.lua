local add, later = MiniDeps.add, MiniDeps.later

add('DNLHC/glance.nvim')

later(function()
  local glance = require('glance')

  -- local horiz = vim.opt.fillchars:get().horiz

  ---@diagnostic disable-next-line: missing-fields
  glance.setup({
    -- detached = true,
    border = {
      enable = true,
      top_char = ' ͞',
      bottom_char = '_',
    },
  })
end)
