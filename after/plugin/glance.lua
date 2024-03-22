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
