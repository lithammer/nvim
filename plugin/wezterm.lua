if vim.env.TERM:find('wezterm') and vim.env.SSH_TTY then
  local fn = vim.fn
  local function paste()
    return {
      fn.split(fn.getreg(''), '\n'),
      fn.getregtype(''),
    }
  end

  vim.g.clipboard = {
    name = 'OSC 52',
    copy = {
      ['+'] = require('vim.ui.clipboard.osc52').copy('+'),
      ['*'] = require('vim.ui.clipboard.osc52').copy('*'),
    },
    paste = {
      ['+'] = paste,
      ['*'] = paste,
    },
  }
end
