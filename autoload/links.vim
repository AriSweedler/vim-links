""""""""""""""""""""""""""""""" Include guard """""""""""""""""""""""""""""" {{{
if exists('g:autoloaded_sweedlerLinks')
  finish
endif
let g:autoloaded_sweedlerLinks = 1
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""" }}}
""""""""""""""""""""""""""""""" Create links """"""""""""""""""""""""""""""" {{{
function! links#create_insert()
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
    execute '!open "' . l:link . '"'
  elseif a:arg == "yank"
    call setreg('*', l:link)
    echom "'" . l:link . "' placed on clipboard"
  endif
endfunction
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""" }}}
