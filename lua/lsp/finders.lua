local fn, fs = vim.fn, vim.fs

local M = {}

---@param path string
---@return string
local function abspath(path)
  return fn.fnamemodify(path, ':p')
end

---@param path string
---@return boolean
local function isdirectory(path)
  return fn.isdirectory(path) == 1
end

---@param bufnr number?
---@return string
function M.bufdir(bufnr)
  local bufpath = vim.api.nvim_buf_get_name(bufnr or 0)
  if not isdirectory(bufpath) then
    bufpath = fs.dirname(bufpath)
  end
  return bufpath
end

---@param names string|fun(name: string, path: string):boolean|string[]
---@return string?
function M.find(names)
  local matches = fs.find(names, {
    path = M.bufdir(),
    upward = true,
  })
  if vim.tbl_isempty(matches) then
    return nil
  end

  return abspath(matches[1])
end

---@param bufnr number
---@return string?
local function find_node_modules(bufnr)
  local matches = fs.find('node_modules', {
    upward = true,
    path = M.bufdir(bufnr),
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
