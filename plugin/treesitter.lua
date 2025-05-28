local later = MiniDeps.later

local filetypes = {
  'awk',
  'bash',
  'c',
  'c_sharp',
  'cmake',
  'comment',
  'cpp',
  'css',
  'css',
  'csv',
  'diff',
  'disassembly',
  'dockerfile',
  'editorconfig',
  'embedded_template',
  'elixir',
  'erlang',
  'fish',
  'git_config',
  'git_rebase',
  'gitattributes',
  'gitcommit',
  'gitignore',
  'gleam',
  'go',
  'gomod',
  'gosum',
  'gotmpl',
  'gowork',
  'graphql',
  'haskell',
  'hcl',
  'html',
  'htmldjango',
  'http',
  'hurl',
  'ini',
  'java',
  'javascript',
  'jq',
  'jsdoc',
  'json',
  'json5',
  'jsonc',
  'jsonnet',
  'just',
  'lua',
  'luadoc',
  'make',
  'markdown',
  'markdown_inline',
  'nim',
  'nim_format_string',
  'nix',
  'odin',
  'ocaml',
  'ocaml_interface',
  'ocamllex',
  'passwd',
  'pem',
  'perl',
  'printf',
  'proto',
  'python',
  'query',
  'regex',
  'requirements',
  'rst',
  'ruby',
  'rust',
  'scss',
  'sql',
  'ssh_config',
  'starlark',
  'svelte',
  'swift',
  'terraform',
  'textproto',
  'toml',
  'tsx',
  'typescript',
  'vim',
  'vimdoc',
  'xml',
  'yaml',
  'zig',
}

vim.api.nvim_create_autocmd('FileType', {
  pattern = filetypes,
  callback = function(args)
    -- vim.treesitter.start(args.buf, args.match)
    vim.treesitter.start(args.buf)
    vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
    vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end,
})

later(function()
  require('nvim-treesitter').install(filetypes)
end)

later(function()
  require('nvim-treesitter-textobjects').setup({
    select = {
      lookahead = true,

      selection_modes = {
        ['@parameter.outer'] = 'v',
        ['@function.outer'] = 'V',
        ['@class.outer'] = 'V',
        -- ['@class.outer'] = '<c-v>',
      },
    },
  })

  local select_textobject = require('nvim-treesitter-textobjects.select').select_textobject
  vim.keymap.set({ 'x', 'o' }, 'af', function()
    select_textobject('@function.outer', 'textobjects')
  end)
  vim.keymap.set({ 'x', 'o' }, 'if', function()
    select_textobject('@function.inner', 'textobjects')
  end)
  vim.keymap.set({ 'x', 'o' }, 'ac', function()
    select_textobject('@class.outer', 'textobjects')
  end)
  vim.keymap.set({ 'x', 'o' }, 'ic', function()
    select_textobject('@class.inner', 'textobjects')
  end)
end)
