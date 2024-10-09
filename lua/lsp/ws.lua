local fn = vim.fn
local fs = vim.fs

local M = {}

---@param path string
---@return string
local function abspath(path)
  return vim.uv.fs_realpath(path)
end

---@return string
local function getcwd()
  local winnr = vim.api.nvim_get_current_win()
  local tabnr = vim.api.nvim_get_current_tabpage()
  return fn.getcwd(winnr, tabnr)
end

--- Get WorkspaceFolder from a path.
---
---@param path string Path to file.
---@return lsp.WorkspaceFolder
function M.fname_to_workspace_folder(path)
  return {
    name = path,
    uri = vim.uri_from_fname(path),
  }
end

--- Finds any file or directory searching upwards.
---
---@param names string | string[] | fun(name: string, path: string): boolean The name of the files or directories to search for.
---@return lsp.WorkspaceFolder[]?
function M.find(names)
  local match = fs.root(0, names)
  if not match then
    return nil
  end

  return { M.fname_to_workspace_folder(abspath(match)) }
end

--- Finds Git repository root relative to the current buffer.
---
---@return lsp.WorkspaceFolder[]?
function M.git()
  local match = fs.root(0, '.git')
  if not match then
    return nil
  end

  return { M.fname_to_workspace_folder(abspath(match)) }
end

---@return lsp.WorkspaceFolder[]
function M.cwd()
  return { M.fname_to_workspace_folder(getcwd()) }
end

---@return lsp.WorkspaceFolder[]
function M.bufdir()
  return { M.fname_to_workspace_folder(fs.dirname(vim.api.nvim_buf_get_name(0))) }
end

return M
