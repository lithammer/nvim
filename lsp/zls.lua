-- https://github.com/zigtools/zls

---@type vim.lsp.Config
return {
  cmd = { 'zls' },
  filetypes = { 'zig' },
  root_markers = { 'build.zig' },
  settings = {
    zig = {
      warn_style = true,
    },
  },
}
