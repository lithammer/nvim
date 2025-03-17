local fn, fs, uv = vim.fn, vim.fs, vim.uv
local Methods = vim.lsp.protocol.Methods

local M = {}

--- @param path string
--- @param mode integer
--- @return string? data
local function readfile(path, mode)
  local f = uv.fs_open(path, 'r', mode)
  if f then
    local size = assert(uv.fs_fstat(f)).size
    local data = uv.fs_read(f, size, 0)
    uv.fs_close(f)
    return data
  end
end

---@param client vim.lsp.Client Client to get settings for.
---@return table?
local function get_local_workspace_settings(client)
  if not client.root_dir then
    return
  end

  local match = fs.root(client.root_dir, '.lsp.json')
  if not match then
    return
  end

  local data = readfile(fs.joinpath(match, '.lsp.json'), 438)
  if not data then
    return
  end

  local settings = vim.json.decode(data)
  local filtered_settings = {}
  for _, key in pairs(vim.tbl_keys(client.settings)) do
    filtered_settings[key] = settings[key]
  end

  if vim.tbl_isempty(filtered_settings) then
    return
  end

  return filtered_settings
end

---@param client vim.lsp.Client
function M.apply_local_settings(client)
  local local_settings = get_local_workspace_settings(client)
  if local_settings then
    -- TODO: Maybe use active settings (i.e. client.settings) instead of user
    -- settings (client.config.settings). This might play nicer with lazydev for example.
    local old_settings = vim.deepcopy(client.config.settings or {})
    client.config.settings = vim.tbl_deep_extend('force', old_settings, local_settings)
    client.settings = vim.tbl_deep_extend('force', old_settings, local_settings)

    if not vim.deep_equal(old_settings, client.config.settings) then
      client:notify(Methods.workspace_didChangeConfiguration, {
        settings = client.config.settings,
      })
      vim.notify('Configuration updated for ' .. client.name, vim.lsp.log.levels.INFO)
    end
  end
end

---@param name string Name of the binary.
function M.has_server(name)
  return fn.executable(name) == 1
end

return M
