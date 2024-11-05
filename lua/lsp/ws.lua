local finders = require('lsp.finders')

local fn = vim.fn
local fs = vim.fs

local M = {}

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

--- Finds any file or directory searching upward.
---
---@param names string | string[] | fun(name: string, path: string): boolean The name of the files or directories to search for.
---@return lsp.WorkspaceFolder[]?
function M.find(names)
  local match = fs.root(0, names)
  if not match then
    return nil
  end

  return { M.fname_to_workspace_folder(match) }
end

--- Finds Git repository root relative to the current buffer.
---
---@param bufnr number?
---@return lsp.WorkspaceFolder[]?
function M.git(bufnr)
  local match = fs.root(bufnr or 0, '.git')
  if not match then
    return nil
  end

  return { M.fname_to_workspace_folder(match) }
end

---@param winnr number?
---@param tabnr number?
---@return lsp.WorkspaceFolder[]
function M.cwd(winnr, tabnr)
  return { M.fname_to_workspace_folder(fn.getcwd(winnr or 0, tabnr or 0)) }
end

---@param bufnr number
---@return lsp.WorkspaceFolder[]
function M.bufdir(bufnr)
  return { M.fname_to_workspace_folder(finders.bufdir(bufnr)) }
end

return M
