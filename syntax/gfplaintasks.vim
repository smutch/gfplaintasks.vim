" Vim syntax file
" Language: PlainTasks
" Maintainer: Simon Mutch
" Original: David Elentok
" Filenames: *.todo.md

if exists("b:current_syntax")
  finish
endif

runtime! syntax/markdown.vim syntax/markdown/*.vim

hi def link ptTask Identifier
hi def link ptCompleteTask Comment
hi def link ptCancelled Conditional
" hi def link ptSection Statement
hi def link ptContext Question
" hi def link ptLine Function

" syn match ptSection "^#.* *$"
syn match ptTask "^ *- \[ \].*" contains=ptContext
syn match ptCompleteTask "^ *- \[x\].*" contains=ptContext
syn match ptContext "@[^ ]*"
syn match ptCancelled "^ *- X.*"
" syn match ptLine "^----*"
