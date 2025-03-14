local fn = vim.fn
local fs = vim.fs

local M = {}

---@param name string Name of the binary.
function M.has_server(name)
  return fn.executable(name) == 1
end

local PROJECT_CONFIG = '.lsp.json'

---@param bufnr number Buffer number.
---@return table
local function workspace_config(bufnr)
  if not vim.api.nvim_buf_is_valid(bufnr) then
    return {}
  end

  local match = fs.root(bufnr, PROJECT_CONFIG)
  if not match then
    return {}
  end
  local lsp_json_path = fs.joinpath(match, PROJECT_CONFIG)
  local data = vim.trim(fn.readblob(lsp_json_path))
  if data == '' then
    return {}
  end
  return vim.json.decode(data)
end

---@param config vim.lsp.ClientConfig
---@param cb? fun(client: vim.lsp.Client)
function M.start(config, cb)
  local winid = vim.api.nvim_get_current_win()
  local winnr = vim.api.nvim_win_get_number(winid)
  local tabid = vim.api.nvim_get_current_tabpage()
  local tabnr = vim.api.nvim_tabpage_get_number(tabid)
  local bufnr = vim.api.nvim_get_current_buf()
  local bufname = vim.api.nvim_buf_get_name(bufnr)

  local capabilities = vim.lsp.protocol.make_client_capabilities()

  -- Enable dynamic registration of watched files. However might not work great on Linux.
  -- https://github.com/neovim/neovim/pull/28690
  -- https://github.com/neovim/neovim/pull/29374
  capabilities.workspace.didChangeWatchedFiles.dynamicRegistration = true

  ---@type vim.lsp.Config
  local resolved_config = vim.tbl_deep_extend(
    'force',
    { capabilities = capabilities },
    vim.lsp.config['*'] or {},
    vim.lsp.config[config.name] or {},
    config,
    workspace_config(bufnr)
  )

  -- If the buffer is under the current working directory, use it as the root.
  -- Otherwise use the buffer's directory.
  local cwd = fn.getcwd(winnr, tabnr)
  local is_cwd_descendant = vim.startswith(fs.abspath(bufname), cwd)
  local fallback = is_cwd_descendant and cwd or fs.dirname(bufname)

  if not config.root_dir then
    resolved_config.root_dir = resolved_config.root_markers
        and vim.fs.root(bufnr, resolved_config.root_markers)
      or fallback
  end

  -- Prevent rampant file scanning by some servers.
  if config.root_dir == vim.env.HOME then
    resolved_config.root_dir = nil
  end

  -- Lazily start the LSP client to avoid blocking the UI.
  vim.defer_fn(function()
    local client_id = vim.lsp.start(resolved_config, { bufnr = bufnr })
    if client_id then
      local client = vim.lsp.get_client_by_id(client_id)
      if client and cb then
        cb(client)
      end
    end
  end, 1000)
end

return M
