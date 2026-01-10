source $VIMRUNTIME/colors/habamax.vim
let g:colors_name = 'habamax_plus'

let s:t_Co = &t_Co

hi link FloatBorder PmenuBorder

" Treesitter.
hi link @function NONE
hi link @keyword.function Identifier " Blue instead of purple.
hi link @property NONE
hi link @variable NONE
hi link @variable.member NONE
hi link @punctuation.delimiter NonText

" Treesitter (Go).
hi link @keyword.function.go Keyword
hi link @keyword.type.go Keyword

" Treesitter (JSON).
hi link @conceal.json NonText
hi link @property.json Statement

" Treesitter (Lua).
hi link @punctuation.bracket.lua NONE

" Treesitter (Protobuf).
hi link @keyword.type.proto Keyword

" Treesitter (Python).
hi link @keyword.type.python Keyword
hi link @keyword.function.python Keyword
hi link @lsp.type.namespace.python NONE
hi link @module.python NONE

" Treesitter (YAML).
hi link @property.yaml Statement
hi link @string.yaml NONE

" LSP.
hi link @lsp.type.function NONE
hi link @lsp.type.method NONE
hi link @lsp.type.parameter NONE
hi link @lsp.type.property NONE
hi link @lsp.type.variable NONE
