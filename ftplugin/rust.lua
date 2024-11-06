local lsp = require('lsp')
local ws = require('lsp.ws')

local fs = vim.fs

--- Resolve the path to a Rust library.
---
---@return lsp.WorkspaceFolder[]?
local function library_workspace()
  local name = vim.api.nvim_buf_get_name(0)

  local cargo_home = vim.env.CARGO_HOME or fs.normalize('~/.cargo')
  local registry = fs.joinpath(cargo_home, 'registry', 'src')
  local git_registry = fs.joinpath(cargo_home, 'git', 'checkouts')

  local rustup_home = vim.env.RUSTUP_HOME or fs.normalize('~/.rustup')
  local toolchains = fs.joinpath(rustup_home, 'toolchains')

  local is_library = vim.iter({ toolchains, registry, git_registry }):find(function(value)
    return name:sub(1, #value) == value
  end) ~= nil

  if is_library then
    local client = vim.iter(vim.lsp.get_clients({ name = 'rust-analyzer' })):last() --[[@as vim.lsp.Client?]]
    if client then
      return client.workspace_folders
    end
  end

  return nil
end

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
  if obj.code > 0 then
    vim.notify(
      'Unexpected exit code from `cargo locate-project`: ' .. (obj.stderr or ''),
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
  name = 'rust_analyzer',
  cmd = { 'rust-analyzer' },
  workspace_folders = library_workspace() or resolve_workspace_folders(),
  settings = settings,
  init_options = settings['rust-analyzer'],
})
