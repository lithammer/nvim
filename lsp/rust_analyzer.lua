local fs = vim.fs

--- Resolve the path to a Rust library.
---
---@param bufnr number
---@return string?
local function library_root_dir(bufnr)
  local name = vim.api.nvim_buf_get_name(bufnr)

  local cargo_home = vim.env.CARGO_HOME or fs.normalize('~/.cargo')
  local registry = fs.joinpath(cargo_home, 'registry', 'src')
  local git_registry = fs.joinpath(cargo_home, 'git', 'checkouts')

  local rustup_home = vim.env.RUSTUP_HOME or fs.normalize('~/.rustup')
  local toolchains = fs.joinpath(rustup_home, 'toolchains')

  local is_library = vim.iter({ toolchains, registry, git_registry }):find(function(value)
    return vim.startswith(name, value)
  end) ~= nil

  if is_library then
    local client = vim.iter(vim.lsp.get_clients({ name = 'rust-analyzer' })):last() --[[@as vim.lsp.Client?]]
    if client then
      return client.root_dir
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

---@param bufnr number
---@return string?
local function project_root_dir(bufnr)
  local match = vim.fs.root(bufnr, 'Cargo.toml')
  if not match then
    return nil
  end

  local manifest_path = fs.joinpath(match, 'Cargo.toml')
  local project_root = cargo_locate_project(manifest_path)
  return project_root
end

---@type vim.lsp.Config
return {
  cmd = { 'rust-analyzer' },
  filetypes = { 'rust' },
  root_dir = function(bufnr, on_dir)
    on_dir(library_root_dir(bufnr) or project_root_dir(bufnr))
  end,
  settings = {
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
  },
  before_init = function(params, config)
    -- https://rust-analyzer.github.io/book/contributing/lsp-extensions.html#configuration-in-initializationoptions
    if config.settings and config.settings['rust-analyzer'] then
      params.initializationOptions = config.settings['rust-analyzer']
    end
  end,
}
