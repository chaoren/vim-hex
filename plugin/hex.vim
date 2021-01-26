if exists('g:loaded_hex')
	finish
endif
let g:loaded_hex = 1

augroup HEX
	autocmd!
	autocmd BufReadPost  * if &l:binary | call hex#readpost()    | endif
	autocmd BufWritePre  * if &l:binary | call hex#writepre()    | endif
	autocmd BufWritePost * if &l:binary | call hex#writepost()   | endif
	autocmd TextChanged  * if &l:binary | call hex#textchanged() | endif
augroup END
