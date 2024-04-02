local fn = vim.fn
local fs = vim.fs

local M = {}

---@class Autocmd: vim.api.keyset.create_autocmd
---@field [1] string | string[] Event(s) that will trigger the handler.

---@param augroup string The name of the augroup.
---@param bufnr number The buffer number.
---@param autocmds Autocmd[] The autocmd(s) to create.
local function buf_create_autocmd(augroup, bufnr, autocmds)
  local ok, cmds = pcall(vim.api.nvim_get_autocmds, { group = augroup, buffer = bufnr })

  if not ok or vim.tbl_isempty(cmds) then
    vim.api.nvim_create_augroup(augroup, { clear = false })

    for _, autocmd in ipairs(autocmds) do
      local events = autocmd[1]

      autocmd[1] = nil
      autocmd.group = augroup
      autocmd.buffer = bufnr

      vim.api.nvim_create_autocmd(events, autocmd)
    end
  end
end

---@param bufnr number The buffer number.
function M.setup_document_highlight(bufnr)
  -- TODO: Don't implicitly set options...?
  vim.opt.updatetime = 300

  buf_create_autocmd('lsp_document_highlight', bufnr, {
    {
      { 'CursorHold', 'CursorHoldI' },
      callback = vim.lsp.buf.document_highlight,
    },
    {
      { 'CursorMoved', 'CursorMovedI', 'BufLeave' },
      callback = vim.lsp.buf.clear_references,
    },
  })
end

function M.reuse_client(client, config)
  local client_workspace_folders = client.workspace_folders or {}
  local config_workspace_folders = config.workspace_folders or {}

  if client.name == config.name then
    for _, a in ipairs(client_workspace_folders) do
      for _, b in ipairs(config_workspace_folders) do
        if a.name == b.name and a.uri == b.uri then
          return true
        end
      end
    end
  end

  return false
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
  local fd = io.open(path, 'r')
  if not fd then
    vim.notify(('Could not open file %s for reading'):format(path), vim.log.levels.ERROR)
    return ''
  end
  local data = fd:read('*a')
  fd:close()
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
  return fn.json_decode(data)
end

---@param config vim.lsp.ClientConfig
local function start(config)
  local capabilities = vim.lsp.protocol.make_client_capabilities()

  if not capabilities then
    vim.notify('Failed to create client capabilities', vim.log.levels.ERROR)
    return
  end

  local merged_config = vim.tbl_deep_extend(
    'force',
    { capabilities = capabilities, handlers = handlers },
    config,
    local_config()
  )

  if not merged_config then
    vim.notify('Failed to merge client config', vim.log.levels.ERROR)
    return
  end

  local opts = {
    reuse_client = M.reuse_client,
    bufnr = 0,
  }

  local client_id = vim.lsp.start(merged_config, opts)
  if not client_id then
    return nil
  end

  local client = vim.lsp.get_client_by_id(client_id)
  if not client then
    return nil
  end

  local workspace_folders = vim
    .iter(client.workspace_folders or {})
    :map(function(ws)
      return ws.uri
    end)
    :totable()

  for _, ws in ipairs(merged_config.workspace_folders or {}) do
    if not vim.tbl_contains(workspace_folders, ws.uri) then
      vim.lsp.buf.add_workspace_folder(ws.name)
    end
  end

  return client_id
end

---@class ClientConfig: vim.lsp.ClientConfig
---@field workspace_folders? lsp.WorkspaceFolder[]

---@param config ClientConfig
function M.start(config)
  if not vim.tbl_isempty(config.workspace_folders or {}) then
    -- Lazily start the LSP client to avoid blocking the UI.
    vim.defer_fn(function()
      start(config)
    end, 1000)
  end
end

return M
