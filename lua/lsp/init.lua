local fn = vim.fn
local fs = vim.fs
local uv = vim.uv

local M = {}

---@param name string Name of the binary.
function M.has_server(name)
  return fn.executable(name) == 1
end

local handlers = {
  ['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, { border = 'rounded' }),
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
  return data
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
---@field workspace_folders? lsp.WorkspaceFolder[]

---@param config ClientConfig|vim.lsp.ClientConfig
function M.start(config)
  if not vim.tbl_isempty(config.workspace_folders or {}) then
    config.root_dir = config.workspace_folders[1].name
    local bufnr = vim.api.nvim_get_current_buf()
    -- Lazily start the LSP client to avoid blocking the UI.
    vim.defer_fn(function()
      start(bufnr, config)
    end, 1000)
  end
end

return M
