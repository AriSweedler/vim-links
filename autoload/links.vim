""""""""""""""""""""""""""""""" Include guard """""""""""""""""""""""""""""" {{{
if exists('g:autoloaded_sweedlerLinks')
  finish
endif
let g:autoloaded_sweedlerLinks = 1
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""" }}}
""""""""""""""""""""""""""""""" Create links """"""""""""""""""""""""""""""" {{{
function! links#create_insert()
  call lib#break_undo()
  let [_, kmark_line, kmark_col, _] = getpos("'k")

  " If the k-mark isn't set, then set it & return
  if kmark_line == 0
    normal! mk
    return
  endif

  " Skip past a space if needed
  let movement = "`k"
  if (getline('.')[kmark_col-1] == ' ')
    let movement = "`kl"
  endif

  " Highlight text from the cursor to the k-mark, and replace it with a link
  execute 'normal! v' . movement . '"0da[0](*)'
  call lib#break_undo()

  " Unset the k-mark
  delmarks k
endfunction

function! links#create_normal()
  let [_, cursor_line, cursor_col, _, _] = getcurpos()
  let [_, kmark_line, kmark_col, _] = getpos("'k")

  " If we can use the k-mark, do so.
  let movement = "`k"
  if (cursor_line == kmark_line && kmark_col < cursor_col)
    " Skip past a space if needed
    if (getline('.')[kmark_col-1] == ' ')
      let movement = "`kl"
    endif
  " Else use WORD
  else
    let movement = "iW"
  endif

  " Highlight text from the cursor to the k-mark, and replace it with a link
  execute 'normal! v' . movement . '"0da[0](*)'

  " Unset the k-mark
  delmarks k
endfunction
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""" }}}
"""""""""""""""""""""""""""""""" Open links """""""""""""""""""""""""""""""" {{{
" Open the URL under cursor. Or the last link on the line
" Links are of the form [title](URL)
function! links#open(arg)
  " Try to find link under cursor
  let l:link_regex = '\[\_[^]]*](\([^)]*\))'
  let l:link = substitute(expand('<cWORD>'), l:link_regex, '\1', '')

  " If no substitution is made, no link was found.
  " Try to find last link on the current line
  if l:link == expand('<cWORD>')
    "echo "No link under cursor. Trying to open last link on this line"
    let l:line_link_regex = '^'. '.*' . '\[' . '\_[^]]*' . '](' . '\([^[]*\)' . ')' . '.*'
    let l:link = substitute(getline('.'), l:line_link_regex, '\1', '')
  endif

  " If no substitution is made, no link was found.
  if l:link == getline('.')
    echom "ERROR: No link found on this line. Giving up"
    return
  endif

  " Escape '%' so it doesn't get expanded into the filename erroneously
  let l:link = escape(l:link, "%")

  if a:arg == "open"
    call s:link_open_helper(l:link)
  elseif a:arg == "yank"
    call setreg('*', l:link)
    echom "'" . l:link . "' placed on clipboard"
  endif
endfunction

function! s:link_open_helper(link)
  let l:parts = split(a:link, ':\/\/')
  if len(l:parts) != 2
    execute '!open "' . a:link . '"'
    return
  endif

  let [l:protocol, l:file] = l:parts
  if l:protocol == "https"
    execute '!open "' . a:link . '"'
    return
  endif

  if l:protocol == "vim"
    call s:link_open_helper_vim(l:file)
  else
    echom "Proto " . l:protocol . " not supported in " . expand("<stack>")
  endif
endfunction

function! s:link_open_helper_vim(body)
  let idx = match(a:body, ':')
  if idx == -1
    execute "tabe " . a:body
    return
  endif

  let [l:file, l:line] = split(a:body, ':')
  execute "tabe " . l:file
  execute "normal " . l:line . "Gzx"
endfunction
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""" }}}
