" special C syntax file modifier:
" add C function highlight

" Function detection
""""""""""""""""""""
" "display" is here to speed up (see syn-display), "me=e-1" is to prevent the
" "(" to be highlight by defining the match end "me" to be at end  - 1
" character, "\h" matche the start of a word.

" This match also MACRO like #define TOTO (1<<2) so it is not used
" syntax match cFunction display "\<\h\w*\>\s*("me=e-1   
syntax match cFunction display "\<\h\w*("me=e-1
syntax match cFunction display "\**\h\w*("me=e-1,ms=s+1
highlight def link cFunction Function

" Todo new keywords
"""""""""""""""""""
syntax keyword cTodo contained todo

