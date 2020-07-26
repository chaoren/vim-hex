if exists('g:loaded_hex')
	finish
endif
let g:loaded_hex = v:true

function! s:HexReadPost() abort " {{{
	setlocal filetype=xxd
	setlocal noundofile
	let l:undolevels = &l:undolevels
	setlocal undolevels=-1
	silent execute '%!xxd'
	let &l:undolevels = l:undolevels
	execute 'silent!' 'rundo' fnameescape(undofile(expand('%')))
	silent! loadview
endfunction " }}}

function! s:HexWritePre() abort " {{{
	let b:hex_save_view = winsaveview()
	let &l:endofline = getline('$')[10:48] =~ '0a *$'
	execute 'wundo' fnameescape(undofile(expand('%')))
	silent execute '%!xxd -revert'
endfunction " }}}

function! s:HexWritePost() abort " {{{
	let l:undolevels = &l:undolevels
	setlocal undolevels=-1
	silent execute '%!xxd'
	let &l:undolevels = l:undolevels
	execute 'silent!' 'rundo' fnameescape(undofile(expand('%')))
	setlocal nomodified
	call winrestview(b:hex_save_view)
	unlet b:hex_save_view
endfunction " }}}

function! s:HexTextChanged() abort "{{{
	if !&l:modified
		return
	endif
	try
		undojoin
	catch 'Vim(undojoin):E790: undojoin is not allowed after undo'
		return
	endtry
	let l:view = winsaveview()
	silent execute '%!xxd -revert | xxd'
	call winrestview(l:view)
endfunction " }}}

augroup HEX " {{{
	autocmd!
	autocmd BufReadPost * if &l:binary | call s:HexReadPost() | endif
	autocmd BufWritePre * if &l:binary | call s:HexWritePre() | endif
	autocmd BufWritePost * if &l:binary | call s:HexWritePost() | endif
	autocmd TextChanged * if &l:binary | call s:HexTextChanged() | endif
augroup END " }}}

" vim:fdm=marker
