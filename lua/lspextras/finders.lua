local fs, uv = vim.fs, vim.uv

local M = {}

---@param bufnr number
---@param name string
---@return string?
local function node_modules_bin(bufnr, name)
  local matches = fs.find('node_modules', {
    path = vim.api.nvim_buf_get_name(bufnr),
    upward = true,
    limit = math.huge,
    type = 'directory',
  })

  for _, node_modules in ipairs(matches) do
    local path = fs.joinpath(node_modules, '.bin', name)
    if uv.fs_stat(path) then
      return path
    end
  end

  return nil
end

---@param cmd string[]
---@return fun(dispatchers: vim.lsp.rpc.Dispatchers): vim.lsp.rpc.PublicClient
function M.node_modules_cmd(cmd)
  local bufnr = vim.api.nvim_get_current_buf()

  return function(dispatchers)
    if cmd[1] then
      cmd[1] = node_modules_bin(bufnr, cmd[1])
    end
    return vim.lsp.rpc.start(cmd, dispatchers)
  end
end

return M
