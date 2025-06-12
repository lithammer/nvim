--- For buffers in the Go module cache (e.g. third-party libraries),
--- attempt to attach to the most recent gopls client.
---
---@return string?
local function modcache_root_dir()
  local name = vim.api.nvim_buf_get_name(0)

  -- Check if the current buffer is a third-party module.
  local obj = vim.system({ 'go', 'env', 'GOMODCACHE' }, { text = true }):wait()
  if obj.code == 0 then
    local modcache = vim.trim(obj.stdout or '')
    local is_module = vim.startswith(name, modcache)
    if is_module then
      -- Attach to the most recent gopls client.
      local client = vim.iter(vim.lsp.get_clients({ name = 'gopls' })):last() --[[@as vim.lsp.Client?]]
      if client then
        return client.root_dir
      end
    end
  else
    vim.notify('`go env GOMODCACHE` command failed: ' .. (obj.stderr or ''), vim.log.levels.ERROR)
  end

  return nil
end

---@type vim.lsp.Config
return {
  cmd = { 'gopls', 'serve' },
  filetypes = { 'go', 'gomod', 'gotmpl', 'gowork' },
  root_dir = function(bufnr, on_dir)
    on_dir(modcache_root_dir() or vim.fs.root(bufnr, { 'go.work', 'go.mod' }))
  end,
  settings = {
    gopls = {
      analyses = {
        useany = true,
      },
      completeUnimported = true,
      completionDocumentation = true,
      diagnosticsTrigger = 'Save',
      directoryFilters = {
        '-**/node_modules',
        '-bazel-bin',
        '-bazel-out',
        '-bazel-src',
        '-bazel-testlogs',
      },
      gofumpt = true,
      hints = {
        assignVariableTypes = true,
        compositeLiteralFields = true,
        constantValues = true,
        functionTypeParameters = true,
        parameterNames = true,
        rangeVariableTypes = true,
      },
      semanticTokens = true,
      staticcheck = true,
      usePlaceholders = true,
    },
  },
}
