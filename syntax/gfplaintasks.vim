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
hi def link ptCancelledTask Conditional
" hi def link ptSection Statement
hi def link ptContext Question
" hi def link ptLine Function

" syn match ptSection "^#.* *$"
syn match ptTask "^ *- \[ \].*" contains=ptContext,ptCheckbox
syn match ptCompleteTask "^ *- \[x\].*" contains=ptContext,ptCompleteMark
syn match ptContext "@[^ ]*" "containedin=ALL contained
syn match ptCancelledTask "^ *- X.*" contains=ptContext,ptCancelMark
syn match ptCancelMark "- X" contained containedin=ptCancelledTask conceal cchar=✗
syn match ptLine "^----*"
syn match ptItem "^ *[\*-]\( X\| \[[x ]\]\)\@!" contains=ptBullet,ptContext
syn match ptCompleteMark "- \[x\]" contained containedin=ptCompleteTask conceal cchar=✔
syn match ptBullet "[\*-]" contained containedin=ptItem conceal cchar=•
syn match ptCheckbox "- \[ \]" contained containedin=ptTask conceal cchar=◻

let b:current_syntax = "gfplaintasks"
