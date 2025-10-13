" Name:         Jellybeans
" Description:  A colorful, dark color scheme, inspired by ir_black and twilight.
" Author:       nanotech
" Maintainer:   Peter Lithammer <peter.lithammer@gmail.com>
" Website:      https://github.com/lithammer/jellybeans.nvim
" License:      Vim License (see `:help license`)
" Last Change:  2025 Sep 28

hi clear
let g:colors_name = 'jellybeans'

set background=dark

" Terminal colors
let g:terminal_color_0 = '#3b3b3b'
let g:terminal_color_1 = '#cf6a4c'
let g:terminal_color_2 = '#99ad6a'
let g:terminal_color_3 = '#d8ad4c'
let g:terminal_color_4 = '#597bc5'
let g:terminal_color_5 = '#a037b0'
let g:terminal_color_6 = '#71b9f8'
let g:terminal_color_7 = '#adadad'
let g:terminal_color_8 = '#3b3b3b'
let g:terminal_color_9 = '#cf6a4c'
let g:terminal_color_10 = '#99ad6a'
let g:terminal_color_11 = '#d8ad4c'
let g:terminal_color_12 = '#597bc5'
let g:terminal_color_13 = '#a037b0'
let g:terminal_color_14 = '#71b9f8'
let g:terminal_color_15 = '#adadad'

" Highlight groups
hi ColorColumn     guibg=#000000
hi Comment         guifg=#888888 gui=italic cterm=italic
hi Constant        guifg=#cf6a4c
hi Cursor          guifg=#151515 guibg=#b0d0f0
hi CursorColumn    guibg=#1c1c1c
hi CursorLine      guibg=#1c1c1c
hi CursorLineNr    guifg=#ccc5c4
hi Delimiter       guifg=#668799
hi DiffAdd         guifg=#d2ebbe guibg=#437019
hi DiffChange      guibg=#2b5b77
hi DiffDelete      guifg=#40000a guibg=#700009
hi DiffText        guifg=#8fbfdc guibg=#000000 gui=reverse cterm=reverse
hi Directory       guifg=#dad085
hi ErrorMsg        guibg=#902020
hi Folded          guifg=#a0a8b0 guibg=#384048 gui=italic cterm=italic
hi Function        guifg=#fad07a guibg=#1f1f1f
hi FoldColumn      guifg=#535D66 guibg=#1f1f1f
hi Identifier      guifg=#c6b6ee
hi LineNr          guifg=#605958 guibg=#151515
hi MatchParen      guifg=#ffffff guibg=#556779 gui=bold cterm=bold
hi NonText         guifg=#606060
hi Normal          guifg=#e8e8d3 guibg=#151515
hi Pmenu           guifg=#ffffff guibg=#606060
hi PmenuSel        guifg=#101010 guibg=#eeeeee
hi PreProc         guifg=#8fbfdc
hi Question        guifg=#65C254
hi Search          guifg=#f0a0c0 guibg=#302028 gui=underline cterm=underline
hi SignColumn      guifg=#777777 guibg=#333333
hi Special         guifg=#799d6a
hi SpecialKey      guifg=#444444 guibg=#1c1c1c
hi Statement       guifg=#8197bf
hi StatusLine      guifg=#000000 guibg=#dddddd gui=italic cterm=italic
hi StatusLineNC    guifg=#ffffff guibg=#403c41 gui=italic cterm=italic
hi StorageClass    guifg=#c59f6f
hi String          guifg=#99ad6a
hi StringDelimiter guifg=#556633
hi Structure       guifg=#8fbfdc
hi TabLine         guifg=#000000 guibg=#b0b8c0 gui=italic cterm=italic
hi TabLineFill     guifg=#9098a0
hi TabLineSel      guifg=#000000 guibg=#f0f0f0 gui=bold,italic cterm=bold,italic
hi Title           guifg=#70b950 gui=bold cterm=bold
hi Todo            guifg=#c7c7c7 gui=bold cterm=bold
hi Type            guifg=#ffb964
hi VertSplit       guifg=#777777 guibg=#403c41
hi Visual          guibg=#404040
hi WildMenu        guifg=#f0a0c0 guibg=#302028

" Diagnostic groups
hi DiagnosticError            guifg=#ff5e56
hi DiagnosticWarn             guifg=#fa9153
hi DiagnosticInfo             guifg=#efc541
hi DiagnosticHint             guifg=#4f9cfe
hi DiagnosticSignError        guifg=#ff5e56 guibg=#151515
hi DiagnosticSignWarn         guifg=#fa9153 guibg=#151515
hi DiagnosticSignInfo         guifg=#efc541 guibg=#151515
hi DiagnosticSignHint         guifg=#4f9cfe guibg=#151515
hi DiagnosticVirtualTextError guifg=#ff5e56 guibg=#462624
hi DiagnosticVirtualTextWarn  guifg=#fa9153 guibg=#453024
hi DiagnosticVirtualTextInfo  guifg=#efc541 guibg=#433a20
hi DiagnosticVirtualTextHint  guifg=#4f9cfe guibg=#233246

hi link Conceal Operator
hi link DiffTextAdd DiffText
hi link Error ErrorMsg
hi link MoreMsg Special
hi link Operator Structure
hi link TagListFileName Directory
hi link diffAdded String
hi link diffRemoved Constant

" Treesitter
hi link @constant.builtin Constant
hi link @keyword.modifier StorageClass
hi link @keyword.import Include
hi link @punctuation.special Delimiter
hi link @type.builtin Type
hi link @module NONE
hi link @variable NONE

" LSP semantic tokens
hi link @lsp.type.namespace.go Type

" Blink.cmp
hi BlinkCmpMenu guifg=#e8e8d3 guibg=#151515
hi link BlinkCmpMenuBorder BlinkCmpMenu
hi link BlinkCmpDoc BlinkCmpMenu
hi link BlinkCmpDocBorder BlinkCmpMenuBorder
hi BlinkCmpMenuSelection guifg=#101010 guibg=#eeeeee
hi BlinkCmpKind guifg=#606060
