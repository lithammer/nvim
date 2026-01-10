source $VIMRUNTIME/colors/lunaperche.vim
let g:colors_name = 'lunaperche_plus'

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
