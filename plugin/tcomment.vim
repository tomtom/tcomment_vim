" tComment.vim -- An easily extensible & universal comment plugin 
" @Author:      Tom Link (micathom AT gmail com)
" @License:     GPL (see http://www.gnu.org/licenses/gpl.txt)
" @Created:     27-Dez-2004.
" @Last Change: 2014-06-30.
" @Revision:    919
" GetLatestVimScripts: 1173 1 tcomment.vim

if &cp || exists('loaded_tcomment')
    finish
endif
let loaded_tcomment = 304

let s:save_cpo = &cpo
set cpo&vim


if !exists('g:tcommentMaps')
    " If true, set maps.
    let g:tcommentMaps = 1   "{{{2
endif

if !exists("g:tcommentMapLeader1")
    " g:tcommentMapLeader1 should be a shortcut that can be used with 
    " map, imap, vmap.
    let g:tcommentMapLeader1 = '<c-_>' "{{{2
endif

if !exists("g:tcommentMapLeader2")
    " g:tcommentMapLeader2 should be a shortcut that can be used with 
    " map, xmap.
    let g:tcommentMapLeader2 = '<Leader>_' "{{{2
endif

if !exists("g:tcommentMapLeaderOp1")
    " See |tcomment-operator|.
    let g:tcommentMapLeaderOp1 = 'gc' "{{{2
endif

if !exists("g:tcommentMapLeaderUncommentAnyway")
    " See |tcomment-operator|.
    let g:tcommentMapLeaderUncommentAnyway = 'g<' "{{{2
endif

if !exists("g:tcommentMapLeaderCommentAnyway")
    " See |tcomment-operator|.
    let g:tcommentMapLeaderCommentAnyway = 'g>' "{{{2
endif

if !exists('g:tcommentTextObjectInlineComment')
    let g:tcommentTextObjectInlineComment = 'ic'   "{{{2
endif


" :display: :[range]TComment[!] ?ARGS...
" If there is a visual selection that begins and ends in the same line, 
" then |:TCommentInline| is used instead.
" The optional range defaults to the current line. With a bang '!', 
" always comment the line.
"
" ARGS... are either (see also |tcomment#Comment()|):
"   1. a list of key=value pairs
"   2. 1-2 values for: ?commentBegin, ?commentEnd
command! -bar -bang -range -nargs=* -complete=customlist,tcomment#CompleteArgs TComment
            \ keepjumps call tcomment#Comment(<line1>, <line2>, 'G', "<bang>", <f-args>)

" :display: :[range]TCommentAs[!] commenttype ?ARGS...
" TCommentAs requires g:tcomment_{filetype} to be defined.
" With a bang '!', always comment the line.
"
" ARGS... are either (see also |tcomment#Comment()|):
"   1. a list of key=value pairs
"   2. 1-2 values for: ?commentBegin, ?commentEnd
command! -bar -bang -complete=customlist,tcomment#Complete -range -nargs=+ TCommentAs 
            \ call tcomment#CommentAs(<line1>, <line2>, "<bang>", <f-args>)

" :display: :[range]TCommentRight[!] ?ARGS...
" Comment the text to the right of the cursor. If a visual selection was 
" made (be it block-wise or not), all lines are commented out at from 
" the current cursor position downwards.
" With a bang '!', always comment the line.
"
" ARGS... are either (see also |tcomment#Comment()|):
"   1. a list of key=value pairs
"   2. 1-2 values for: ?commentBegin, ?commentEnd
command! -bar -bang -range -nargs=* -complete=customlist,tcomment#CompleteArgs TCommentRight
            \ keepjumps call tcomment#Comment(<line1>, <line2>, 'R', "<bang>", <f-args>)

" :display: :[range]TCommentBlock[!] ?ARGS...
" Comment as "block", e.g. use the {&ft}_block comment style. The 
" commented text isn't indented or reformated.
" With a bang '!', always comment the line.
"
" ARGS... are either (see also |tcomment#Comment()|):
"   1. a list of key=value pairs
"   2. 1-2 values for: ?commentBegin, ?commentEnd
command! -bar -bang -range -nargs=* -complete=customlist,tcomment#CompleteArgs TCommentBlock
            \ keepjumps call tcomment#Comment(<line1>, <line2>, 'B', "<bang>", <f-args>)

" :display: :[range]TCommentInline[!] ?ARGS...
" Use the {&ft}_inline comment style.
" With a bang '!', always comment the line.
"
" ARGS... are either (see also |tcomment#Comment()|):
"   1. a list of key=value pairs
"   2. 1-2 values for: ?commentBegin, ?commentEnd
command! -bar -bang -range -nargs=* -complete=customlist,tcomment#CompleteArgs TCommentInline
            \ keepjumps call tcomment#Comment(<line1>, <line2>, 'I', "<bang>", <f-args>)

" :display: :[range]TCommentMaybeInline[!] ?ARGS...
" With a bang '!', always comment the line.
"
" ARGS... are either (see also |tcomment#Comment()|):
"   1. a list of key=value pairs
"   2. 1-2 values for: ?commentBegin, ?commentEnd
command! -bar -bang -range -nargs=* -complete=customlist,tcomment#CompleteArgs TCommentMaybeInline
            \ keepjumps call tcomment#Comment(<line1>, <line2>, 'i', "<bang>", <f-args>)


" command! -range TCommentMap call tcomment#ResetOption() | <args>

noremap <Plug>TComment_<c-_><c-_> :TComment<cr>
vnoremap <Plug>TComment_<c-_><c-_> :TCommentMaybeInline<cr>
inoremap <Plug>TComment_<c-_><c-_> <c-o>:TComment<cr>
noremap <Plug>TComment_<c-_>p m`vip:TComment<cr>``
inoremap <Plug>TComment_<c-_>p <c-o>:norm! m`vip<cr>:TComment<cr><c-o>``
noremap <Plug>TComment_<c-_><space> :TComment 
inoremap <Plug>TComment_<c-_><space> <c-o>:TComment 
inoremap <Plug>TComment_<c-_>r <c-o>:TCommentRight<cr>
noremap <Plug>TComment_<c-_>r :TCommentRight<cr>
vnoremap <Plug>TComment_<c-_>i :TCommentInline<cr>
noremap <Plug>TComment_<c-_>i v:TCommentInline mode=I#<cr>
inoremap <Plug>TComment_<c-_>i <c-\><c-o>v:TCommentInline mode=#<cr>
noremap <Plug>TComment_<c-_>b :TCommentBlock<cr>
inoremap <Plug>TComment_<c-_>b <c-\><c-o>:TCommentBlock mode=#<cr>
noremap <Plug>TComment_<c-_>a :TCommentAs 
inoremap <Plug>TComment_<c-_>a <c-o>:TCommentAs 
noremap <Plug>TComment_<c-_>n :TCommentAs <c-r>=&ft<cr> 
inoremap <Plug>TComment_<c-_>n <c-o>:TCommentAs <c-r>=&ft<cr> 
noremap <Plug>TComment_<c-_>s :TCommentAs <c-r>=&ft<cr>_
inoremap <Plug>TComment_<c-_>s <c-o>:TCommentAs <c-r>=&ft<cr>_
noremap <Plug>TComment_<c-_>cc :<c-u>call tcomment#SetOption("count", v:count1)<cr>
noremap <Plug>TComment_<c-_>ca :<c-u>call tcomment#SetOption("as", input("Comment as: ", &filetype, "customlist,tcomment#Complete"))<cr>

noremap <Plug>TComment_<Leader>__ :TComment<cr>
xnoremap <Plug>TComment_<Leader>__ :TCommentMaybeInline<cr>
noremap <Plug>TComment_<Leader>_p vip:TComment<cr>
noremap <Plug>TComment_<Leader>_<space> :TComment 
xnoremap <Plug>TComment_<Leader>_i :TCommentInline<cr>
noremap <Plug>TComment_<Leader>_r :TCommentRight<cr>
noremap <Plug>TComment_<Leader>_b :TCommentBlock<cr>
noremap <Plug>TComment_<Leader>_a :TCommentAs 
noremap <Plug>TComment_<Leader>_n :TCommentAs <c-r>=&ft<cr> 
noremap <Plug>TComment_<Leader>_s :TCommentAs <c-r>=&ft<cr>_


" function! TCommentOp(type) "{{{3
"     " TLogVAR a:type, v:count
"     " echom "DBG TCommentOp" g:tcomment_ex
"     " echom "DBG TCommentOp" g:tcomment_op
"     exec g:tcomment_ex
"     call call(g:tcomment_op, [a:type])
" endf

function! s:MapOp(name, count, extra, op, invoke) "{{{3
    let extra = empty(a:extra) ? '' : ' \| '. a:extra
    exec printf('nnoremap <silent> <Plug>TComment_%s '.
                \ ':<c-u>if v:count > 0 \| call tcomment#SetOption("count", v:count) \| endif \| let w:tcommentPos = getpos(".")%s \| '.
                \ 'set opfunc=%s<cr>%s',
                \ a:name, extra, a:op, a:invoke)
    " let n = empty(a:count) ? 'v:count' : a:count
    " " let invoke = empty(a:count) ? '<cr>'. a:invoke : ' \| exec "norm ". (v:count > 1 ? v:count : "") ."g@"<cr>'
    " let invoke = '<cr>'. a:invoke
    " exec printf('nnoremap <Plug>TComment_%s '.
    "             \ ':<c-u>let g:tcomment_ex = '':if %s > 0 \| call tcomment#SetOption("count", %s) \| endif \| let w:tcommentPos = getpos(".")%s'' \| '.
    "             \ 'let g:tcomment_op = ''%s'' \| '.
    "             \ 'set opfunc=TCommentOp%s',
    "             \ a:name,
    "             \ n, n, extra,
    "             \ a:op,
    "             \ invoke)
endf

call s:MapOp('Uncomment',  '', 'call tcomment#SetOption("mode_extra", "U")', 'tcomment#OperatorAnyway', 'g@')
call s:MapOp('Uncommentc', '', 'call tcomment#SetOption("mode_extra", "U")', 'tcomment#OperatorLineAnyway', 'g@$')
call s:MapOp('Uncommentb', '', 'call tcomment#SetOption("mode_extra", "UB")', 'tcomment#OperatorLine', 'g@')
xnoremap <silent> <Plug>TComment_Uncomment :<c-u>if v:count > 0 \| call tcomment#SetOption("count", v:count) \| endif \| call tcomment#SetOption("mode_extra", "U") \| '<,'>TCommentMaybeInline<cr>

call s:MapOp('Comment',  '', '', 'tcomment#OperatorAnyway', 'g@')
call s:MapOp('Commentc', '', '', 'tcomment#OperatorLineAnyway', 'g@$')
call s:MapOp('Commentb', '', 'call tcomment#SetOption("mode_extra", "B")', 'tcomment#OperatorLine', 'g@')
xnoremap <silent> <Plug>TComment_Comment :<c-u>if v:count > 0 \| call tcomment#SetOption("count", v:count) \| endif \| '<,'>TCommentMaybeInline!<cr>

vnoremap <Plug>TComment_ic :<c-U>call tcomment#TextObjectInlineComment()<cr>
noremap <Plug>TComment_ic :<c-U>call tcomment#TextObjectInlineComment()<cr>

call s:MapOp('gcc', '', '', 'tcomment#OperatorLine', 'g@$')
call s:MapOp('gcb', '', 'call tcomment#SetOption("mode_extra", "B")', 'tcomment#OperatorLine', 'g@')
xnoremap <Plug>TComment_gc :TCommentMaybeInline<cr>

call s:MapOp('gc', '', '', 'tcomment#Operator', 'g@')

for s:i in range(1, 9)
    exec 'noremap <Plug>TComment_<c-_>' . s:i . ' :call tcomment#SetOption("count", '. s:i .')<cr>'
    exec 'inoremap <Plug>TComment_<c-_>' . s:i . ' <c-\><c-o>:call tcomment#SetOption("count", '. s:i .')<cr>'
    exec 'vnoremap <Plug>TComment_<c-_>' . s:i . ' :call tcomment#SetOption("count", '. s:i .')<cr>'
endfor
for s:i in range(1, 9)
    call s:MapOp('gc' . s:i .'c', s:i, '', 'tcomment#Operator', 'g@')
endfor
unlet s:i

delfun s:MapOp


if g:tcommentMaps
    if g:tcommentMapLeader1 != ''
        exec 'map '. g:tcommentMapLeader1 . g:tcommentMapLeader1 .' <Plug>TComment_<c-_><c-_>'
        exec 'vmap '. g:tcommentMapLeader1 . g:tcommentMapLeader1 .' <Plug>TComment_<c-_><c-_>'
        exec 'imap '. g:tcommentMapLeader1 . g:tcommentMapLeader1 .' <Plug>TComment_<c-_><c-_>'
        exec 'map '. g:tcommentMapLeader1 .'p <Plug>TComment_<c-_>p'
        exec 'imap '. g:tcommentMapLeader1 .'p <Plug>TComment_<c-_>p'
        exec 'map '. g:tcommentMapLeader1 .'<space> <Plug>TComment_<c-_><space>'
        exec 'imap '. g:tcommentMapLeader1 .'<space> <Plug>TComment_<c-_><space>'
        exec 'imap '. g:tcommentMapLeader1 .'r <Plug>TComment_<c-_>r'
        exec 'map '. g:tcommentMapLeader1 .'r <Plug>TComment_<c-_>r'
        exec 'vmap '. g:tcommentMapLeader1 .'i <Plug>TComment_<c-_>i'
        exec 'map '. g:tcommentMapLeader1 .'i <Plug>TComment_<c-_>i'
        exec 'imap '. g:tcommentMapLeader1 .'i <Plug>TComment_<c-_>i'
        exec 'map '. g:tcommentMapLeader1 .'b <Plug>TComment_<c-_>b'
        exec 'imap '. g:tcommentMapLeader1 .'b <Plug>TComment_<c-_>b'
        exec 'map '. g:tcommentMapLeader1 .'a <Plug>TComment_<c-_>a'
        exec 'imap '. g:tcommentMapLeader1 .'a <Plug>TComment_<c-_>a'
        exec 'map '. g:tcommentMapLeader1 .'n <Plug>TComment_<c-_>n'
        exec 'imap '. g:tcommentMapLeader1 .'n <Plug>TComment_<c-_>n'
        exec 'map '. g:tcommentMapLeader1 .'s <Plug>TComment_<c-_>s'
        exec 'imap '. g:tcommentMapLeader1 .'s <Plug>TComment_<c-_>s'
        exec 'map '. g:tcommentMapLeader1 .'cc <Plug>TComment_<c-_>cc'
        exec 'map '. g:tcommentMapLeader1 .'ca <Plug>TComment_<c-_>ca'
        for s:i in range(1, 9)
            exec 'map '. g:tcommentMapLeader1 . s:i .' <Plug>TComment_<c-_>'.s:i
            exec 'imap '. g:tcommentMapLeader1 . s:i .' <Plug>TComment_<c-_>'.s:i
            exec 'vmap '. g:tcommentMapLeader1 . s:i .' <Plug>TComment_<c-_>'.s:i
        endfor
        unlet s:i
    endif
    if g:tcommentMapLeader2 != ''
        exec 'map '. g:tcommentMapLeader2 .'_ <Plug>TComment_<Leader>__'
        exec 'xmap '. g:tcommentMapLeader2 .'_ <Plug>TComment_<Leader>__'
        exec 'map '. g:tcommentMapLeader2 .'p <Plug>TComment_<Leader>_p'
        exec 'map '. g:tcommentMapLeader2 .'<space> <Plug>TComment_<Leader>_<space>'
        exec 'xmap '. g:tcommentMapLeader2 .'i <Plug>TComment_<Leader>_i'
        exec 'map '. g:tcommentMapLeader2 .'r <Plug>TComment_<Leader>_r'
        exec 'map '. g:tcommentMapLeader2 .'b <Plug>TComment_<Leader>_b'
        exec 'map '. g:tcommentMapLeader2 .'a <Plug>TComment_<Leader>_a'
        exec 'map '. g:tcommentMapLeader2 .'n <Plug>TComment_<Leader>_n'
        exec 'map '. g:tcommentMapLeader2 .'s <Plug>TComment_<Leader>_s'
    endif
    if g:tcommentMapLeaderOp1 != ''
        exec 'nmap <silent> '. g:tcommentMapLeaderOp1 .' <Plug>TComment_gc'
        for s:i in range(1, 9)
            exec 'nmap <silent> '. g:tcommentMapLeaderOp1 . s:i .' <Plug>TComment_gc'.s:i
            exec 'nmap <silent> '. g:tcommentMapLeaderOp1 . s:i .'c <Plug>TComment_gc'.s:i.'c'
        endfor
        unlet s:i
        exec 'nmap <silent> '. g:tcommentMapLeaderOp1 .'c <Plug>TComment_gcc'
        exec 'nmap <silent> '. g:tcommentMapLeaderOp1 .'b <Plug>TComment_gcb'
        exec 'xmap '. g:tcommentMapLeaderOp1 .' <Plug>TComment_gc'
    endif
   if g:tcommentMapLeaderUncommentAnyway != ''
        exec 'nmap <silent> '. g:tcommentMapLeaderUncommentAnyway .' <Plug>TComment_Uncomment'
        exec 'nmap <silent> '. g:tcommentMapLeaderUncommentAnyway .'c <Plug>TComment_Uncommentc'
        exec 'nmap <silent> '. g:tcommentMapLeaderUncommentAnyway .'b <Plug>TComment_Uncommentb'
        exec 'xmap '. g:tcommentMapLeaderUncommentAnyway .' <Plug>TComment_Uncomment'
    endif
   if g:tcommentMapLeaderCommentAnyway != ''
        exec 'nmap <silent> '. g:tcommentMapLeaderCommentAnyway .' <Plug>TComment_Comment'
        exec 'nmap <silent> '. g:tcommentMapLeaderCommentAnyway .'c <Plug>TComment_Commentc'
        exec 'nmap <silent> '. g:tcommentMapLeaderCommentAnyway .'b <Plug>TComment_Commentb'
        exec 'xmap '. g:tcommentMapLeaderCommentAnyway .' <Plug>TComment_Comment'
    endif
    if g:tcommentTextObjectInlineComment != ''
        exec 'vmap' g:tcommentTextObjectInlineComment ' <Plug>TComment_ic'
        exec 'omap' g:tcommentTextObjectInlineComment ' <Plug>TComment_ic'
    endif
endif


let &cpo = s:save_cpo
unlet s:save_cpo
" vi: ft=vim:tw=72:ts=4:fo=w2croql
