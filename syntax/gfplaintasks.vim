" Vim syntax file
" Language: PlainTasks
" Maintainer: Simon Mutch
" Original: David Elentok
" Filenames: *.todo.md

if "b:current_syntax" == "gfplaintasks"
  finish
endif

runtime! syntax/mkd.vim syntax/mkd/*.vim

setlocal concealcursor=nc

hi def link ptTask Identifier
hi def link ptCompleteTask Comment
hi def link ptCancelledTask Conditional
" hi def link ptSection Statement
hi def link ptContext Question
" hi def link ptLine Function

" syn region htmlItalic matchgroup=htmlStyleDelim start="\\\@<!\*\S\@=" end="\S\@<=\\\@<!\*" keepend oneline concealends
" syn region htmlItalic matchgroup=htmlStyleDelim start="\(^\|\s\)\@<=_\|\\\@<!_\([^_]\+\s\)\@=" end="\S\@<=_\|_\S\@=" keepend oneline concealends
syn region htmlBold matchgroup=htmlStyleDelim start="\S\@<=\*\*\|\*\*\S\@=" end="\S\@<=\*\*\|\*\*\S\@=" keepend oneline concealends
syn region htmlBold matchgroup=htmlStyleDelim start="\S\@<=__\|__\S\@=" end="\S\@<=__\|__\S\@=" keepend oneline concealends
" syn region htmlBoldItalic matchgroup=htmlStyleDelim start="\S\@<=\*\*\*\|\*\*\*\S\@=" end="\S\@<=\*\*\*\|\*\*\*\S\@=" keepend oneline concealends
" syn region htmlBoldItalic matchgroup=htmlStyleDelim start="\S\@<=___\|___\S\@=" end="\S\@<=___\|___\S\@=" keepend oneline concealends

syn cluster mkdNonListItem remove=htmlItalic,htmlBold,htmlBoldItalic,mkdFootnotes,mkdInlineURL,mkdLink,mkdLinkDef

" let s:concealends = has('conceal') ? ' concealends' : ''
" syn region htmlBold matchgroup=htmlBoldDelim concealends=''

" syn match ptSection "^#.* *$"
syn match ptLine "^----*"

syn match ptTask "^ *- \[ \].*$" contains=ptCheckbox
syn match ptCheckbox "- \[ \]" contained containedin=ptTask conceal cchar=◻

syn match ptCompleteTask "^ *- \[x\].*$" contains=ptCompleteMark
syn match ptCompleteMark "- \[x\]" contained containedin=ptCompleteTask conceal cchar=✔

syn match ptCancelledTask "^ *- X.*$" contains=ptCancelMark
syn match ptCancelMark "- X" contained containedin=ptCancelledTask conceal cchar=✗

syn match ptContext "@[^ ]*" containedin=ALL

syn match ptItem "^ *[\*-]\( X\| \[[x ]\]\)\@! " contains=ptBullet
syn match ptBullet "[\*-]" contained containedin=ptItem conceal cchar=•

let b:current_syntax = "gfplaintasks"
