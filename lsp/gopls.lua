-- https://github.com/golang/tools/tree/master/gopls

--- For buffers in the Go module cache (e.g. third-party libraries),
--- attempt to attach to the most recent gopls client.
---
---@param bufnr number
---@return string?
local function modcache_root_dir(bufnr)
  local name = vim.api.nvim_buf_get_name(bufnr)

  -- Check if the current buffer is a third-party module.
  local obj = vim.system({ 'go', 'env', 'GOMODCACHE' }, { text = true }):wait()
  if obj.code == 0 then
    local modcache = vim.trim(obj.stdout or '')
    local is_module = vim.startswith(name, modcache)
    if is_module then
      local clients = vim.lsp.get_clients({ name = 'gopls' })
      if #clients > 0 then
        -- Return the root_dir of the last client.
        return clients[#clients].root_dir
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
    on_dir(modcache_root_dir(bufnr) or vim.fs.root(bufnr, { 'go.work', 'go.mod' }))
  end,
  settings = {
    gopls = {
      -- diagnosticsTrigger = 'Save',
      directoryFilters = {
        '-**/node_modules',
        '-.venv',
        '-bazel-',
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
    },
  },
}
