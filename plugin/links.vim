""""""""""""""""""""""""""""""" Include guard """""""""""""""""""""""""""""" {{{
if exists('g:loaded_sweedlerLinks')
  finish
endif
let g:loaded_sweedlerLinks = 1
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""" }}}
"""""""" Implement plugin API in terms of internal helper functions """""""" {{{
noremap <unique> <script> <Plug>LinkCreateNormal :call links#create_normal()<CR>
noremap <unique> <script> <Plug>LinkCreateInsert :call links#create_insert()<CR>a
noremap <unique> <script> <Plug>LinkCreateVisual "0da[<C-r>0](<C-r>*)
noremap <unique> <script> <Plug>LinkOpenOpen :call links#open("open")<CR>
noremap <unique> <script> <Plug>LinkOpenYank :call links#open("yank")<CR>
noremap <unique> <script> <Plug>GetFilepathOfCurrentFile :let @* = expand("%:p")<CR>
noremap <unique> <script> <Plug>GetLinkToCurrentFile :let @* = percent#get_link_to_curpos()<CR>
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""" }}}
"""""""""""""""""" Give default keybindings to plugin API """""""""""""""""" {{{
if !hasmapto('<Plug>LinkCreate')
  nmap <unique> <C-k> <Plug>LinkCreateNormal
  imap <unique> <C-k> <C-c><Plug>LinkCreateInsert
  nnoremap <silent> <unique> <Leader><C-k> :delmarks k<CR>
endif
if !hasmapto('<Plug>LinkCreateVisual')
  vmap <unique> <C-k> <Plug>LinkCreateVisual
endif
if !hasmapto('<Plug>LinkOpenOpen')
  nmap gx <Plug>LinkOpenOpen
endif
if !hasmapto('<Plug>LinkOpenYank')
  nmap gX <Plug>LinkOpenYank
endif
if !hasmapto('<Plug>GetFilepathOfCurrentFile')
  nmap <Leader>% <Plug>GetFilepathOfCurrentFile
endif
if !hasmapto('<Plug>GetLinkToCurrentFile')
  nmap <Leader><Leader>% <Plug>GetLinkToCurrentFile
endif
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""" }}}
