local lsp = require('lsp')
local ws = require('lsp.ws')

local fs = vim.fs

--- Resolve workspace root folder for Rust projects.
---
---@param manifest_path string Path to a Cargo.toml file in the workspace.
local function cargo_locate_project(manifest_path)
  local obj = vim
    .system({
      'cargo',
      'locate-project',
      '--workspace',
      '--message-format',
      'plain',
      '--frozen',
      '--manifest-path',
      manifest_path,
    }, { text = true })
    :wait()
  if obj.code ~= 0 then
    vim.notify(
      'Unexpected exit code from `cargo locate-project`: ' .. obj.stderr,
      vim.log.levels.WARN
    )
    return fs.dirname(manifest_path)
  end
  return fs.dirname(obj.stdout)
end

---@return lsp.WorkspaceFolder[]?
local function resolve_workspace_folders()
  local workspace_folders = ws.find('Cargo.toml')
  if not workspace_folders then
    return nil
  end

  local manifest_path = fs.joinpath(workspace_folders[1].name, 'Cargo.toml')
  local project_root = cargo_locate_project(manifest_path)
  return { ws.fname_to_workspace_folder(project_root) }
end

local settings = {
  ['rust-analyzer'] = {
    check = {
      command = 'clippy',
    },
    cargo = {
      features = 'all',
    },
    completion = {
      postfix = { enable = false },
    },
  },
}

lsp.start({
  name = 'rust-analyzer',
  cmd = { 'rust-analyzer' },
  workspace_folders = resolve_workspace_folders(),
  settings = settings,
  init_options = settings['rust-analyzer'],
})
