local langs = {
  'awk',
  'bash',
  'c',
  'c_sharp',
  'caddy',
  'cmake',
  'comment',
  'cpp',
  'css',
  'csv',
  'diff',
  'disassembly',
  'dockerfile',
  'editorconfig',
  'elixir',
  'embedded_template',
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
  'html_tags',
  'htmldjango',
  'http',
  'hurl',
  'ini',
  'java',
  'javascript',
  'jinja',
  'jinja_inline',
  'jq',
  'jsdoc',
  'json',
  'json5',
  'jsonnet',
  'jsx',
  'just',
  'kitty',
  'lua',
  'luadoc',
  'make',
  'markdown',
  'markdown_inline',
  'nim',
  'nim_format_string',
  'nix',
  'ocaml',
  'ocaml_interface',
  'ocamllex',
  'odin',
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
  'strace',
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
  'zsh',
}

require('nvim-treesitter').install(langs)

-- XXX: Because of issues with lazy installation, this is disabled.
-- A bunch of parsers are mostly used for injections like diff and they won't
-- be installed.
--
-- for _, lang in ipairs(langs) do
--   langs[lang] = true
-- end
--
-- do
--   local group = vim.api.nvim_create_augroup('treesitter_install', { clear = true })
--   vim.api.nvim_create_autocmd('FileType', {
--     group = group,
--     callback = function(args)
--       local treesitter = require('nvim-treesitter')
--       local lang = vim.treesitter.language.get_lang(args.match)
--       if langs[lang] and not vim.list_contains(treesitter.get_installed(), lang) then
--         treesitter.install(lang)
--       end
--     end,
--   })
-- end

do
  local group = vim.api.nvim_create_augroup('treesitter_start', { clear = true })
  vim.api.nvim_create_autocmd('FileType', {
    group = group,
    callback = function(args)
      local treesitter = require('nvim-treesitter')
      local lang = assert(vim.treesitter.language.get_lang(args.match))

      if vim.list_contains(treesitter.get_installed(), lang) then
        vim.treesitter.start(args.buf, lang)

        if vim.treesitter.query.get(lang, 'folds') then
          vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
          vim.wo.foldmethod = 'expr'
        end

        if vim.treesitter.query.get(lang, 'indents') then
          vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end
      end
    end,
  })
end

do
  local group = vim.api.nvim_create_augroup('treesitter_update', { clear = true })
  vim.api.nvim_create_autocmd('PackChanged', {
    desc = 'Update treesitter parsers',
    group = group,
    callback = function(event)
      local name, kind = event.data.spec.name, event.data.kind
      if name == 'nvim-treesitter' and kind == 'update' then
        vim.schedule(function()
          require('nvim-treesitter').update(nil, { summary = true })
        end)
      end
    end,
  })
end

do
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
end
