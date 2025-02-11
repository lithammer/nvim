" :h last-position-jump
augroup RestoreCursor
  autocmd!
  autocmd BufReadPre * autocmd FileType <buffer> ++once
    \ let s:line = line("'\"")
    \ | if s:line >= 1 && s:line <= line("$") && &filetype !~# 'commit'
    \      && index(['xxd', 'gitrebase'], &filetype) == -1
    \ |   execute "normal! g`\""
    \ | endif
augroup END

" :h vim.hl
augroup HighlightYank
  autocmd!
  autocmd TextYankPost * silent! lua vim.hl.on_yank()
augroup END

" Ensure relative paths in :buffers.
augroup BufferRelativePaths
  autocmd!
  autocmd BufReadPost * call chdir(getcwd())
augroup END

command W w
