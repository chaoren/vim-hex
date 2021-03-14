function hex#readpost()
	setlocal filetype=xxd
	setlocal noundofile
	let l:undolevels = &l:undolevels
	setlocal undolevels=-1
	silent execute '%!xxd'
	let &l:undolevels = l:undolevels
	execute 'silent!' 'rundo' fnameescape(undofile(expand('%')))
	silent! loadview
endfunction

function hex#writepre()
	let b:hex_save_view = winsaveview()
	let &l:endofline = getline('$')[10:48] =~# '0a *$'
	execute 'wundo' fnameescape(undofile(expand('%')))
	silent execute '%!xxd -revert'
endfunction

function hex#writepost()
	let l:undolevels = &l:undolevels
	setlocal undolevels=-1
	silent execute '%!xxd'
	let &l:undolevels = l:undolevels
	execute 'silent!' 'rundo' fnameescape(undofile(expand('%')))
	setlocal nomodified
	call winrestview(b:hex_save_view)
	unlet b:hex_save_view
endfunction

function hex#textchanged()
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
endfunction
