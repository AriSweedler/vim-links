function! percent#get_link_to_curpos()
  let [_, l:lnum, _, _, _] = getcurpos()
  let l:file = expand("%:p")
  return "vim://".l:file.":".l:lnum
endfunction
