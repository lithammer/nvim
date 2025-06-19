local fs, uv = vim.fs, vim.uv

local M = {}

--- @param path string
--- @return string data
local function readfile(path)
  local f = assert(uv.fs_open(path, 'r', 438))
  local size = assert(uv.fs_fstat(f)).size
  local data = assert(uv.fs_read(f, size, 0))
  assert(uv.fs_close(f))
  return data
end

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

---@param bufnr number
---@param name string
---@return string?
function M.find_package_json(bufnr, name)
  local matches = fs.find('package.json', {
    path = vim.api.nvim_buf_get_name(bufnr),
    upward = true,
    limit = math.huge,
    type = 'file',
  })

  for _, path in ipairs(matches) do
    local package_json = vim.json.decode(readfile(path))

    local dependencies = package_json.dependencies or {}
    local dev_dependencies = package_json.devDependencies or {}

    if dependencies[name] or dev_dependencies[name] then
      return fs.dirname(path)
    end
  end
end

---@param cmd string[]
---@return fun(dispatchers: vim.lsp.rpc.Dispatchers, config: vim.lsp.ClientConfig): vim.lsp.rpc.PublicClient
function M.node_modules_cmd(cmd)
  return function(dispatchers, _config)
    local bufnr = vim.api.nvim_get_current_buf()
    if cmd[1] then
      cmd[1] = node_modules_bin(bufnr, cmd[1])
    end
    return vim.lsp.rpc.start(cmd, dispatchers)
  end
end

return M
