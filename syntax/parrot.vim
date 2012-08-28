" Vim syntax file for "Parrot" traces files
" 
" 01/2010 Frederic Chanal
"

if exists("b:current_syntax")
	finish
endif

" Pattern definitions
"""""""""""""""""""""
syntax match aai ".*aai\..*"
syntax match tala "\[..\] TALA.*"
syntax match tango "\[..\] TANGO.*"
syntax match portaudio "^PaAlsa.*"
syntax match alsa "^Alsa.*"
syntax match tamtam "\[..\] TAMTAM.*"

" highlights
""""""""""""
highlight blue ctermfg=LightBlue
highlight green ctermfg=LightGreen
highlight cyan ctermfg=LightCyan
highlight red ctermfg=LightRed
highlight magenta ctermfg=LightMagenta
highlight yellow ctermfg=LightYellow

highlight link aai red
highlight link tala green
highlight link tango blue
highlight link portaudio cyan
highlight link alsa yellow
highlight link tamtam magenta


let b:current_syntax="parrot"

