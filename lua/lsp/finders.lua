local fs = vim.fs

local M = {}

---@param bufnr number
---@return string?
local function find_node_modules(bufnr)
  local match = fs.root(bufnr, 'node_modules')
  if not match then
    return nil
  end
  return fs.joinpath(match, 'node_modules')
end

---@param name string Name of the binary.
---@return string?
function M.node_modules_bin(name)
  local bufnr = vim.api.nvim_get_current_buf()
  local node_modules = find_node_modules(bufnr)
  return node_modules and fs.joinpath(node_modules, '.bin', name) or nil
end

return M
