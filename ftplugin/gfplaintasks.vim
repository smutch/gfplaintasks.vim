"Vim filetype plugin
" Language: GFPlainTasks
" Maintainer: Simon Mutch
" Original: David Elentok
" ArchiveTasks() added by Nik van der Ploeg

" Only do this when not done yet for this buffer
if exists("b:did_ftplugin")
  finish
endif

nnoremap <buffer> + :call ToggleTask()<cr>
nnoremap <buffer> <CR> :call ToggleComplete()<cr>
nnoremap <buffer> <LocalLeader><CR> :call ToggleCancel()<cr>
nnoremap <buffer> _ :call ArchiveTasks()<cr>
abbr --- <c-r>=Separator()<cr>

" when pressing enter within a task it creates another task
setlocal comments-=fb:-
setlocal comments+=nb:-\ [\ ],fb:-
setlocal fo+=ro

function! ToggleComplete()
  let line = getline('.')
  if line =~ "^ *- \\[x\\]"
    s/^\( *\)- \[x\]/\1- \[ \]/
    s/ *@done.*$//
  elseif line =~ "^ *- \\[ \\]"
    s/^\( *\)- \[ \]/\1- \[x\]/
    let text = " @done (" . strftime("%Y-%m-%d %H:%M") .")"
    exec "normal! A" . text
    normal! _
  endif
endfunc

function! ToggleCancel()
  let line = getline('.')
  if line =~ "^ *- X"
    s/^\( *\)- X/\1- \[ \]/
    s/ *@cancelled.*$//
  elseif line =~ "^ *- \\[ \\]"
    s/^\( *\)- \[ \]/\1- X/
    let text = " @cancelled (" . strftime("%Y-%m-%d %H:%M") .")"
    exec "normal! A" . text
    normal! _
  endif
endfunc

function! ToggleTask()
  let line=getline('.')
  if line =~ "^ *$"
    normal! A- [ ]<C-o>A
  else
    if line =~ "^ *- \\[ \\] .*"
        echomsg "case a"
        normal! ^df]i*
    elseif line =~ "^ *[\*-] .*"
        normal! ^xxI- [ ] 
    endif
  end
endfunc

function! ArchiveTasks()
    let orig_line=line('.')
    let orig_col=col('.')
    let archive_start = search("^# Archive")
    if (archive_start == 0)
        call cursor(line('$'), 1)
        normal! 2o
        normal! o--------------------------
        normal! o
        normal! o# Archive
        normal! o
        normal! 0D
        let archive_start = line('$') - 1
    endif
    call cursor(1,1)

    let found=0
    let a_reg = @a
    let @a = ""
    if search("- \\[x\\]", "", archive_start) != 0
        call cursor(1,1)
        while search("- \\[x\\]", "", archive_start) > 0
            if (found == 0)
                normal! "add
            else
                normal! "Add
            endif
            let found = found + 1
            call cursor(1,1)
        endwhile

        call cursor(archive_start + 1,1)
        normal! "ap
    endif

    "clean up
    let @a = a_reg
    call cursor(orig_line, orig_col)
endfunc

function! Separator()
    let line = getline('.')
    if line =~ "^-*$"
      return "--------------------------"
    else
      return "---"
    end
endfunc
