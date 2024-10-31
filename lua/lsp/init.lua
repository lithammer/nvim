local fn = vim.fn
local fs = vim.fs
local uv = vim.uv

local M = {}

---@param name string Name of the binary.
function M.has_server(name)
  return fn.executable(name) == 1
end

local handlers = {
  ['textDocument/signatureHelp'] = vim.lsp.with(
    vim.lsp.handlers.signature_help,
    { border = 'rounded' }
  ),
}

---@param path string Path to the file to read.
---@return string
local function read_file(path)
  local fd = uv.fs_open(path, 'r', 438)
  if not fd then
    vim.notify(('Could not open file %s for reading'):format(path), vim.log.levels.ERROR)
    return ''
  end
  local stat = assert(uv.fs_fstat(fd))
  local data = uv.fs_read(fd, stat.size, 0)
  uv.fs_close(fd)
  return data or ''
end

---@return table
local function local_config()
  local match = fs.find('.lsp.json', {
    upward = true,
    type = 'file',
    path = fs.dirname(vim.api.nvim_buf_get_name(0)),
  })
  if not match[1] then
    return {}
  end
  local data = read_file(match[1])
  if data == '' then
    data = '{}'
  end
  return vim.json.decode(data)
end

---@param bufnr number Buffer handle to attach to if starting or re-using a client.
---@param config vim.lsp.ClientConfig
---@return integer? client_id
local function start(bufnr, config)
  local capabilities = vim.lsp.protocol.make_client_capabilities()

  -- Enable dynamic registration of watched files. However might not work great on Linux.
  -- https://github.com/neovim/neovim/pull/28690
  -- https://github.com/neovim/neovim/pull/29374
  capabilities.workspace.didChangeWatchedFiles.dynamicRegistration = true

  local merged_config = vim.tbl_deep_extend(
    'force',
    { capabilities = capabilities, handlers = handlers },
    config,
    local_config()
  )

  return vim.lsp.start(merged_config, { bufnr = bufnr })
end

---@class ClientConfig: vim.lsp.ClientConfig

---@param config ClientConfig|vim.lsp.ClientConfig
---@param cb? fun(client: vim.lsp.Client)
function M.start(config, cb)
  local ws = require('lsp.ws')

  local winnr = vim.api.nvim_get_current_win()
  local tabnr = vim.api.nvim_get_current_tabpage()
  local bufnr = vim.api.nvim_get_current_buf()

  local workspace_folders = vim
    .iter(config.workspace_folders or ws.git(bufnr) or ws.cwd(winnr, tabnr) or ws.bufdir(bufnr))
    :filter(function(v)
      return v.name ~= vim.env.HOME
    end)
    :totable()

  if vim.tbl_isempty(workspace_folders) then
    vim.notify('Unable to find a workspace root', vim.log.levels.WARN)
    config.workspace_folders = nil
  else
    config.workspace_folders = workspace_folders
    if config.root_dir == nil then
      config.root_dir = workspace_folders[1].name
    end
  end

  -- Lazily start the LSP client to avoid blocking the UI.
  vim.defer_fn(function()
    local client_id = start(bufnr, config)
    if client_id then
      local client = vim.lsp.get_client_by_id(client_id)
      if client and cb then
        cb(client)
      end
    end
  end, 1000)
end

return M
