if vim.env.SSH_TTY then
  local split, getreg, getregtype = vim.fn.split, vim.fn.getreg, vim.fn.getregtype
  local function paste()
    return {
      split(getreg(''), '\n'),
      getregtype(''),
    }
  end

  if vim.env.TERM:find('wezterm') then
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
  elseif vim.env.TERM:find('ghostty') then
    vim.g.clipboard = {
      name = 'OSC 52',
      copy = {
        ['+'] = require('vim.ui.clipboard.osc52').copy('+'),
        ['*'] = require('vim.ui.clipboard.osc52').copy('*'),
      },
      paste = {
        ['+'] = require('vim.ui.clipboard.osc52').paste('+'),
        ['*'] = require('vim.ui.clipboard.osc52').paste('*'),
      },
    }
  end
end
