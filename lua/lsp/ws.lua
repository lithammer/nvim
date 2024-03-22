local fn = vim.fn
local fs = vim.fs

local M = {}

---@param path string
---@return string
local function abspath(path)
  return fn.fnamemodify(path, ':p')
  -- return vim.loop.fs_realpath(path)
end

---@return string
local function getcwd()
  local winnr = vim.api.nvim_get_current_win()
  local tabnr = vim.api.nvim_get_current_tabpage()
  return fn.getcwd(winnr, tabnr)
end

---@param path string
---@return string?
local function git_root(path)
  local matches = fs.find('.git', {
    upward = true,
    path = path,
    type = 'directory',
  })

  if vim.tbl_isempty(matches) then
    return nil
  end

  return vim.iter(matches):map(abspath):map(fs.dirname):next()
end

--- Get WorkspaceFolder from a path.
---
---@param path string Path to file.
---@return lsp.WorkspaceFolder
local function fname_to_workspace_folder(path)
  return {
    name = path,
    uri = vim.uri_from_fname(path),
  }
end

--- Remove duplicates in an iterator. Used with Iter:filter().
local function unique()
  local seen = {}
  return function(value)
    if not seen[value] then
      seen[value] = true
      return true
    end
    return false
  end
end

--- Finds any file or directory searching upwards. If multiple matches are found,
--- the one closest to the root of the tree will be returned.
---
---@param names string | string[] | fun(name: string, path: string): boolean The name of the files or directories to search for.
---@return lsp.WorkspaceFolder[]?
function M.find(names)
  local bufnr = vim.api.nvim_get_current_buf()

  -- local cwd = getcwd()
  local matches = fs.find(names, {
    upward = true,
    -- stop = vim.loop.os_homedir(),
    -- stop = fs.dirname(git_root(cwd) or cwd),
    path = fs.dirname(vim.api.nvim_buf_get_name(bufnr)),
    limit = math.huge,
  })

  if vim.tbl_isempty(matches) then
    return nil
  end

  -- return { vim.iter(matches):map(fs.dirname):map(wsf_from_fname):last() }
  return vim
    .iter(matches)
    :map(abspath)
    :map(vim.trim)
    :map(fs.dirname)
    :filter(unique())
    :map(fname_to_workspace_folder)
    :rev()
    :totable()
end

--- Finds Git repository root relative to the current buffer.
---
---@return lsp.WorkspaceFolder[]?
function M.git()
  local bufnr = vim.api.nvim_get_current_buf()

  local path = git_root(vim.api.nvim_buf_get_name(bufnr))
  if not path then
    return nil
  end

  return { fname_to_workspace_folder(path) }
end

---@return lsp.WorkspaceFolder[]
function M.cwd()
  return { fname_to_workspace_folder(getcwd()) }
end

return M
