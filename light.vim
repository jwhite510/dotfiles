let mapleader=" "

" recently used of type specified
nnoremap <leader>ru :filter /\.*/ ls t<left><left><left><left><left><left>

hi        DiffAdd                      ctermfg=NONE      ctermbg=22   cterm=NONE
hi        DiffDelete                   ctermfg=57        ctermbg=NONE cterm=NONE
hi        DiffChange                   ctermfg=NONE      ctermbg=NONE cterm=NONE
hi        DiffText                     ctermfg=NONE      ctermbg=18   cterm=NONE

" run the current line as a command
nnoremap <leader>cm yy:<c-r>"

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

function! TabMessage(cmd)
  let message = ":".a:cmd."\n"
  redir =>> message
  silent execute a:cmd
  redir END
  if empty(message)
    echoerr "no output"
  else
    " use "new" instead of "tabnew" below if you prefer split windows instead of tabs
    new
    setlocal buftype=nofile bufhidden=wipe noswapfile nobuflisted nomodified
    silent put=message
    norm gg
  endif
endfunction

command! -nargs=+ -complete=command TabMessage call TabMessage(<q-args>)
cmap <A-t> <Home>TabMessage <End>

nnoremap <leader><c-w> :call WrapCmd()<CR>

nnoremap <leader>tc :tabclose<CR>
nnoremap <leader>pw :pwd<CR>
nnoremap <leader>pf :echo expand("%")<cr>
if has('win32')
	nnoremap <leader>yp :let g:thecurrentfilepath = substitute(expand("%:p"), '/', '\', 'g')<CR>:let @"=g:thecurrentfilepath<CR>:let @+=g:thecurrentfilepath<CR>
else
	nnoremap <leader>yp :let @"=expand("%:p")<CR>:let @+=expand("%:p")<CR>
endif

nnoremap <leader>io :diffoff<CR>
nnoremap <leader>iO :diffoff!<CR>
nnoremap <leader>it :diffthis<CR>
nnoremap <A-t> :tabe<CR>

" switch tabs
nnoremap <A-C-h> gT
nnoremap <A-C-l> gt

nnoremap <leader>ic :set ic! ic?<CR>

nnoremap <leader>nu :set invnumber<CR>
nnoremap <leader>nr :set relativenumber!<CR>

nnoremap [q :cprev <CR>zv
nnoremap ]q :cnext <CR>zv
nnoremap ]t :tnext <CR>
nnoremap [t :tprev <CR>
nnoremap <leader>ts :tsel <CR>
nnoremap [Q :cfirst <CR>zv
nnoremap ]Q :clast <CR>zv

nnoremap <leader>fl :call SearchWordsOnLine()<cr>
nnoremap <leader>ff viwyb/\<<C-R>"\><CR>
" space key doesnt do anything
nnoremap <leader>fa viwyb/<C-R>/\\|\<<C-R>"\><CR>
" remove most recently added seach item
nnoremap <leader>fr msHmt/<C-P><C-F>F\|hd$<CR>`tzt`s
" set search to previously searched pattern
nnoremap <leader>fp msHmt/<C-p><C-p><CR>`tzt`s

nnoremap <leader>fi :set foldmethod=indent<cr>
nnoremap <leader>fm :set foldmethod=manual<cr>

vnoremap <leader>ff yb/\V<C-r>"<Cr>
vnoremap <leader>fa yb/<C-R>/\\|\V<C-r>"<CR>

" automatic closing brackets
inoremap ;" ""<left>
inoremap ;' ''<left>
inoremap ;[ []<left>
inoremap ;{ {}<left>
inoremap ;( ()<left>
inoremap ;< <><left>

set noea
set incsearch
set mouse=
set grepprg=findstr\ /spin\ /c:$*
" resizing windows
nnoremap <A-k> 4<C-w>+
nnoremap <A-j> 4<C-w>-
nnoremap <A-l> 10<C-w>>
nnoremap <A-h> 10<C-w><
set virtualedit=all
" break indent level matching
set breakindent
set showbreak=--
" break at word not character
set linebreak
set display +=lastline
nnoremap <A-H> 5zh
nnoremap <A-L> 5zl
nnoremap <leader>cp :call OpenFileBrowser()<CR>

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
nnoremap <leader>zs :setlocal foldexpr=SearchFold(10) foldmethod=expr foldlevel=0 foldcolumn=2<CR>
nnoremap <leader>mv :mkview<cr>
nnoremap <leader>lv :loadview<cr>

nnoremap <C-p> :norm! [{<cr>
