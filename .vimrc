set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
set nocompatible
" disable the mouse
" arbitrary change
set mouse=
filetype off
call plug#begin('~/.vim/plugged')

Plug 'neovim/nvim-lspconfig'

Plug 'jaxbot/semantic-highlight.vim'
" semantic highlighting
let g:semanticTermColors = [ 1, 2, 3, 5, 6, 7, 9, 10, 11, 12, 13, 14, 15, 48, 40, 205, 213, 51, 214, 199, 189 ]

Plug 'mbbill/undotree'

" vim surround
Plug 'tpope/vim-surround'

Plug 'junegunn/vim-easy-align'
xmap ga <Plug>(EasyAlign)

" Plug 'vim-airline/vim-airline-themes'
" let g:airline_theme='kolor'
" 
" " Plug 'powerline/powerline', {'rtp': 'powerline/bindings/vim'}
" Plug 'vim-airline/vim-airline'
" " let g:airline_section_a = ''
" " let g:airline_section_x = ''
" let g:airline_section_y = ''
" let g:airline_section_b = ''
" let g:airline_section_warning = ''
" let g:airline_section_z = '%3p%% %3l/%L %4c c'

Plug 'tpope/vim-fugitive'

Plug 'airblade/vim-gitgutter'
let g:gitgutter_max_signs=500
" Plug 'lewis6991/gitsigns.nvim'
set updatetime=100

" Plug 'majutsushi/tagbar'
" nmap <F8> :TagbarToggle<CR>
" let g:tagbar_autofocus = 1

" vim indent guides
" toggle indent guide: 
" <leader>ig
" Plug 'nathanaelkane/vim-indent-guides'

" HTML tag highlight
" Plug 'gregsexton/MatchTag'
" HTML navigation (without plugin)


" vim dispatch
Plug 'tpope/vim-dispatch'

" Plug 'dense-analysis/ale'
"
Plug 'preservim/nerdtree'
" if the file is open in another tab, don't go to it, open it in the current
" tab
let g:NERDTreeCustomOpenArgs = {'file': {'reuse': 'currenttab', 'where': 'p', 'keepopen': 1}, 'dir': {}}

" Plug 'jwhite510/nvim_win_tabs'

Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-sleuth'
Plug 'rickhowe/spotdiff.vim'
" Plug 'rickhowe/diffchar.vim'



" let g:ycm_key_list_select_completion=[]
" let g:ycm_key_list_previous_completion=[]
" Plug 'Valloric/YouCompleteMe'
" let g:ycm_auto_trigger = 0
" let g:ycm_autoclose_preview_window_after_insertion = 0
" let g:ycm_show_diagnostics_ui = 0
" error checking with pylint
"
" Plug 'OmniSharp/omnisharp-vim'
" let g:OmniSharp_server_use_mono = 1
" let g:OmniSharp_server_use_mono = 1
Plug 'zonzon510/context.vim'
let g:context_enabled=0
let g:context_nvim_no_redraw=1
let g:context_add_mappings = 0
nnoremap <silent> <expr> <C-Y> w:context.enabled ? context#util#map('<C-Y>') : "\<C-Y>"
nnoremap <silent> <expr> <C-E> w:context.enabled ? context#util#map('<C-E>') : "\<C-E>"
nnoremap <silent> <expr> zz    w:context.enabled ? context#util#map('zz') : "zz"
nnoremap <silent> <expr> zb    w:context.enabled ? context#util#map('zb') : "zb"
nnoremap <silent> <expr> zt    w:context.enabled ? context#util#map_zt() : "zt"
nnoremap <silent> <expr> H     w:context.enabled ? context#util#map_H() : "H"

" fzf
set rtp+=~/.fzf
Plug 'junegunn/fzf.vim'
" change name so ag.vim doesnt overwrite this command
:command -bang -nargs=* Agf call fzf#vim#ag(<q-args>, <bang>0)
let g:fzf_layout = { 'down': '~25%' }


Plug 'rking/ag.vim'

" Plug 'SirVer/ultisnips'

Plug 'zonzon510/zgdb'

Plug 'tpope/vim-repeat'

Plug 'easymotion/vim-easymotion'

" Plug 'zonzon510/diffchar.vim'



Plug 'kshenoy/vim-signature'

Plug 'sk1418/QFGrep'

call plug#end()

set laststatus=2
set encoding=utf-8

function SearchFold(contextLines)
	if getline(v:lnum)=~@/
		return 0
	endif

	let l:contextLinesBelow = 1
	let l:contextLinesAbove = 1

	while (l:contextLinesBelow < a:contextLines)
		if getline(v:lnum + l:contextLinesBelow)=~@/
			" return l:contextLinesBelow
			break
		endif
		let l:contextLinesBelow = l:contextLinesBelow + 1
	endwhile

	while (l:contextLinesAbove < a:contextLines)
		if getline(v:lnum - l:contextLinesAbove)=~@/
			" return l:contextLinesAbove
			break
		endif
		let l:contextLinesAbove = l:contextLinesAbove + 1
	endwhile

	return min([l:contextLinesAbove, l:contextLinesBelow])
endfunction

function FugitiveRefresh()
	let s:fugitive_cmd_cus = b:fugitive_cmd_cus
	:exec ":".b:fugitive_cmd_cus
	" get the buffer number
	let s:bufnew = bufnr()
	" go back to the original window
	:exec "wincmd j"
	" set it to the new buffer
	:exec ":b ".s:bufnew
	" go back to the other window
	:exec "wincmd k"
	:exec ":q"
	" set it to the proper command here
	" let the autocmd's trigger, then reset the fugitive_cmd_cus
	call feedkeys(":let b:fugitive_cmd_cus = \"".s:fugitive_cmd_cus."\""."\<CR>")
endfunction

function FugitiveModify()
	call feedkeys(":".b:fugitive_cmd_cus)
endfunction

function FugitiveRefreshInit()
	if &ft == 'git'
		nmap <buffer> rr :call FugitiveRefresh()<CR>
		nmap <buffer> rm :call FugitiveModify()<CR>
		call feedkeys(":let b:fugitive_cmd_cus = @:"."\<CR>")
	endif
endfunction

augroup fugitive_maps
	autocmd!
	" autocmd User FugitiveObject nmap <buffer> <leader>n :echo hello
	" autocmd User FugitiveChanged echo "FugitiveChanged"
	" autocmd User FugitiveIndex echo "FugitiveIndex"
	" autocmd User FugitiveObject echo "FugitiveObject"
	" autocmd User FugitivePager echo "FugitivePager"
	" autocmd User FugitivePager let b:testv = @:
	" autocmd User FugitivePager norm! G
	autocmd User FugitivePager call FugitiveRefreshInit()
	" refresh fugitive command
	" autocmd User FugitivePager nmap <buffer> rr :call FugitiveRefresh()<CR>
	" " modify fugitive command
	" autocmd User FugitivePager nmap <buffer> rm :call FugitiveModify()<CR>
augroup END
" define functions
function Rand()
    return str2nr(matchstr(reltimestr(reltime()), '\v\.@<=\d+')[1:])
endfunction
fun! CheckEnableSemanticHighLight()

	" first see if semantic color is already on
	if exists('b:semanticOn')
		" semantic highlight is already on
		return
	else
		" check how many lines the file has
		if line('$') < 4000
			" enable semantic highlight
			let b:semanticOn=1
			:execute ":SemanticHighlight"
		endif
	endif


endfun
fun! ShrinkFoldTop(direction)
	try
		normal! zo
	catch
	endtry
	try
		normal! [z
	catch
	endtry
	try
		normal! mt
	catch
	endtry
	try
		normal! ]z
	catch
	endtry
	try
		normal! ms
	catch
	endtry

	try
		normal! `t
	catch
	endtry


	try
		normal! zd
	catch
	endtry

	"
	" delete the fold
	if a:direction == 'top'
		try
			normal! j
		catch
		endtry
	else
		try
			normal! k
		catch
		endtry

	endif


	try
		normal! V`s
	catch
	endtry

	try
		normal! zf
	catch
	endtry

	" try
	" 	normal! `tV`s
	" catch
	" endtry

endfun
fun! ShrinkFoldBottom(direction)
	try
		normal! zo
	catch
	endtry
	try
		normal! [z
	catch
	endtry
	try
		normal! mt
	catch
	endtry
	try
		normal! ]z
	catch
	endtry
	try
		normal! ms
	catch
	endtry

	try
		normal! `t
	catch
	endtry


	try
		normal! zd
	catch
	endtry

	try
		normal! V`s
	catch
	endtry


	"
	" delete the fold
	if a:direction == 'top'
		try
			normal! j
		catch
		endtry
	else
		try
			normal! k
		catch
		endtry

	endif


	try
		normal! zf
	catch
	endtry

	" try
	" 	normal! `tV`s
	" catch
	" endtry

endfun
fun! UpByIndent()

	" mark the current position
	normal! m'

	" if the column is blank, find the first non blank column moving upward
	if col("$") == 1
		while col("$") == 1
			normal! j
		endwhile
	endif

	norm! ^
	let start_col = col(".")
	let col = start_col
	while col >= start_col
		norm! k^
		if getline(".") =~# '^\s*$'
			let col = start_col
		elseif col(".") <= 1
			norm! $
			return
		else
			let col = col(".")
		endif
	endwhile
	norm! $
endfun
fun! MoveBySameLevel(direction)
	normal! m`

	" if cursor is on a blank line
	if col("$") == 1
		while col("$") == 1
			if a:direction == "up"
				normal! k
			else
				normal! j
			endif
		endwhile
	else
	" if the cursor is on a line with text

		if a:direction == "down"
			:execute search('^'. matchstr(getline('.'), '\(^\s*\)') .'\%>' . line('.') . 'l\S', 'e')

		elseif a:direction == "up"
			:execute search('^'. matchstr(getline('.'), '\(^\s*\)') .'\%<' . line('.') . 'l\S', 'be')
		endif

	endif



endfun
fun! SearchWordsOnLine()
	" get top of screen
	let s:top=getwininfo(win_getid())[0]['topline']
	let s:startpos = getcurpos()
	normal! $
	let s:startline = getcurpos()[1]
	normal! ^
	let s:searchquery=''
	let s:lastsearchquery=''
	let s:firstword=1
	while getcurpos()[1] == s:startline
		if expand("<cword>") != s:lastsearchquery
			let s:ors=s:firstword?'':'\|'
			let s:searchquery= s:searchquery. s:ors . '\<' . expand("<cword>"). '\>'
		endif
		let s:lastsearchquery=expand("<cword>")
		let s:firstword=0
		normal! w
	endwhile
	" normal! /pattern/e+1^M
	call setpos('.',s:startpos)
	call feedkeys('/'.s:searchquery."\<CR>")
	let s:cmdstr=":call setpos('.',[".s:startpos[0].','.s:startpos[1].','.s:startpos[2].','.s:startpos[3].','.s:startpos[4].'])'
	call feedkeys(s:cmdstr."\<CR>")
	let s:to_top=getcurpos()[1] - s:top
	call feedkeys(s:to_top.'k')
	call feedkeys('zt')
	call feedkeys(s:to_top.'j')
endfun
fun! MyGrep(sargs, pattern)
	" if ignore directories dont exist, create them
	:execute "silent !touch ./.grepignoredir > /dev/null 2>&1"
	:execute "silent !touch ./.grepignorefile > /dev/null 2>&1"
	let s:lines = readfile('.grepignoredir')
	let s:dirs_ignore = ''
	for s:line in s:lines
		let s:dirs_ignore = s:dirs_ignore . s:line . ","
	endfor

	let s:lines = readfile('.grepignorefile')
	let s:files_ignore = ''
	for s:line in s:lines
		let s:files_ignore = s:files_ignore . s:line . ","
	endfor

	let s:commandstr = ':grep '.a:sargs.' --exclude={'.s:files_ignore.'} --exclude-dir={' . s:dirs_ignore.'} '."'".a:pattern."' *"
	" type keys
	call feedkeys(s:commandstr)
	" execute immediately
	" :execute s:commandstr
	call feedkeys("\<c-f>"."0ci'")
endfun
fun! MyGrepSilent(sargs, pattern)
	" check if semantic highlighting is set
	let s:set_semantic = 0
	if exists('b:semanticOn')
		if b:semanticOn == 1
			let s:set_semantic = 1
		endif
	endif

	" if ignore directories dont exist, create them
	:execute "silent !touch ./.grepignoredir > /dev/null 2>&1"
	:execute "silent !touch ./.grepignorefile > /dev/null 2>&1"
	let s:lines = readfile('.grepignoredir')
	let s:dirs_ignore = ''
	for s:line in s:lines
		let s:dirs_ignore = s:dirs_ignore . s:line . ","
	endfor

	let s:lines = readfile('.grepignorefile')
	let s:files_ignore = ''
	for s:line in s:lines
		let s:files_ignore = s:files_ignore . s:line . ","
	endfor

	let s:commandstr = ':silent grep '.a:sargs.' --exclude={'.s:files_ignore.'} --exclude-dir={' . s:dirs_ignore.'} '."'".a:pattern."' *"

	" set marks for current screen position
	:execute "normal! msHmt"
	" call grep
	:execute s:commandstr
	" return to the original position
	:execute "normal! \<C-o>`tzt`s"
	" turn on semantic highlight
	if s:set_semantic == 1
		:execute ":SemanticHighlight"
	endif

endfun
fun! JumptoNext(direction, jump_to)
	" save old search
	let old = @/

	" jump to next <++>
	" let cmdstring = a:direction."<++>\<cr>"
	let cmdstring = a:direction.a:jump_to."\<cr>"
	:execute "normal! ".cmdstring

	" restore search
	call histdel('/', -1)
	let @/ = old
endfun
fun! OpenFileBrowser()
	let current_dir = expand("%:p:h")
	let file_name = expand("%:t")
	:execute ":e ".current_dir
	:call JumptoNext("/", "\\V".file_name)
endfun
fun! SplitViewMethodOpen()
	:execute ":split"
	" "call UpByIndent()
	" " ! ignores mappings
	:execute ":normal [m"
	:execute "normal! 1\<C-W>_"
	:execute "normal! zz"
	:execute ":normal \<c-w>p"
endfun
fun! SplitViewMethodClose()
	:execute ":normal \<c-w>k"
	if winheight(0) == 1
		" this is a view opened by method function
		:execute ":q"
		return
	endif
endfun
fun! BufferSave()
	" save the file if it was modified
	if &modified == 1
		:silent! execute ":w"
	endif
endfun
fun! OpenTerm()
	let current_dir = expand("%:p:h")
	:execute ":term"

	if has('win32')
		call feedkeys("apowershell.exe \<CR>")
		call feedkeys("cd \"".current_dir."\"\<CR>")
	else
		call feedkeys("acd \"".current_dir."\"\<CR>")
	endif
	call feedkeys("clear"."\<CR>")
endfun
fun! OpenTermTop()
	let current_dir = expand("%:p:h")
	:execute ":to 7sp"
	:execute ":term"
	call feedkeys("acd \"".current_dir."\"\<CR>")
	call feedkeys("clear"."\<CR>")
endfun
fun! OpenTermTab()
	let current_dir = expand("%:p:h")
	:execute ":tabe"
	:execute ":term"
	call feedkeys("acd \"".current_dir."\"\<CR>")
	call feedkeys("clear"."\<CR>")
endfun
fun! OpenTermRight()
	let current_dir = expand("%:p:h")
	:execute ":bo 50vs"
	:execute ":term"
	call feedkeys("acd \"".current_dir."\"\<CR>")
	call feedkeys("clear"."\<CR>")
endfun
fun! OpenMagit()
	let current_dir = expand("%:p:h")
	:execute ":tabe"
	" terminal for magit
	let s:jobid=termopen("emacs -nw --eval \"(magit-ediff)\"")
endfun
fun! QuickFixBufferListedOnly()
	let qfitems = getqflist()

	for i in qfitems
		if i['valid'] == 1
			" check if buffer is listed
			" (already has been opened)
			if buflisted(i['bufnr']) == 0
				" echo i
				" echo bufname(i['bufnr'])
				let i['text'] = bufname(i['bufnr']).' '.i['lnum'].' '.i['text']
				let i['bufnr'] = 0
				let i['lnum'] = 0
				let i['valid'] = 0
			endif
		endif
	endfor

	call setqflist(qfitems, 'r')
endfun
fun! QFSigns()
	" clear all qf signs
	call sign_unplace('qfsign_group')
	let qfitems = getqflist()

	let index = 0
	for i in qfitems
		if i['valid'] == 1
			call sign_place(index, 'qfsign_group', 'qfsign', bufname(i['bufnr']), {'lnum':i['lnum'], 'priority':11})
			let index = index + 1
		endif
	endfor

	" call setqflist(qfitems, 'r')

endfun
fun! LLSigns()
	" clear all qf signs
	call sign_unplace('llsign_group', {'buffer':bufnr()})
	let llitems = getloclist(0)

	let index = 0
	for i in llitems
		if i['valid'] == 1
			call sign_place(index, 'llsign_group', 'llsign', bufname(i['bufnr']), {'lnum':i['lnum'], 'priority':12})
			let index = index + 1
		endif
	endfor

	" call setqflist(qfitems, 'r')

endfun
fun! ProcessQF()
	" add quickfix signs
	call QuickFixBufferListedOnly()
	call QFSigns()


endfun
fun! KillTerminals()
	" kill all open terminal buffers
	let buffers = filter(range(1, bufnr('$')), 'bufexists(v:val)')
	for i in buffers
		if stridx(bufname(i), "term\:") == 0
			:silent! execute ":bd! ".i
		endif
	endfor

endfun

fun! OpenVSCode()
	let full_file_path = expand("%")

	" let current_dir = expand("%:p:h")
	" let file_name = expand("%:t")

	echo full_file_path
	" get current line and column
	let line_num = getcurpos()[1]
	let line_col = getcurpos()[4]
	:execute ":!code --goto ".full_file_path.":".line_num.":".line_col

endfun

fun! SwitchBuffer()

	" remember screen location
	let w:new_switch_buffer_position = line(".")
	:execute "normal! H"
	let w:new_switch_buffer_position_top = line(".")

	" switch to buffer
	:execute ":b#"
	if exists("w:old_switch_buffer_position")
		:execute "normal! "+w:old_switch_buffer_position_top+"gg"
		:execute "normal! zt"
		:execute "normal! "+w:old_switch_buffer_position+"gg"
	endif

	let w:old_switch_buffer_position = w:new_switch_buffer_position
	let w:old_switch_buffer_position_top = w:new_switch_buffer_position_top

endfun

fun! SwitchFileWindow(reset)

	if a:reset == 1
		if exists("w:switch_file_window_set")
			unlet w:switch_file_window_set
		endif
	endif

	" save current view
	:execute ":w"
	let current_win_number = win_getid()
	let new_filename = $HOME."/.vim_views/"."new_view_".current_win_number.".vim"
	let old_filename = $HOME."/.vim_views/"."old_view_".current_win_number.".vim"
	:execute "silent !mkdir ~/.vim_views/ > /dev/null 2>&1"
	set vop=folds,cursor
	:execute ":mkview! ".new_filename

	if(filereadable(old_filename))
		if exists("w:switch_file_window_set")
			:execute "e blank"
			:execute ":source ".old_filename
		endif
	endif
	:execute "silent !mv ".new_filename." ".old_filename

	let w:switch_file_window_set = 1
endfun

fun! DiffThisF()
	diffthis
	setlocal wrap
endfun

fun! SwitchFileMarker(reset)

	if a:reset == 1
		if exists("b:switch_file_window")
			unlet b:switch_file_window
		endif
	endif

	if exists("b:switch_file_window")

		" echo last_marks
		let cursor_location = getpos("'0")
		let top_location = getpos("'9")
		:execute "normal! m0Hm9`0"
		call setpos('.', top_location)
		:execute "normal! zt"
		call setpos('.', cursor_location)
		:execute "silent! normal! zO"
	else
		" save the location
		:execute "normal! m0Hm9`0"
	endif

	let b:switch_file_window = 1
endfun

" Save current view settings on a per-window, per-buffer basis.
function! AutoSaveWinView()
    if !exists("w:SavedBufView")
        let w:SavedBufView = {}
    endif
    let w:SavedBufView[bufnr("%")] = winsaveview()
endfunction

" Restore current view settings.
function! AutoRestoreWinView()
    let buf = bufnr("%")
    if exists("w:SavedBufView") && has_key(w:SavedBufView, buf)
        let v = winsaveview()
        let atStartOfFile = v.lnum == 1 && v.col == 0
        if atStartOfFile && !&diff
            call winrestview(w:SavedBufView[buf])
        endif
        unlet w:SavedBufView[buf]
    endif
endfunction

function! MoveMode(inputkey)
	:execute "normal! m`"
	if a:inputkey ==# "J"
		:execute "normal! 5j"
	endif

	if a:inputkey ==# "K"
		:execute "normal! 5k"
	endif

	while 1
		let cursor_line = getcurpos()[1]
		let cursor_col =  getcurpos()[2]
		:execute ':match ExtraCursor /\%'.cursor_line.'l\%'.cursor_col.'c/'
		redraw
		let c = getchar()
		let c = nr2char(c)

		if c ==# "J"
			:execute "normal! 5j"
		elseif c ==# "K"
			:execute "normal! 5k"
		else
			call feedkeys(c)
			break
		endif
	endwhile
	:execute ':match ExtraCursor //'

endfunction

function! NextClosedFold(dir)
    let cmd = 'norm!z' . a:dir
    let view = winsaveview()
    let [l0, l, open] = [0, view.lnum, 1]
    while l != l0 && open
        exe cmd
        let [l0, l] = [l, line('.')]
        let open = foldclosed(l) < 0
    endwhile
    if open
        call winrestview(view)
    endif
endfunction

function! SetFileTypeGNUPlot()
	:execute ":set ft=gnuplot"
	:execute ":setlocal omnifunc=syntaxcomplete#Complete"
endfunction

function! SetSyntaxComplete()
	:execute ":setlocal omnifunc=syntaxcomplete#Complete"
endfunction

function! DiffFileWhereThisLineWasLastEdited()
	" with fugitive
	:execute ":Git blame"
	:execute "normal! ye"
	:execute ":q"
	call feedkeys(":Ghdiffsplit! \<C-r>\"~1")
	" call feedkeys("\<CR>")

endfunction
function! WrapCmd()
	let _wn = win_getid()
	if &diff && !&wrap
		windo if &diff | set wrap | endif
	elseif &diff && &wrap
		windo if &diff | set nowrap | endif
	else
		set wrap! wrap?
	endif
	:call win_gotoid(_wn)

endfunction
function! ToggleCursorLine()
	let _wn = win_getid()
	if &cursorline
		windo set nocursorline
	else
		windo set cursorline
	endif
	:call win_gotoid(_wn)

endfunction
function! TabCloseRight()
	let cur = tabpagenr()
	while cur < tabpagenr('$')
		exe 'tabclose' . ' ' . (cur + 1)
	endwhile
endfunction

function! DebugMsg(msg) abort
    if !exists("g:DebugMessages")
        let g:DebugMessages = []
    endif
    call add(g:DebugMessages, a:msg)
endfunction
" call DebugMsg("stuff")

function! PrintDebugMsgs() abort
  if empty(get(g:, "DebugMessages", []))
    echo "No debug messages."
    return
  endif
  for ln in g:DebugMessages
    echo "- " . ln
  endfor
endfunction

command DebugStatus call PrintDebugMsgs()

function! BracketUpPreview(arg)
	" open scratch buffer above if not already open
	" get current window number

	" get window num and filetype
	let _wn = win_getid()
	let s:ft=&filetype
	let s:current_buffer=bufnr("%")
	let s:current_line=line('.')


	" move to window above and see if it is a bracketupview window
	:execute ":normal \<c-w>k"
	if exists('b:bracket_up_view') && b:bracket_up_view_buffer == s:current_buffer
		" see the current line of the mark
		let placed_sign=sign_getplaced(s:current_buffer,{'group':'BracketPreviewMarkersGroup','id':b:bracket_up_view_id})
		" echo placed_sign[0]['signs'][0]['lnum']
		" echo s:current_line
		if placed_sign[0]['signs'][0]['lnum']==s:current_line
			if(a:arg=='up')
				let s:currentlevel=b:bracket_up_view
				let b:bracket_up_view=b:bracket_up_view+1
				" if its already open
				"
				"
				"
				:call win_gotoid(_wn)
				" :call clearmatches()
				" :call matchadd('CtrlP_Preview', '\%'.line('.').'l',-10)

				" open split
				:execute ":sp"
				while s:currentlevel>=0
					:execute ":normal 0"
					:execute ":normal \<c-p>"
					let s:currentlevel=s:currentlevel-1
				endwhile
				let @"=getline('.')
				while len(split(getline(line('.')), '[A-Za-z]\>', 1)) - 1 == 0
					:execute ":normal k"
					let @"=getline('.').@"
				endwhile
				let @"=@"."\n"
				let s:line=line('.')
				" :execute ":normal yy"
				:execute ":q"
				:execute ":normal \<c-w>k"
				:execute ":normal ggP0i".s:line.": "
				call sign_place(b:bracket_up_view_id,'BracketPreviewMarkersGroup',b:bracket_up_view_name,bufnr("%"),{'lnum':line('.'),'priority':100})
				:execute ":normal \<c-w>+"
				:set wfh
				:execute ":SemanticHighlight"

				:call win_gotoid(_wn)
				return
			elseif(a:arg=='down')
				let b:bracket_up_view=b:bracket_up_view-1
				if b:bracket_up_view==0
					" call sign_unplace('BracketPreviewMarkersGroup',{'id':b:bracket_up_view_id})
					" call sign_undefine(b:bracket_up_view_id)
					:execute ":bd"
					:call win_gotoid(_wn)
					return

				endif
				:execute ":normal ggdd"
				:execute ":normal \<c-w>-"
				:execute ":normal gg"
				:call win_gotoid(_wn)
				return
			endif
		else
			" the view is open but at the wrong line when function called
			" call sign_unplace('BracketPreviewMarkersGroup',{'id':b:bracket_up_view_id})
			" call sign_undefine(b:bracket_up_view_id)
			:execute ":bd"
			:call win_gotoid(_wn)
			:call clearmatches()

		endif
	else
		" if its not open
		" get line up indent/bracket from current place
		:call win_gotoid(_wn)
		" :call clearmatches()
		" :call matchadd('CtrlP_Preview', '\%'.line('.').'l',-10)
		" put a mark here
		let bracketmarkerid=Rand()
		let bracketmarkername='BracketUp_'.bracketmarkerid
		let letters=["A","B","C","D","E","F","G","H"]
		let letter=letters[Rand()%8].letters[Rand()%8]
		let hlgroups=["CtrlP_Preview1",
					\"CtrlP_Preview2",
					\"CtrlP_Preview3",
					\"CtrlP_Preview4",
					\"CtrlP_Preview5",
					\"CtrlP_Preview6",
					\"CtrlP_Preview7",
					\"CtrlP_Preview8",
					\"CtrlP_Preview9",
					\]


		let hlgroup=hlgroups[Rand()%9]



		call sign_define(bracketmarkername, {"text" : letter,"texthl":hlgroup,"numhl":hlgroup,"linehl":"CtrlP_Preview_text"})
		if !exists('g:bracketupsigns_defined')
			let g:bracketupsigns_defined={}
		endif
		let g:bracketupsigns_defined[bracketmarkerid]=bracketmarkername

		if !exists('t:bracketupsigns')
			let t:bracketupsigns={}
		endif
		let t:bracketupsigns[bracketmarkerid]={"text":letter,"texthl":hlgroup,"numhl":hlgroup,"buffer":s:current_buffer,"name":bracketmarkername}
		call sign_place(bracketmarkerid,'BracketPreviewMarkersGroup',bracketmarkername,s:current_buffer,{'lnum':s:current_line,'priority':100})
		" jump to sign
		" call sign_jump(8758,'BracketPreviewMarkersGroup','')
		" call sign_unplace('BracketPreviewMarkersGroup',{'id':8758})
		" list which line the sign is currently on
		" call sign_getplaced
		:execute ":sp"
		:execute ":normal 0"
		:execute ":normal \<c-p>"

		" while there are no alphanumeric characters
		let @"=getline('.')
		while len(split(getline(line('.')), '[A-Za-z]\>', 1)) - 1 == 0
			:execute ":normal k"
			let @"=getline('.').@"
		endwhile
		let @"=@"."\n"
		let s:line=line('.')
		" :execute ":normal yy"
		:execute ":q"

		" if not already open
		:execute ":1new"
		:set wfh
		:execute ":normal VP0i".s:line.": "
		" call CheckEnableSemanticHighLight()
		" :execute 'match CtrlP_Preview /.*/'
		" :call matchadd('CtrlP_Preview', '.*',-10)
		" echo bracketmarkerid
		" return
		call sign_place(bracketmarkerid,'BracketPreviewMarkersGroup',bracketmarkername,bufnr("%"),{'lnum':1,'priority':100})
		:setlocal buftype=nofile
		:setlocal bufhidden=hide
		:setlocal noswapfile
		:set nowrap
		" au BufWinLeave <buffer> echo "hello".b:bracket_up_view_id

		au BufWinLeave <buffer> call sign_unplace('BracketPreviewMarkersGroup',{'id':b:bracket_up_view_id})
		au BufWinLeave <buffer> call sign_undefine(b:bracket_up_view_name)
		au BufWinLeave <buffer> unlet g:bracketupsigns_defined[b:bracket_up_view_id]
		au BufWinLeave <buffer> unlet t:bracketupsigns[b:bracket_up_view_id]

		:execute ":set ft=".s:ft
		:execute ":SemanticHighlight"
		:let b:bracket_up_view=1
		" set the file and line
		:let b:bracket_up_view_buffer=s:current_buffer
		:let b:bracket_up_view_id=bracketmarkerid
		:let b:bracket_up_view_name=bracketmarkername

		:call win_gotoid(_wn)

	endif


endfunction

function! UpdateBracketUpPreviewWin()
	if exists('b:bracket_up_view')
		let currentlevel=b:bracket_up_view
		let currentbracketupviewid=b:bracket_up_view_id
		let current_buffer=b:bracket_up_view_buffer

		let placed_sign=sign_getplaced(b:bracket_up_view_buffer,{'group':'BracketPreviewMarkersGroup','id':currentbracketupviewid})
		let current_line=placed_sign[0]['signs'][0]['lnum']
		:execute ":normal \<c-w>j"
		if exists('b:bracket_up_view') || bufnr("%") != current_buffer
			return
		endif
		" mark current position
		:execute ":normal msHmt"
		" go to line
		:execute ":normal ".current_line."gg"

		" delete the current scratch bufer above
		let _wn = win_getid()
		:execute ":normal \<c-w>k"

		" call sign_unplace('BracketPreviewMarkersGroup',{'id':currentbracketupviewid})
		" call sign_undefine(currentbracketupviewid)
		:execute ":bd"
		:call win_gotoid(_wn)

		while currentlevel>0
			call BracketUpPreview('up')
			let currentlevel=currentlevel-1
			:redraw
		endwhile
		:execute ":normal `tzt`s"
	endif
endfunction
function! UpdateBracketUpPreview()
	let _wn = win_getid()
	windo call UpdateBracketUpPreviewWin()
	:call win_gotoid(_wn)
endfunction

" for switching tabs
function! HideBracketUpPreviewSigns()
	if exists("t:bracketupsigns")
		for key in keys(t:bracketupsigns)
			let placed_sign=sign_getplaced(t:bracketupsigns[key]['buffer'],{'group':'BracketPreviewMarkersGroup','id':key})
			let currentline=placed_sign[0]['signs'][0]['lnum']
			call sign_unplace('BracketPreviewMarkersGroup',{'id':key,'buffer':t:bracketupsigns[key]['buffer']})
			" re define the sign
			call sign_define(t:bracketupsigns[key]['name'], {"text" : " ","texthl":"","numhl":"","linehl":""})
			" place in background
			call sign_place(key,'BracketPreviewMarkersGroup',t:bracketupsigns[key]['name'],t:bracketupsigns[key]['buffer'],
						\{'lnum':currentline,'priority':-10})
		endfor
		" echo "hide the signs"
	endif

endfunction
function! ShowBracketUpPreviewSigns()
	" echo "show the signs"
	if exists("t:bracketupsigns")
		" echo t:bracketupsigns
		for key in keys(t:bracketupsigns)
			" echo "show ".key."	buffer:".t:bracketupsigns[key]['buffer']
			let placed_sign=sign_getplaced(t:bracketupsigns[key]['buffer'],{'group':'BracketPreviewMarkersGroup','id':key})
			let currentline=placed_sign[0]['signs'][0]['lnum']
			call sign_unplace('BracketPreviewMarkersGroup',{'id':key,'buffer':t:bracketupsigns[key]['buffer']})
			call sign_define(t:bracketupsigns[key]['name'], {"text" : t:bracketupsigns[key]['text'],"texthl":t:bracketupsigns[key]['texthl'],"numhl":t:bracketupsigns[key]['numhl'],"linehl":"CtrlP_Preview_text"})
			" " place in background
			call sign_place(key,'BracketPreviewMarkersGroup',t:bracketupsigns[key]['name'],t:bracketupsigns[key]['buffer'],
			      		\{'lnum':currentline,'priority':100})
		endfor
		" echo "hide the signs"
	endif
endfunction
function! RemoveAllBracketUpPreviewSigns()
	for theid in keys(g:bracketupsigns_defined)
		" call DebugMsg("theid:".theid)
		call sign_unplace('BracketPreviewMarkersGroup',{'id':theid})
		call sign_undefine(g:bracketupsigns_defined[theid])
	endfor
endfun
function! TabcloseAutoCmdWin()
	if exists('b:bracket_up_view')
		:execute ":bd"
	endif
endfunction
function! TabcloseAutoCmd()
	windo call TabcloseAutoCmdWin()
endfunction
au TabLeave * call HideBracketUpPreviewSigns()
au TabEnter * call ShowBracketUpPreviewSigns()

function! SelectLastModifiedTextRegion()
	normal! `[V`]
endfun

function! RemoveFromLocationList()
	let curllist = getloclist(0)
	let curbufnr = bufnr()
	let newllist = []
	" echo curbufnr
	let lnum = getpos('.')[1]
	" echo lnum
	" get the buffer number and lnum
	" echo " curbufnr:".curbufnr." lnum:".lnum
	for thing in curllist
		if !and(thing['lnum'] == lnum, thing['bufnr'] == curbufnr)
			let newllist += [thing]
		endif
		" echo thing
	endfor
	:call setloclist(0,newllist)
	" echo newllist
	" echo curllist
endfun

function! TabUp(dir)
  set nowinfixheight
  " get the height of the current window
  let s:chheight = winheight(0)
  let s:startwinnr = winnr()

  " is the window other open?
  let s:otherwinnr = winnr((a:dir == "up" ? "1k" : "1j"))
  let s:otherheight = winheight(s:otherwinnr)

  if and(s:otherwinnr != s:startwinnr, s:otherheight == 1)
    if a:dir == "up"
      set nowinfixheight
      execute "wincmd k"
      execute "resize ".s:chheight
      execute "wincmd j"
      set wfh
      execute "wincmd k"

    elseif a:dir == "down"

      execute "wincmd j"
      set nowinfixheight
      execute "wincmd k"

      execute "resize 1"
      set wfh
      execute "wincmd j"
    endif

  else
    if a:dir == "up"
      execute "sp"
      execute "resize ".(s:chheight - 2)
      execute "wincmd j"
      set wfh
      execute "wincmd k"


    elseif a:dir == "down"
      execute "sp"
      execute "resize 1"
      set wfh
      execute "wincmd j"
    endif

  endif
  set nowinfixheight
endfunction

function! IgnoreDiff(pattern)
    let opt = ""
    if &diffopt =~ "icase"
      let opt = opt . "-i "
    endif
    if &diffopt =~ "iwhite"
      let opt = opt . "-b "
    endif
    let cmd = "!diff -a --binary " . opt .
      \ " <(perl -pe 's/" . a:pattern .  "/\".\" x length($0)/gei' " .
      \ v:fname_in .
      \ ") <(perl -pe 's/" . a:pattern .  "/\".\" x length($0)/gei' " .
      \ v:fname_new .
      \ ") > " . v:fname_out
    " echo cmd
    silent execute cmd
    redraw!
    return cmd
endfunction

command! IgnoreHexDiff set diffexpr=IgnoreDiff('0x[0-9a-fA-F]+') | diffupdate
command! IgnoreBracketDiff set diffexpr=IgnoreDiff('[{}]') | diffupdate
command! IgnoreDecimalDiff set diffexpr=IgnoreDiff('\\.\\d+') | diffupdate
command! NormalDiff set diffexpr= | diffupdate

command! CloseAllNerdTree tabdo windo if exists("b:NERDTree") | exec ":q" | endif


command! -bar DuplicateTabpane
      \ let s:sessionoptions = &sessionoptions |
      \ try |
      \   let &sessionoptions = 'blank,help,folds,winsize,localoptions' |
      \   let s:file = tempname() |
      \   execute 'mksession ' . s:file |
      \   tabnew |
      \   execute 'source ' . s:file |
      \ finally |
      \   silent call delete(s:file) |
      \   let &sessionoptions = s:sessionoptions |
      \   unlet! s:file s:sessionoptions |
      \ endtry


" find files and populate the quickfix list
fun! FindFiles(filename)
  let error_file = tempname()
  silent exe '!find . -iname "'.a:filename.'" | xargs file | sed "s/:/:1:/" > '.error_file
  set errorformat=%f:%l:%m
  exe "cfile ". error_file
  copen
  call delete(error_file)
endfun
command! -nargs=1 FindFile call FindFiles(<q-args>)

fun! AutoSave()
	" don't run if in the command line window
	if bufexists("[Command Line]")
		return
	endif
	" if we are on linux, can save on the time interval
	if !has('win32')
		let time_interval = 1 " seconds
		let autosave_l_curtime = strftime("%s")
		if !exists("g:autosave_curtime") || (autosave_l_curtime - g:autosave_curtime) < time_interval
			let g:autosave_curtime = autosave_l_curtime
			return
		endif
	endif

	if !exists("g:sessidentifier")
		if stridx(v:argv[-1], "---") != -1
			" sess argument has been supplied with ---
			let s:sesionname = split(v:argv[-1], "---")[-1]
			let g:sessidentifier = substitute(s:sesionname, ".vim", '', 'g')
		else
			" if it's not sourced from a .vim, set it to a
			" random number
			let g:sessidentifier = Rand()
		endif
	endif
	let chdir = getcwd()
	let chdir = substitute(chdir, '/', '-', 'g')
	let chdir = substitute(chdir, '\', '-', 'g')
	let chdir = substitute(chdir, ':', '-', 'g')

	exec ":silent mksession! ~/.nvimsessions/sess"."".chdir."---".g:sessidentifier.".vim"

endfun


"run 
"PluginUpdate
filetype plugin indent on
syntax on

" ale highlight colors
highlight ALEWarning ctermbg=NONE cterm=inverse
highlight ALEError ctermbg=NONE cterm=inverse
" this isnt working for some reason

" search / highlight settings 
set hlsearch
set cursorline
" set wrap
set ignorecase
set wildignorecase
set splitright

command! Diffthis call DiffThisF()
command! MakeTags !ctags -R .
" ctags -R --languages=C,C++ .
command! -bang TabCloseRight call TabCloseRight('<bang>')
" command! MakeTags !ctags -R --sort=yes --c++-kinds=+p --fields=+iaS --extra=+q .
" set leader key to space

set background=dark
highlight clear


if exists("syntax_on")
  syntax reset
endif

" autocommands
" auto enter with colors
autocmd bufenter *.py :call CheckEnableSemanticHighLight()
autocmd bufenter *.js :call CheckEnableSemanticHighLight()
autocmd bufenter *.cpp :call CheckEnableSemanticHighLight()
autocmd bufenter *.c :call CheckEnableSemanticHighLight()
autocmd bufenter *.h :call CheckEnableSemanticHighLight()
autocmd BufEnter *.py :call CheckEnableSemanticHighLight()
autocmd BufEnter *.cs :call CheckEnableSemanticHighLight()
autocmd BufEnter *.cu :call CheckEnableSemanticHighLight()

" autocmd BufLeave * :call BufferSave()
" autocmd BufWrite * :mksession! .autosave.vim

" keep window view
autocmd BufLeave * call AutoSaveWinView()
autocmd BufEnter * call AutoRestoreWinView()

" autocmd QuickfixCmdPost make call ProcessQF()
" autocmd QuickfixCmdPost cgetfile call ProcessQF()

au InsertLeave * match ExtraWhitespace /\s\+$/
au InsertLeave *.py :SemanticHighlight
au InsertLeave *.cpp :SemanticHighlight
au InsertLeave *.h :SemanticHighlight
au InsertLeave *.js :SemanticHighlight
au InsertLeave *.cs :SemanticHighlight
au InsertLeave *.cu :SemanticHighlight

" enter a gnu plot file
autocmd BufEnter *.gnu :call SetFileTypeGNUPlot()
" enter a cmakelists file
autocmd BufEnter CMakeLists.txt :call SetSyntaxComplete()

set undofile

" break indent level matching
set breakindent
set showbreak=--
" break at word not character
set linebreak
set display +=lastline
set nowrap

" set default latex filetype
let g:tex_flavor = "latex"
" incsearch
set incsearch
set t_Co=256

" when saving session, dont save options
set sessionoptions-=options

" close split without resizing windows
set noea
set foldlevelstart=20
set lazyredraw

" set diffopt+=bad-divider:'{}\ '

" define quickfix signs
call sign_define('qfsign', {"text" : "q>",})
" location list sign
call sign_define('llsign', {"text" : "l>",})

" let g:colors_name = "monokai"
"colors:

" indicate trailing white space
highlight ExtraWhitespace ctermbg=19
highlight CtrlP_Preview_text ctermbg=17
highlight CtrlP_PreviewInactive ctermbg=16 ctermfg=15
highlight CtrlP_Preview1 ctermbg=1 ctermfg=16
highlight CtrlP_Preview2 ctermbg=2 ctermfg=16
highlight CtrlP_Preview3 ctermbg=3 ctermfg=16
highlight CtrlP_Preview4 ctermbg=4 ctermfg=16
highlight CtrlP_Preview5 ctermbg=5 ctermfg=16
highlight CtrlP_Preview6 ctermbg=6 ctermfg=16
highlight CtrlP_Preview6 ctermbg=7 ctermfg=16
highlight CtrlP_Preview7 ctermbg=9 ctermfg=16
highlight CtrlP_Preview8 ctermbg=10 ctermfg=16
highlight CtrlP_Preview9 ctermbg=11 ctermfg=16


match ExtraWhitespace / \+$/


highlight ExtraCursor                  ctermbg=15        ctermfg=16
hi        TermCursorNC                 ctermfg=47        ctermbg=47   cterm=NONE
hi        Cursor                       ctermfg=235       ctermbg=231  cterm=NONE
hi        Visual                       ctermfg=NONE      ctermbg=59   cterm=NONE
" hi        CursorLine                   ctermfg=NONE      ctermbg=239  cterm=NONE
" hi        CursorColumn                 ctermfg=NONE      ctermbg=239  cterm=NONE
hi        CursorLine                   ctermfg=NONE      ctermbg=235  cterm=NONE
hi        CursorColumn                 ctermfg=NONE      ctermbg=235  cterm=NONE
hi        ColorColumn                  ctermfg=NONE      ctermbg=237  cterm=NONE
" tab line
hi        TabLineFill                  ctermfg=NONE      ctermbg=NONE cterm=NONE
hi        TabLine                      ctermfg=NONE      ctermbg=16   cterm=NONE
hi        TabLineSel                   ctermfg=NONE      ctermbg=98   cterm=NONE
hi        Title                        ctermfg=83        ctermbg=NONE cterm=NONE
" line number
hi        LineNr                       ctermfg=83        ctermbg=NONE cterm=NONE
" vertical split
hi        VertSplit                    ctermfg=235       ctermbg=235  cterm=NONE
" matching parenthesiis
hi        MatchParen                   ctermfg=197       ctermbg=NONE cterm=underline
hi        StatusLine                   ctermfg=231       ctermbg=98   cterm=NONE
hi        StatusLineNC                 ctermfg=231       ctermbg=16   cterm=NONE
hi        Pmenu                        ctermfg=NONE      ctermbg=NONE cterm=NONE
hi        PmenuSel                     ctermfg=NONE      ctermbg=59   cterm=NONE
hi        IncSearch                    ctermfg=235       ctermbg=186  cterm=NONE
" highlight color
hi        Search                       ctermfg=NONE      ctermbg=16   cterm=inverse
hi        Directory                    ctermfg=141       ctermbg=NONE cterm=NONE
" folded line
hi        Folded                       ctermfg=98        ctermbg=NONE cterm=NONE
" column in vertical split
hi        SignColumn                   ctermfg=NONE      ctermbg=NONE cterm=NONE
" the column displayed when diff mode is open
hi        FoldColumn                   ctermfg=NONE      ctermbg=98   cterm=NONE
" normal text
hi        Normal                       ctermfg=195       ctermbg=16 cterm=NONE
hi        Normal                       ctermfg=195       ctermbg=NONE cterm=NONE
hi        Boolean                      ctermfg=141       ctermbg=NONE cterm=NONE
hi        Character                    ctermfg=141       ctermbg=NONE cterm=NONE
hi        Comment                      ctermfg=48        ctermbg=NONE cterm=NONE
hi        Conditional                  ctermfg=226       ctermbg=NONE cterm=NONE
hi        Constant                     ctermfg=NONE      ctermbg=NONE cterm=NONE
hi        Define                       ctermfg=197       ctermbg=NONE cterm=NONE

hi        DiffAdd                      ctermfg=NONE      ctermbg=22   cterm=NONE
hi        DiffDelete                   ctermfg=57        ctermbg=NONE cterm=NONE
hi        DiffChange                   ctermfg=NONE      ctermbg=NONE cterm=NONE
hi        DiffText                     ctermfg=NONE      ctermbg=18   cterm=NONE

hi        ErrorMsg                     ctermfg=231       ctermbg=197  cterm=NONE
hi        WarningMsg                   ctermfg=231       ctermbg=197  cterm=NONE
hi        Float                        ctermfg=141       ctermbg=NONE cterm=NONE
hi        Function                     ctermfg=40        ctermbg=NONE cterm=NONE
hi        Identifier                   ctermfg=81        ctermbg=NONE cterm=NONE
hi        Keyword                      ctermfg=197       ctermbg=NONE cterm=NONE
hi        Label                        ctermfg=186       ctermbg=NONE cterm=NONE
" the area after the last line
hi        NonText                      ctermfg=98        ctermbg=NONE cterm=NONE
hi        Number                       ctermfg=141       ctermbg=NONE cterm=NONE
hi        Operator                     ctermfg=197       ctermbg=NONE cterm=NONE
" python imports PreProc
hi        PreProc                      ctermfg=225       ctermbg=NONE cterm=NONE
hi        Special                      ctermfg=231       ctermbg=NONE cterm=NONE
hi        SpecialComment               ctermfg=242       ctermbg=NONE cterm=NONE
hi        SpecialKey                   ctermfg=59        ctermbg=237  cterm=NONE
" classes and function definitions
hi        Statement                    ctermfg=141       ctermbg=NONE cterm=NONE
hi        StorageClass                 ctermfg=81        ctermbg=NONE cterm=NONE
" color of string
hi        String                       ctermfg=129       ctermbg=NONE cterm=NONE
hi        Tag                          ctermfg=255       ctermbg=NONE cterm=NONE
hi        Title                        ctermfg=231       ctermbg=NONE cterm=bold
hi        Todo                         ctermfg=95        ctermbg=NONE cterm=inverse,bold
" a lot of things are this color especially in vimrc
hi        Type                         ctermfg=117       ctermbg=NONE cterm=NONE
hi        Underlined                   ctermfg=NONE      ctermbg=NONE cterm=underline
hi        rubyClass                    ctermfg=197       ctermbg=NONE cterm=NONE
hi        rubyFunction                 ctermfg=148       ctermbg=NONE cterm=NONE
hi        rubyInterpolationDelimiter   ctermfg=NONE      ctermbg=NONE cterm=NONE
hi        rubySymbol                   ctermfg=141       ctermbg=NONE cterm=NONE
hi        rubyConstant                 ctermfg=81        ctermbg=NONE cterm=NONE
hi        rubyStringDelimiter          ctermfg=186       ctermbg=NONE cterm=NONE
hi        rubyBlockParameter           ctermfg=208       ctermbg=NONE cterm=NONE
hi        rubyInstanceVariable         ctermfg=NONE      ctermbg=NONE cterm=NONE
hi        rubyInclude                  ctermfg=197       ctermbg=NONE cterm=NONE
hi        rubyGlobalVariable           ctermfg=NONE      ctermbg=NONE cterm=NONE
hi        rubyRegexp                   ctermfg=186       ctermbg=NONE cterm=NONE
hi        rubyRegexpDelimiter          ctermfg=186       ctermbg=NONE cterm=NONE
hi        rubyEscape                   ctermfg=141       ctermbg=NONE cterm=NONE
hi        rubyControl                  ctermfg=197       ctermbg=NONE cterm=NONE
hi        rubyClassVariable            ctermfg=NONE      ctermbg=NONE cterm=NONE
hi        rubyOperator                 ctermfg=197       ctermbg=NONE cterm=NONE
hi        rubyException                ctermfg=197       ctermbg=NONE cterm=NONE
hi        rubyPseudoVariable           ctermfg=NONE      ctermbg=NONE cterm=NONE
hi        rubyRailsUserClass           ctermfg=81        ctermbg=NONE cterm=NONE
hi        rubyRailsARAssociationMethod ctermfg=81        ctermbg=NONE cterm=NONE
hi        rubyRailsARMethod            ctermfg=81        ctermbg=NONE cterm=NONE
hi        rubyRailsRenderMethod        ctermfg=81        ctermbg=NONE cterm=NONE
hi        rubyRailsMethod              ctermfg=81        ctermbg=NONE cterm=NONE
hi        erubyDelimiter               ctermfg=NONE      ctermbg=NONE cterm=NONE
hi        erubyComment                 ctermfg=95        ctermbg=NONE cterm=NONE
hi        erubyRailsMethod             ctermfg=81        ctermbg=NONE cterm=NONE
hi        htmlTag                      ctermfg=148       ctermbg=NONE cterm=NONE
hi        htmlEndTag                   ctermfg=148       ctermbg=NONE cterm=NONE
hi        htmlTagName                  ctermfg=NONE      ctermbg=NONE cterm=NONE
hi        htmlArg                      ctermfg=NONE      ctermbg=NONE cterm=NONE
hi        htmlSpecialChar              ctermfg=141       ctermbg=NONE cterm=NONE
hi        javaScriptFunction           ctermfg=81        ctermbg=NONE cterm=NONE
hi        javaScriptRailsFunction      ctermfg=81        ctermbg=NONE cterm=NONE
hi        javaScriptBraces             ctermfg=NONE      ctermbg=NONE cterm=NONE
hi        yamlKey                      ctermfg=197       ctermbg=NONE cterm=NONE
hi        yamlAnchor                   ctermfg=NONE      ctermbg=NONE cterm=NONE
hi        yamlAlias                    ctermfg=NONE      ctermbg=NONE cterm=NONE
hi        yamlDocumentHeader           ctermfg=186       ctermbg=NONE cterm=NONE
hi        cssURL                       ctermfg=208       ctermbg=NONE cterm=NONE
hi        cssFunctionName              ctermfg=81        ctermbg=NONE cterm=NONE
hi        cssColor                     ctermfg=141       ctermbg=NONE cterm=NONE
hi        cssPseudoClassId             ctermfg=148       ctermbg=NONE cterm=NONE
hi        cssClassName                 ctermfg=148       ctermbg=NONE cterm=NONE
hi        cssValueLength               ctermfg=141       ctermbg=NONE cterm=NONE
hi        cssCommonAttr                ctermfg=81        ctermbg=NONE cterm=NONE
hi        cssBraces                    ctermfg=NONE      ctermbg=NONE cterm=NONE

hi        GitGutterAdd                 ctermfg=48
hi        GitGutterChange              ctermfg=14
hi        GitGutterDelete              ctermfg=1
hi        GitGutterChangeDelete        ctermfg=4

let mapleader=" "

" nerdtree
function! NERDTreeYankCurrentNode()
    let n = g:NERDTreeFileNode.GetSelected()
    if n != {}
        call setreg('"', n.path.str())
        call setreg('+', n.path.str())
    endif
endfunction
autocmd VimEnter * call NERDTreeAddKeyMap({
        \ 'key': 'yy',
        \ 'callback': 'NERDTreeYankCurrentNode',
        \ 'quickhelpText': 'put full path of current node into the default register' })
" autocmd VimEnter * call NERDTreeAddKeyMap()

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code.
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)
" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying codeAction to the current buffer.
nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)

" # # # # # # # # # # # # # # # # # # # # # # # #
" #   N O R M A L  M O D E  M A P P I N G S     #
" # # # # # # # # # # # # # # # # # # # # # # # #

nnoremap <C-q> @@
" move up one indentation level
nmap <c-p> :call UpByIndent()<cr>
" find
nnoremap <SPACE> <Nop>
" buffer
" nnoremap gb :ls<CR>:b<Space>
nnoremap gb :Buffers<CR>
" move to line with same indentation
nnoremap <c-k> :call MoveBySameLevel("up")<cr>
" move to line with same indentation
nnoremap  <c-j> :call MoveBySameLevel("down")<cr>
" quickfix jump list
nnoremap [q :cprev <CR>zv
nnoremap ]q :cnext <CR>zv
nnoremap ]t :tnext <CR>
nnoremap [t :tprev <CR>
nnoremap <leader>ts :tsel <CR>
nnoremap [Q :cfirst <CR>zv
nnoremap ]Q :clast <CR>zv
" nnoremap <C-u> 5<C-y>
" nnoremap <C-d> 5<C-e>
" half screen movement
nnoremap <leader>d <C-d>
nnoremap <leader>u <C-u>
" fast movement
nnoremap J :call MoveMode("J")<CR>
nnoremap K :call MoveMode("K")<CR>
" nnoremap J 5j
" nnoremap K 5k
" open quickfix menu
nnoremap gc :bo copen <CR>
nnoremap gC :bo Copen <CR>
" add a word to to search, searching for multiple words
nnoremap <leader>ff viwyb/\<<C-R>"\><CR>
" space key doesnt do anything
nnoremap <leader>fa viwyb/<C-R>/\\|\<<C-R>"\><CR>
" remove most recently added seach item
nnoremap <leader>fr msHmt/<C-P><C-F>F\|hd$<CR>`tzt`s
" set search to previously searched pattern
nnoremap <leader>fp msHmt/<C-p><C-p><CR>`tzt`s
" ignore whitespace in current search
nnoremap <leader>/i :let @/ = join(split(substitute(@/, '\_s*', '', 'g'), '\zs'), '\_s*')
" search add another word to search pattern
nnoremap <leader>fs /<C-p>\\|
nnoremap <leader>fl :call SearchWordsOnLine()<cr>
nnoremap <leader>fi :set foldmethod=indent<cr>
nnoremap <leader>fm :set foldmethod=manual<cr>
" grep
nnoremap <leader>gg yiw:call MyGrep('-rIi', "<C-R>"")<cr>
" grep
" nnoremap <leader>gr yiw:call MyGrepSilent('-rIw', "<C-R>"")<cr>
nnoremap <leader>gs :tabe<CR>:Git<CR>
" open file browser at folder of current file
nnoremap <leader>cp :call OpenFileBrowser()<CR>
nnoremap <leader>ce :!cd <c-r>=substitute(expand('%:h'), '/', '\', 'g')<cr> && explorer.exe .
" open method in single line split
nnoremap <leader>mo :call SplitViewMethodOpen()<cr>
" close method
nnoremap <leader>mc :call SplitViewMethodClose()<cr>

nnoremap <A-C-p> :call BracketUpPreview('up')<cr>
nnoremap <A-C-n> :call BracketUpPreview('down')<cr>
nnoremap <A-C-u> :call UpdateBracketUpPreview()<cr>

" nnoremap <A-C-k> :NvimTabsTabup<cr>
" nnoremap <A-C-j> :NvimTabsTabdown<cr>
" nnoremap <A-C-q> :NvimTabsClosetab<cr>
" nnoremap <A-C-t> :NvimTabsNewtab<cr>

nnoremap <A-C-k> :call TabUp("up")<cr>
nnoremap <A-C-j> :call TabUp("down")<cr>

" checktime shortcut
nnoremap <leader>ch :checktime<CR>
nnoremap <leader>cl :cclo<CR>
" toggle coc
nnoremap <leader>co :call CocToggle()<CR>
" open a terminal
nnoremap <leader>te :call OpenTerm()<CR>
nnoremap <leader>tr :call OpenTermRight()<CR>
nnoremap <leader>tb :call OpenTermTop()<CR>
nnoremap <leader>tt :call OpenTermTab()<CR>
nnoremap <leader>tc :call TabcloseAutoCmd()<CR> :tabclose<CR>
nnoremap <leader>tC :call TabCloseRight()<CR>
" open undo tree
" added this
nnoremap <leader>tu :UndotreeToggle<CR>
nnoremap <leader>to :ContextToggleWindow<CR>
nnoremap <leader>ga :call OpenMagit()<CR>
" write to random tmp file
nnoremap <leader>tw :w /tmp/<C-r>=Rand()<CR><C-r>=Rand()<CR><CR>

" save session
nnoremap <leader>mk :tabdo ContextDisable<CR> :mksession! .save.vim<CR>
" run Make silent
nnoremap <leader>ms :w<CR>:Make!<CR>
" run Make
nnoremap <leader>ma :wa<CR>:silent! AbortDispatch<CR>:Make<CR>
" nnoremap <leader>ma :wa<CR>:make<CR>
" run get quickfix results from Copen
nnoremap <leader>mC :Copen<CR><C-w>p:cclo<CR>
" do math (math do)
nnoremap <leader>md ^vg_yA = <c-r>=<c-r>"<CR><ESC>
" abort dispatch
nnoremap <leader>mb :AbortDispatch<CR>
" filter quickfix results to include only files in a buffer
nnoremap <leader>qb :call QuickFixBufferListedOnly()<CR>
" delete all terminal buffers
nnoremap <leader>tka :call KillTerminals()<cr>
" toggle ale linting
nnoremap <leader>ll :echo "assign me"<CR>
nnoremap <leader>le :call DiffFileWhereThisLineWasLastEdited()<CR>
" command for toggleing line numbers
nnoremap <leader>nu :set invnumber<CR>
nnoremap <leader>nr :set relativenumber!<CR>
" toggle line wrapping
" nnoremap <leader>W :set wrap! wrap?<CR>
nnoremap <leader><c-w> :call WrapCmd()<CR>
" toggle line wrapping
nnoremap <leader>w :wa<CR>
" toggle semantic highlighting
nnoremap <leader>jc :SemanticHighlightToggle<cr>
" fuzzy finding things
nnoremap <leader>ja  :Tags 
nnoremap <leader>jl :Lines 
nnoremap <leader>jb :BLines 
nnoremap <leader>jB :TagbarOpen fjc<CR>
nnoremap <leader>jf :Files
nnoremap <leader>jh :History:<CR>
" nnoremap <leader>jB :TagbarToggle<CR>
" move line to end of line above it
nnoremap <leader>J J
" open documentation
nnoremap <leader>K K
" case insensitive search
nnoremap <leader>ss :let g:sessidentifier=""<left>
nnoremap <leader>SS :echo g:sessidentifier<CR>

nnoremap <leader>SB :set scrollbind!<CR>
nnoremap <leader>sb :set scrollbind<CR>
" case insensitive search forward
" nnoremap <leader>S ?
" case sensitive search backward
" nnoremap <leader>S /
" no highlight
nnoremap <leader>nh :noh<cr>
" close preview window
nnoremap <C-Space> :pc<CR>
" open in vscode
nnoremap <leader>vs :w<CR>:call OpenVSCode()<CR><CR>
nnoremap <leader>as :!android-studio --line <C-r>=getcurpos()[1]<CR> --column <C-r>=getcurpos()[4] - 1<CR> <C-r>=expand("%:p")<CR><CR>
nnoremap <leader>vl ^vg_
nnoremap <leader>vo :VDiffoff!<CR>
nnoremap <leader>vu :VDiffupdate<CR>
nnoremap <leader>ic :set ic! ic?<CR>
nnoremap <leader>io :diffoff<CR>
nnoremap <leader>iO :diffoff!<CR>
nnoremap <leader>it :diffthis<CR>
" change to directory of currently open file
nnoremap <leader>cd :cd %:p:h<CR>
nnoremap <leader>cu :call ToggleCursorLine()<CR>
nnoremap <leader>mv :mkview<cr>
nnoremap <leader>lv :loadview<cr>

nnoremap <leader>pw :pwd<CR>

" nerdtre bindings
nnoremap <leader>nf :NERDTreeFind<CR><C-w>p
nnoremap <leader>nt :NERDTreeToggle<CR>

" silver searching
nnoremap <leader>aa yiw :Ag! -w <C-R>"<CR><C-w>p
" type the search pattern
nnoremap <leader>ag :Ag! 
" ag fuzzy find search
nnoremap <leader>af :Agf 
" switch to previous buffer
nmap <leader>ph :call SwitchBuffer()<CR>
nmap <leader>bs :call SwitchFileMarker(0)<CR>
nmap <leader>bp :b# <CR>
nmap <leader>B :call SwitchFileMarker(1)<CR>

nnoremap <leader><c-]> :YcmCompleter GoTo<CR>zv
nnoremap <leader>k :YcmCompleter GoTo<CR>zv

" unmap this annoying thing
nnoremap <C-w><C-o> nop
nnoremap <C-w>o nop

" yank full path
if has('win32')
	nnoremap <leader>yp :let g:thecurrentfilepath = substitute(expand("%:p"), '/', '\', 'g')<CR>:let @"=g:thecurrentfilepath<CR>:let @+=g:thecurrentfilepath<CR>
else
	nnoremap <leader>yp :let @"=expand("%:p")<CR>:let @+=expand("%:p")<CR>
endif

" yank file name
nnoremap <leader>yf :let @"=expand("%:t")<CR>:let @+=expand("%:t")<CR>
nnoremap <leader>ye yg_
" yank file name and line number
nnoremap <leader>yn :let @"=expand("%:p").":".getpos('.')[1]<CR>
nnoremap <leader>yb :let @"="b ".expand("%:p").":".getpos('.')[1]."\n"<CR>

" jump between closed folds

nnoremap <silent> zJ :call NextClosedFold('j')<cr>
nnoremap <silent> zK :call NextClosedFold('k')<cr>

" resize a fold
nnoremap <leader>zk :call ShrinkFoldTop('top')<cr>
nnoremap <leader>zj :call ShrinkFoldTop('bottom')<cr>
nnoremap <leader>z, :call ShrinkFoldBottom('top')<cr>
nnoremap <leader>zm :call ShrinkFoldBottom('bottom')<cr>
nnoremap <leader>zs :setlocal foldexpr=SearchFold(10) foldmethod=expr foldlevel=0 foldcolumn=2<CR>
" easymotion
" <Leader>q{char} to move to {char}
" map  <Leader>ef <Plug>(easymotion-bd-f)
" nmap <Leader>ef <Plug>(easymotion-overwin-f)
nnoremap <leader>ls :call SelectLastModifiedTextRegion()<cr>
" add to location list
nnoremap <leader>la :laddexpr expand("%").":".getpos('.')[1].":".(len(getline("."))?getline("."):"---")<cr>:call LLSigns()<cr>
" clear location list
nnoremap <leader>lc :call setloclist(0,[])<cr>:call LLSigns()<cr>
nnoremap <leader>lr :call RemoveFromLocationList()<cr>:call LLSigns()<cr>
nnoremap <leader>lt :ltag <c-r>=expand("<cword>")<CR> \| 3lopen<CR>
nnoremap ]w :lnext <CR>zv
nnoremap [w :lprevious <CR>zv
" set the location list of the current window to the current quickfix list
nnoremap <leader>ql :call setloclist(winnr(), getqflist(), 'r')<CR>
" nnoremap <leader>ww :ll <CR>zv

nnoremap <leader>pf :echo expand("%")<cr>

" run the current line as a command
nnoremap <leader>cm yy:<c-r>"

" s{char}{char} to move to {char}{char}
" nmap s <Plug>(easymotion-overwin-f2)

" Move to line
" map <Leader>eL1 <Plug>(easymotion-bd-jk)
" nmap <Leader>eL2 <Plug>(easymotion-overwin-line)

" Move to word
" map  <Leader>ew1 <Plug>(easymotion-bd-w)
nmap <c-s> <Plug>(easymotion-overwin-w)
nmap s <Plug>(easymotion-overwin-f2)
nnoremap <leader>gl :Git log --date-order --decorate --all --oneline --graph
" recently used of type specified
nnoremap <leader>ru :filter /\.*/ ls t<left><left><left><left><left><left>

" # # # # # # # # # # # # # # # # # # # # # # # #
" #   V I S U A L  M O D E  M A P P I N G S     #
" # # # # # # # # # # # # # # # # # # # # # # # #

" space key does nothing
vnoremap <leader>vd :VDiffthis<CR>
vnoremap <SPACE> <Nop>
" moving indentation easier
vnoremap < <gv
vnoremap > >gv
" search for highlighted string without regex
vnoremap <leader>ff yb/\V<C-r>"<Cr>
" add word to search pattern
vnoremap <leader>fa yb/<C-R>/\\|\V<C-r>"<CR>
" add key for copying to clipboard
" remember to install : vim-gtk first or it wont work
vnoremap <leader>y "+y
" grep
vnoremap <leader>gg y:call MyGrep('-rI', "<C-R>"")<cr>
" grep
vnoremap <leader>gr y:call MyGrepSilent('-rI', "<C-R>"")<cr>
" send stack trace to quickfix
vnoremap <leader>qq :cgetbuffer<CR> :call ProcessQF()<CR>
" get the stack trace, only filter QuickFixBufferListedOnly
vnoremap <leader>qv :cgetbuffer<CR> :call QuickFixBufferListedOnly()<CR>
" remove whitespace in visual selection
vnoremap <leader>rw :s/\s\+$//e<CR>
" '<,'>s/\s\+$//e
vnoremap <leader>/ /\%V

" # # # # # # # # # # # # # # # # # # # # # # # #
" #   I N S E R T  M O D E  M A P P I N G S     #
" # # # # # # # # # # # # # # # # # # # # # # # #

" automatic closing brackets
inoremap ;" ""<left>
inoremap ;' ''<left>
inoremap ;[ []<left>
inoremap ;{ {}<left>
inoremap ;( ()<left>
inoremap ;< <><left>
" jump points
" set ctrl + c identica l to ctrl+[
" inoremap <c-c> <Esc>
" exit insert mode
inoremap <c-k> <c-c>
" inoremap <silent> <c-l>=pumvisible() ? "\<C-y>" : "\<Esc>"<CR>
" inoremap <c-l>=pumvisible() ? "<C-l>" : "<Left>"<CR>
inoremap <A-f> <Right>
inoremap <A-b> <Left>

imap <c-x><c-m> <plug>(fzf-complete-line)

inoremap <c-f> <Right>
inoremap <c-b> <Left>

" insert current file name into command
cmap <A-F> <C-r>=expand("%:t")<CR>
cmap <A-t> <Home>TabMessage <End>

" # # # # # # # # # # # # # # # # # # # # # # # # #
" #   C O M M A N D  M O D E  M A P P I N G S     #
" # # # # # # # # # # # # # # # # # # # # # # # # #

" left and right keys in command mode
cmap <A-f> <Right>
cmap <A-b> <Left>

cmap <A-w> \<
cmap <A-e> \>
" greedy regex nearest match
cmap <C-s> .\{-}
" include newlines
cmap <C-s> \_.\{-}

cmap <A-C-n> ^.\+\(^.*notmatching.*$\)\@<!$


" neovim specific mappings
" exit any window in any mode with alt key
" tnoremap <A-h> <C-\><C-N><C-w>h
" tnoremap <A-j> <C-\><C-N><C-w>j
" tnoremap <A-k> <C-\><C-N><C-w>k
" tnoremap <A-l> <C-\><C-N><C-w>l
" tnoremap <A-n> <C-\><C-N>

" terminal
" move to previous window
tnoremap <C-w>p <C-\><C-N><C-w><C-p>
tnoremap <C-w><C-p> <C-\><C-N><C-w><C-p>

" move to left window
tnoremap <C-w>h <C-\><C-N><C-w><C-h>
tnoremap <C-w><C-h> <C-\><C-N><C-w><C-h>


" move to right window
tnoremap <C-w>l <C-\><C-N><C-w><C-l>
tnoremap <C-w><C-l> <C-\><C-N><C-w><C-l>


" move to window above
tnoremap <C-w>k <C-\><C-N><C-w><C-k>
tnoremap <C-w><C-k> <C-\><C-N><C-w><C-k>


" move to window below
tnoremap <C-w>j <C-\><C-N><C-w><C-j>
tnoremap <C-w><C-j> <C-\><C-N><C-w><C-j>

" terminal
" switch to normal mode
" tnoremap <C-w>N <C-\><C-N>
tnoremap <C-w>n <C-\><C-N>
tnoremap <C-w><C-n> <C-\><C-N>


" inoremap <A-h> <C-\><C-N><C-w>h
" inoremap <A-j> <C-\><C-N><C-w>j
" inoremap <A-k> <C-\><C-N><C-w>k
" inoremap <A-l> <C-\><C-N><C-w>l
" nnoremap <A-h> <C-w>h
" nnoremap <A-j> <C-w>j
" nnoremap <A-k> <C-w>k
" nnoremap <A-l> <C-w>l


" quick ctrl+E / Y
" nnoremap <C-A-e> 5<C-e>
" nnoremap <C-A-y> 5<C-y>

" " quick move
" nnoremap <A-k> 5k
" nnoremap <A-j> 5j

" terminal for running last command
fun! RunBuffer()

	" echo stridx("term", bufname("%"))
	if stridx(bufname("%"),"term") == -1 && exists("g:run_buffer_number")
		" set marks for current screen position
		:execute ":w"
		:execute ":split"

		" switch to buffer
		:execute ":b ".g:run_buffer_number
		" run the last command
		call feedkeys("a")
		call feedkeys("\<ESC>"."k"."\<CR>")

		" go to normal mode
		call feedkeys("\<C-\>"."\<C-N>")
		" close window
		call feedkeys(":q"."\<CR>")

	endif


endfun
fun! GetQFFromBuffer()

	" echo stridx("term", bufname("%"))
	if stridx(bufname("%"),"term") == -1 && exists("g:run_buffer_number")

		" check if semantic highlighting is set
		let s:set_semantic = 0
		if exists('b:semanticOn')
			if b:semanticOn == 1
				let s:set_semantic = 1
			endif
		endif

		" set marks for current screen position
		:execute ":w"
		:execute "normal! msHmt"

		" switch to buffer
		:execute ":b ".g:run_buffer_number
		" run the last command
		:execute "normal! G$"
		:execute "normal! ?zompc"."\<CR>"
		:execute "normal! V"
		:execute "normal! ?zompc"."\<CR>"
		call feedkeys(":cgetbuffer"."\<CR>")

		" return to original position
		call feedkeys(":b#\<CR>")
		" call feedkeys("")
		call feedkeys("`tzt`s")
		call feedkeys(":call QuickFixBufferListedOnly()\<CR>")

		if s:set_semantic == 1
			" :execute ":SemanticHighlight"
			call feedkeys(":SemanticHighlight\<CR>")
		endif

	endif


endfun

function! TabMessage(cmd)
  let message = ":".a:cmd."\n"
  redir =>> message
  silent execute a:cmd
  redir END
  if empty(message)
    echoerr "no output"
  else
    " use "new" instead of "tabnew" below if you prefer split windows instead of tabs
    tabnew
    setlocal buftype=nofile bufhidden=wipe noswapfile nobuflisted nomodified
    silent put=message
    norm gg
  endif
endfunction

command! -nargs=+ -complete=command TabMessage call TabMessage(<q-args>)

fun! SetRunBuffer()
	let g:run_buffer_number = bufnr('%')
endfun

" rerun terminal command
" tnoremap <A-r> <ESC>k<CR><C-\><C-N> :call SetRunBuffer()<CR>a
" nnoremap <A-r> :call RunBuffer()<CR>

" tnoremap <C-r> <ESC>k<CR><C-\><C-N> :call SetRunBuffer()<CR>a
nnoremap <leader>rb :call RunBuffer()<CR>
nnoremap <leader>qq :call GetQFFromBuffer()<CR>

" nnoremap <A-C-j> 5j
" nnoremap <A-C-k> 5k
inoremap <A-o> <Esc>

" switch tabs
nnoremap <A-C-h> gT
nnoremap <A-C-l> gt
nnoremap <A-t> :tabe<CR>


" insert mode on enter terminal
" autocmd bufenter * if &buftype == 'terminal' | :startinsert | endif
"

" mappings for normal mode of terminal
function! Terminalthings()
	nnoremap <buffer> r a<ESC>k<CR><C-\><C-N>
	nnoremap <buffer> <leader>nn yiwa<ESC><ESC>VVn<C-\><C-N>pa<CR>
endfunction
augroup TerminalNormalModeMappings
	autocmd!
	autocmd TermOpen * call Terminalthings()
augroup END

" resizing windows
nnoremap <A-k> 4<C-w>+
nnoremap <A-j> 4<C-w>-
nnoremap <A-l> 10<C-w>>
nnoremap <A-h> 10<C-w><

" horizontal scroll
set virtualedit=all
nnoremap <A-H> 5zh
nnoremap <A-L> 5zl

" # # # # # # # # # # # # # # # # # # # # #
" # ALL THE WINDOWS SPECIFIC COMMANDS # # #
" # # # # # # # # # # # # # # # # # # # # #
if !has('win32')
	" we're on linux
	set shell=/bin/bash
	autocmd CursorHold * :call AutoSave()
	set diffopt+=linematch:800

	" if we're on a mounted drive: uncomment these to use git and grep
	" let g:fugitive_git_executable = '/mnt/c/PROGRA~1/Git/cmd/git.exe'
	" set grepprg=/mnt/c/cygwin64/bin/grep.exe\ -nH
else
	"we're on windows
	autocmd CursorHold * :call AutoSave()
	set grepprg=C:\cygwin64\bin\grep.exe\ -nH
	" nnoremap <leader>aa yiw :grep -riw <C-R>"<CR>
	" set shell=C:\\WINDOWS\\System32\\WindowsPowerShell\\v1.0\\powershell.exe
	" set shellcmdflag=-c
endif
" let $PATH .= ';' . '/mnt/c/Program\ Files/Git/bin/'
" for using on windows mounted directory
