if exists('g:loaded_hex')
	finish
endif
let g:loaded_hex = 1

augroup HEX
	autocmd!
	autocmd BufReadPost  * if &l:binary       | call hex#readpost()    | endif
	autocmd BufWritePre  * if exists('b:hex') | call hex#writepre()    | endif
	autocmd BufWritePost * if exists('b:hex') | call hex#writepost()   | endif
	autocmd TextChanged  * if exists('b:hex') | call hex#textchanged() | endif
augroup END
