-- https://github.com/neovim/neovim/pull/32756#issuecomment-2724027664
local function wait_for_termfeatures(n, cb)
  if n == 0 then
    vim.notify('Failed to get g:termfeatures', vim.log.levels.ERROR)
  else
    if vim.g.termfeatures then
      cb(vim.g.termfeatures)
    else
      vim.defer_fn(function()
        wait_for_termfeatures(n - 1, cb)
      end, 100)
    end
  end
end

wait_for_termfeatures(10, function(termfeatures)
  if vim.env.SSH_TTY and termfeatures.osc52 then
    local osc52 = require('vim.ui.clipboard.osc52')
    vim.g.clipboard = {
      name = 'OSC 52',
      copy = {
        ['+'] = osc52.copy('+'),
        ['*'] = osc52.copy('*'),
      },
      paste = {
        ['+'] = osc52.paste('+'),
        ['*'] = osc52.paste('*'),
      },
    }

    -- https://github.com/wezterm/wezterm/discussions/5231
    if vim.env.TERM:find('wezterm') then
      local function paste()
        return {
          vim.fn.split(vim.fn.getreg(''), '\n'),
          vim.fn.getregtype(''),
        }
      end
      vim.g.clipboard.paste = {
        ['+'] = paste,
        ['*'] = paste,
      }
    end
  end
end)
