" Vim syntax file
" Language: PlainTasks
" Maintainer: Simon Mutch
" Original: David Elentok
" Filenames: *.todo.md

if "b:current_syntax" == "gfplaintasks"
  finish
endif

runtime! syntax/mkd.vim syntax/mkd/*.vim

hi def link ptTask Identifier
hi def link ptCompleteTask Comment
hi def link ptCancelled Conditional
" hi def link ptSection Statement
hi def link ptContext Question
" hi def link ptLine Function

" syn match ptSection "^#.* *$"
syn match ptTask "^ *- \[ \].*" contains=ptContext,ptItem
syn match ptCompleteTask "^ *- \[x\].*" contains=ptContext,ptCompleteMark,ptItem
syn match ptContext "@[^ ]*" "containedin=ALL contained
syn match ptCancelled "^ *[-*] X.*" contains=ptItem
" syn match ptLine "^----*"
syn match ptItem "^ *[-*]" contains=ptBullet,ptCompleteMark
syn match ptCompleteMark "\[x\]" contained conceal cchar=✔
syn match ptBullet "[-*]" contained conceal cchar=•

let b:current_syntax = "gfplaintasks"
