local fn, fs, uv = vim.fn, vim.fs, vim.uv

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

---@param names string|string[]|fun(name: string, path: string): boolean Names of the items to find.
---@return string?
function M.find(names)
  local bufnr = vim.api.nvim_get_current_buf()

  local path
  if vim.bo[bufnr].buftype ~= '' then
    path = assert(uv.cwd())
  else
    path = vim.api.nvim_buf_get_name(bufnr)
  end

  local paths = fs.find(names, {
    upward = true,
    path = fn.fnamemodify(path, ':p:h'),
  })

  if #paths == 0 then
    return nil
  end

  return fs.normalize(paths[1])
end

return M
