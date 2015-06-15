"Vim filetype plugin
" Language: GFPlainTasks
" Maintainer: Simon Mutch
" Original: David Elentok
" ArchiveTasks() added by Nik van der Ploeg

" Only do this when not done yet for this buffer
if exists("b:did_ftplugin")
    finish
endif

let s:show_tags_flag = 0

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

function! s:OpenSearchFolds(e)
    let s:show_tags_flag = 1
    let s:old_fold_expr = &foldexpr
    let s:old_foldminlines = &foldminlines
    let s:old_foldtext = &foldtext
    let s:old_foldlevel = &foldlevel
    let s:old_fillchars = &fillchars
    let regex = '\\('.a:e.'\\\\|^#\\)'
    " exec "setlocal foldexpr=(getline(v:lnum)=~'".regex."')?0:1"
    exec "setlocal foldexpr=(getline(v:lnum)=~'".regex."')?0:(getline(v:lnum-1)=~'".regex."')\\|\\|(getline(v:lnum+1)=~'".regex."')?1:2"
    setlocal foldlevel=0 fml=0 foldtext='\ ' fillchars="fold: "
endfunction

function! s:VimGrepKW(e)
    exec "normal! :lvimgrep /" . a:e . "/ %\<CR>:lopen\<CR>"
endfunction

function! ShowTags(grepflag)
    if (s:show_tags_flag == 1)
        let &l:foldexpr = s:old_fold_expr
        let s:show_tags_flag = 0
        let &l:foldminlines = s:old_foldminlines
        let &l:foldtext = s:old_foldtext
        let &l:foldlevel = s:old_foldlevel
        let &l:fillchars = s:old_fillchars
        return
    endif

    let word = expand("<cWORD>")
    let regexp = '@\w\+'

    let sink = '<SID>OpenSearchFolds'
    if a:grepflag == 1
        let sink = '<SID>VimGrepKW'
    endif

    if word =~ regexp
        exec 'call '.sink.'(word)'
    else
        call fzf#run({
                    \   'source':  'grep --line-buffered --color=never -roh "' . regexp . '" ' . fnameescape(@%) . ' | uniq',
                    \   'sink': function(sink)
                    \ })
    endif
endfunction

nnoremap <buffer><silent> <Localleader>nt :call ShowTags(1)<CR>
nnoremap <buffer><silent> <Localleader><Localleader> :call ShowTags(0)<CR>
