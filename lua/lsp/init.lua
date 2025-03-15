local fn = vim.fn

local M = {}

---@param name string Name of the binary.
function M.has_server(name)
  return fn.executable(name) == 1
end

return M
