local lsp = require('lsp')
local ws = require('lsp.ws')

local function workspace_folders()
  local name = vim.api.nvim_buf_get_name(0)

  -- Check if the current buffer is a third-party module.
  local obj = vim.system({ 'go', 'env', 'GOMODCACHE' }, { text = true }):wait()
  if obj.code == 0 then
    local modcache = vim.trim(obj.stdout or '')
    local is_module = name:sub(1, #modcache) == modcache
    if is_module then
      return ws.fname_to_workspace_folder(modcache)
    end
  else
    vim.notify('`go env GOMODCACHE` command failed: ' .. (obj.stderr or ''), vim.log.levels.ERROR)
  end

  return ws.find('go.work') or ws.find('go.mod')
end

lsp.start({
  name = 'gopls',
  cmd = { 'gopls', 'serve' },
  workspace_folders = workspace_folders(),
  settings = {
    gopls = {
      analyses = {
        nilness = true,
        unusedparams = true,
        unusedwrite = true,
        useany = true,
      },
      hoverKind = 'FullDocumentation',
      linksInHover = false,
      gofumpt = true,
      completeUnimported = true,
      -- https=//github.com/yegappan/lsp/issues/126
      semanticTokens = true,
      staticcheck = true,
      usePlaceholders = true,
      completionDocumentation = true,
      codelenses = {
        generate = true,
        test = true,
        run_vulncheck_exp = true,
      },
      hints = {
        assignVariableTypes = true,
        compositeLiteralFields = true,
        compositeLiteralTypes = true,
        constantValues = true,
        functionTypeParameters = true,
        parameterNames = true,
        rangeVariableTypes = true,
      },
    },
  },
})
