""""""""""""""""""""""""""""""" Include guard """""""""""""""""""""""""""""" {{{
if exists('g:loaded_sweedlerLinks')
  finish
endif
let g:loaded_sweedlerLinks = 1
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""" }}}
"""""""" Implement plugin API in terms of internal helper functions """""""" {{{
noremap <unique> <script> <Plug>LinkCreateNormal :call links#create_normal()<CR>
noremap <unique> <script> <Plug>LinkCreateInsert :call links#create_insert()<CR>
noremap <unique> <script> <Plug>LinkCreateVisual "0da[<C-r>0](<C-r>*)
noremap <unique> <script> <Plug>LinkOpenOpen :call links#open("open")<CR>
noremap <unique> <script> <Plug>LinkOpenYank :call links#open("yank")<CR>
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""" }}}
"""""""""""""""""" Give default keybindings to plugin API """""""""""""""""" {{{
if !hasmapto('<Plug>LinkCreate')
  nmap <unique> <C-k> <Plug>LinkCreateNormal
  imap <unique> <C-k> <C-c><Plug>LinkCreateInserta
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
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""" }}}
