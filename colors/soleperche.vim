" Name:         Perchè il sole a Milano? Portofino? Dimmi la luna perchè?
" Description:  White(perchè il sole)/Black(la luna perchè?) background colorscheme.
" Author:       Peter Lithammer <peter.lithammer@gmail.com>
" Maintainer:   Peter Lithammer <peter.lithammer@gmail.com>
" Website:      https://www.github.com/lithammer/nvim
" License:      Vim License (see `:help license`)

source $VIMRUNTIME/colors/lunaperche.vim
let g:colors_name = 'soleperche'

let s:t_Co = &t_Co

hi VertSplit guibg=NONE ctermbg=NONE

hi DiagnosticStatusLineError  guifg=#000000 guibg=#ff0000
hi DiagnosticStatusLineWarn   guifg=#000000 guibg=#ffa500
hi DiagnosticStatusLineInfo   guifg=#000000 guibg=#add8e6
hi DiagnosticStatusLineHint   guifg=#000000 guibg=#d3d3d3

" Fix yaml property highlight.
" The default link is @property.yaml -> @property -> Identifier. But
" Identifier is cleared in lunaperche. Map to Statement instead since that's
" what the vanilla syntax engine does.
hi link @property.yaml Statement

" Snacks.
hi link SnacksPicker Normal

" Mini.
hi link MiniPickNormal Normal
