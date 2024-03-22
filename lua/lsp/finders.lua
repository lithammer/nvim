local fs = vim.fs

local M = {}

---@param path string
---@return string
local function abspath(path)
  return vim.fn.fnamemodify(path, ':p')
end

---@param bufnr number
---@return string?
local function find_node_modules(bufnr)
  local path = fs.dirname(vim.api.nvim_buf_get_name(bufnr))
  local matches = fs.find('node_modules', {
    upward = true,
    path = path,
    type = 'directory',
  })

  if vim.tbl_isempty(matches) then
    return nil
  end

  return abspath(matches[1])
end

---@param name string Name of the binary.
---@return string?
function M.node_modules_bin(name)
  local bufnr = vim.api.nvim_get_current_buf()
  local node_modules = find_node_modules(bufnr)
  return node_modules and fs.joinpath(node_modules, '.bin', name) or nil
end

return M
