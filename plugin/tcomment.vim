" tComment.vim -- An easily extensible & universal comment plugin 
" @Author:      Tom Link (micathom AT gmail com)
" @License:     GPL (see http://www.gnu.org/licenses/gpl.txt)
" @Created:     27-Dez-2004.
" @Last Change: 2014-02-05.
" @Revision:    797
" GetLatestVimScripts: 1173 1 tcomment.vim

if &cp || exists('loaded_tcomment')
    finish
endif
let loaded_tcomment = 300

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

if !exists("g:tcommentMapLeaderOp2")
    " See |tcomment-operator|.
    let g:tcommentMapLeaderOp2 = 'gC' "{{{2
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
command! -bang -range -nargs=* -complete=customlist,tcomment#CompleteArgs TComment
            \ keepjumps call tcomment#Comment(<line1>, <line2>, 'G', "<bang>", <f-args>)

" :display: :[range]TCommentAs[!] commenttype ?ARGS...
" TCommentAs requires g:tcomment_{filetype} to be defined.
" With a bang '!', always comment the line.
"
" ARGS... are either (see also |tcomment#Comment()|):
"   1. a list of key=value pairs
"   2. 1-2 values for: ?commentBegin, ?commentEnd
command! -bang -complete=customlist,tcomment#Complete -range -nargs=+ TCommentAs 
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
command! -bang -range -nargs=* -complete=customlist,tcomment#CompleteArgs TCommentRight
            \ keepjumps call tcomment#Comment(<line1>, <line2>, 'R', "<bang>", <f-args>)

" :display: :[range]TCommentBlock[!] ?ARGS...
" Comment as "block", e.g. use the {&ft}_block comment style. The 
" commented text isn't indented or reformated.
" With a bang '!', always comment the line.
"
" ARGS... are either (see also |tcomment#Comment()|):
"   1. a list of key=value pairs
"   2. 1-2 values for: ?commentBegin, ?commentEnd
command! -bang -range -nargs=* -complete=customlist,tcomment#CompleteArgs TCommentBlock
            \ keepjumps call tcomment#Comment(<line1>, <line2>, 'B', "<bang>", <f-args>)

" :display: :[range]TCommentInline[!] ?ARGS...
" Use the {&ft}_inline comment style.
" With a bang '!', always comment the line.
"
" ARGS... are either (see also |tcomment#Comment()|):
"   1. a list of key=value pairs
"   2. 1-2 values for: ?commentBegin, ?commentEnd
command! -bang -range -nargs=* -complete=customlist,tcomment#CompleteArgs TCommentInline
            \ keepjumps call tcomment#Comment(<line1>, <line2>, 'I', "<bang>", <f-args>)

" :display: :[range]TCommentMaybeInline[!] ?ARGS...
" With a bang '!', always comment the line.
"
" ARGS... are either (see also |tcomment#Comment()|):
"   1. a list of key=value pairs
"   2. 1-2 values for: ?commentBegin, ?commentEnd
command! -bang -range -nargs=* -complete=customlist,tcomment#CompleteArgs TCommentMaybeInline
            \ keepjumps call tcomment#Comment(<line1>, <line2>, 'i', "<bang>", <f-args>)



exec 'noremap <Plug>TComment-<c-_><c-_> :TComment<cr>'
exec 'vnoremap <Plug>TComment-<c-_><c-_> :TCommentMaybeInline<cr>'
exec 'inoremap <Plug>TComment-<c-_><c-_> <c-o>:TComment<cr>'
exec 'noremap <Plug>TComment-<c-_>p m`vip:TComment<cr>``'
exec 'inoremap <Plug>TComment-<c-_>p <c-o>:norm! m`vip<cr>:TComment<cr><c-o>``'
exec 'noremap <Plug>TComment-<c-_><space> :TComment '
exec 'inoremap <Plug>TComment-<c-_><space> <c-o>:TComment '
exec 'inoremap <Plug>TComment-<c-_>r <c-o>:TCommentRight<cr>'
exec 'noremap <Plug>TComment-<c-_>r :TCommentRight<cr>'
exec 'vnoremap <Plug>TComment-<c-_>i :TCommentInline<cr>'
exec 'noremap <Plug>TComment-<c-_>i v:TCommentInline mode=I#<cr>'
exec 'inoremap <Plug>TComment-<c-_>i <c-\><c-o>v:TCommentInline mode=#<cr>'
exec 'noremap <Plug>TComment-<c-_>b :TCommentBlock<cr>'
exec 'inoremap <Plug>TComment-<c-_>b <c-o>:TCommentBlock<cr>'
exec 'noremap <Plug>TComment-<c-_>a :TCommentAs '
exec 'inoremap <Plug>TComment-<c-_>a <c-o>:TCommentAs '
exec 'noremap <Plug>TComment-<c-_>n :TCommentAs <c-r>=&ft<cr> '
exec 'inoremap <Plug>TComment-<c-_>n <c-o>:TCommentAs <c-r>=&ft<cr> '
exec 'noremap <Plug>TComment-<c-_>s :TCommentAs <c-r>=&ft<cr>_'
exec 'inoremap <Plug>TComment-<c-_>s <c-o>:TCommentAs <c-r>=&ft<cr>_'
exec 'noremap <Plug>TComment-<c-_>cc :<c-u>call tcomment#SetOption("count", v:count1)<cr>'
exec 'noremap <Plug>TComment-<c-_>ca :<c-u>call tcomment#SetOption("as", input("Comment as: ", &filetype, "customlist,tcomment#Complete"))<cr>'
for s:i in range(1, 9)
    exec 'noremap <Plug>TComment-<c-_>' . s:i . ' :TComment count='. s:i .'<cr>'
    exec 'inoremap <Plug>TComment-<c-_>' . s:i . ' <c-\><c-o>:TComment count='. s:i .'<cr>'
    exec 'vnoremap <Plug>TComment-<c-_>' . s:i . ' :TCommentMaybeInline count='. s:i .'<cr>'
endfor
unlet s:i


exec 'noremap <Plug>TComment-<Leader>__ :TComment<cr>'
exec 'xnoremap <Plug>TComment-<Leader>__ :TCommentMaybeInline<cr>'
exec 'noremap <Plug>TComment-<Leader>_p vip:TComment<cr>'
exec 'noremap <Plug>TComment-<Leader>_<space> :TComment '
exec 'xnoremap <Plug>TComment-<Leader>_i :TCommentInline<cr>'
exec 'noremap <Plug>TComment-<Leader>_r :TCommentRight<cr>'
exec 'noremap <Plug>TComment-<Leader>_b :TCommentBlock<cr>'
exec 'noremap <Plug>TComment-<Leader>_a :TCommentAs '
exec 'noremap <Plug>TComment-<Leader>_n :TCommentAs <c-r>=&ft<cr> '
exec 'noremap <Plug>TComment-<Leader>_s :TCommentAs <c-r>=&ft<cr>_'

exec 'nnoremap <silent> <Plug>TComment-gc :<c-u>if v:count > 0 \| call tcomment#SetOption("count", v:count) \| endif \| let w:tcommentPos = getpos(".") \| set opfunc=tcomment#Operator<cr>g@'
for s:i in range(1, 9)
    exec 'nnoremap <silent> <Plug>TComment-gc' . s:i .'c :let w:tcommentPos = getpos(".") \| call tcomment#SetOption("count", '. s:i .') \| set opfunc=tcomment#Operator<cr>g@'
endfor
unlet s:i
exec 'nnoremap <silent> <Plug>TComment-gcc :<c-u>if v:count > 0 \| call tcomment#SetOption("count", v:count) \| endif \| let w:tcommentPos = getpos(".") \| set opfunc=tcomment#OperatorLine<cr>g@$'
exec 'nnoremap <silent> <Plug>TComment-gcb :<c-u>if v:count > 0 \| call tcomment#SetOption("count", v:count) \| endif \| let w:tcommentPos = getpos(".") \| call tcomment#SetOption("mode_extra", "B") \| set opfunc=tcomment#OperatorLine<cr>g@'
exec 'xnoremap <Plug>TComment-gc :TCommentMaybeInline<cr>'


exec 'nnoremap <silent> <Plug>TComment-gC :let w:tcommentPos = getpos(".") \| set opfunc=tcomment#OperatorAnyway<cr>g@'
exec 'nnoremap <silent> <Plug>TComment-gCc :let w:tcommentPos = getpos(".") \| set opfunc=tcomment#OperatorLineAnyway<cr>g@$'
exec 'nnoremap <silent> <Plug>TComment-gCb :let w:tcommentPos = getpos(".") \| call tcomment#SetOption("mode_extra", "B") \| set opfunc=tcomment#OperatorLine<cr>g@'
exec 'xnoremap <Plug>TComment-gC :TCommentMaybeInline!<cr>'


exec 'vnoremap <Plug>TComment-ic :<c-U>call tcomment#TextObjectInlineComment()<cr>'
exec 'omap <Plug>TComment-ic :normal v <Plug>TComment-ic <cr>'


if g:tcommentMaps
    if g:tcommentMapLeader1 != ''
        exec 'map '. g:tcommentMapLeader1 . g:tcommentMapLeader1 .' <Plug>TComment-<c-_><c-_>'
        exec 'vmap '. g:tcommentMapLeader1 . g:tcommentMapLeader1 .' <Plug>TComment-<c-_><c-_>'
        exec 'imap '. g:tcommentMapLeader1 . g:tcommentMapLeader1 .' <Plug>TComment-<c-_><c-_>'
        exec 'map '. g:tcommentMapLeader1 .'p <Plug>TComment-<c-_>p'
        exec 'imap '. g:tcommentMapLeader1 .'p <Plug>TComment-<c-_>p'
        exec 'map '. g:tcommentMapLeader1 .'<space> <Plug>TComment-<c-_><space>'
        exec 'imap '. g:tcommentMapLeader1 .'<space> <Plug>TComment-<c-_><space>'
        exec 'imap '. g:tcommentMapLeader1 .'r <Plug>TComment-<c-_>r'
        exec 'map '. g:tcommentMapLeader1 .'r <Plug>TComment-<c-_>r'
        exec 'vmap '. g:tcommentMapLeader1 .'i <Plug>TComment-<c-_>i'
        exec 'map '. g:tcommentMapLeader1 .'i <Plug>TComment-<c-_>i'
        exec 'imap '. g:tcommentMapLeader1 .'i <Plug>TComment-<c-_>i'
        exec 'map '. g:tcommentMapLeader1 .'b <Plug>TComment-<c-_>b'
        exec 'imap '. g:tcommentMapLeader1 .'b <Plug>TComment-<c-_>b'
        exec 'map '. g:tcommentMapLeader1 .'a <Plug>TComment-<c-_>a'
        exec 'imap '. g:tcommentMapLeader1 .'a <Plug>TComment-<c-_>a'
        exec 'map '. g:tcommentMapLeader1 .'n <Plug>TComment-<c-_>n'
        exec 'imap '. g:tcommentMapLeader1 .'n <Plug>TComment-<c-_>n'
        exec 'map '. g:tcommentMapLeader1 .'s <Plug>TComment-<c-_>s'
        exec 'imap '. g:tcommentMapLeader1 .'s <Plug>TComment-<c-_>s'
        exec 'map '. g:tcommentMapLeader1 .'cc <Plug>TComment-<c-_>cc'
        exec 'map '. g:tcommentMapLeader1 .'ca <Plug>TComment-<c-_>ca'
        for s:i in range(1, 9)
            exec 'map '. g:tcommentMapLeader1 . s:i .' <Plug>TComment-<c-_>'.s:i
            exec 'imap '. g:tcommentMapLeader1 . s:i .' <Plug>TComment-<c-_>'.s:i
            exec 'vmap '. g:tcommentMapLeader1 . s:i .' <Plug>TComment-<c-_>'.s:i
        endfor
        unlet s:i
    endif
    if g:tcommentMapLeader2 != ''
        exec 'map '. g:tcommentMapLeader2 .'_ <Plug>TComment-<Leader>__'
        exec 'xmap '. g:tcommentMapLeader2 .'_ <Plug>TComment-<Leader>__'
        exec 'map '. g:tcommentMapLeader2 .'p <Plug>TComment-<Leader>_p'
        exec 'map '. g:tcommentMapLeader2 .'<space> <Plug>TComment-<Leader>_<space>'
        exec 'xmap '. g:tcommentMapLeader2 .'i <Plug>TComment-<Leader>_i'
        exec 'map '. g:tcommentMapLeader2 .'r <Plug>TComment-<Leader>_r'
        exec 'map '. g:tcommentMapLeader2 .'b <Plug>TComment-<Leader>_b'
        exec 'map '. g:tcommentMapLeader2 .'a <Plug>TComment-<Leader>_a'
        exec 'map '. g:tcommentMapLeader2 .'n <Plug>TComment-<Leader>_n'
        exec 'map '. g:tcommentMapLeader2 .'s <Plug>TComment-<Leader>_s'
    endif
    if g:tcommentMapLeaderOp1 != ''
        exec 'nmap <silent> '. g:tcommentMapLeaderOp1 .' <Plug>TComment-gc'
        for s:i in range(1, 9)
            exec 'nmap <silent> '. g:tcommentMapLeaderOp1 . s:i .' <Plug>TComment-gc'.s:i
        endfor
        unlet s:i
        exec 'nmap <silent> '. g:tcommentMapLeaderOp1 .'c <Plug>TComment-gcc'
        exec 'nmap <silent> '. g:tcommentMapLeaderOp1 .'b <Plug>TComment-gcb'
        exec 'xmap '. g:tcommentMapLeaderOp1 .' <Plug>TComment-gc'
    endif
   if g:tcommentMapLeaderOp2 != ''
        exec 'nmap <silent> '. g:tcommentMapLeaderOp2 .' <Plug>TComment-gC'
        exec 'nmap <silent> '. g:tcommentMapLeaderOp2 .'c <Plug>TComment-gCc'
        exec 'nmap <silent> '. g:tcommentMapLeaderOp2 .'b <Plug>TComment-gCb'
        exec 'xmap '. g:tcommentMapLeaderOp2 .' <Plug>TComment-gC'
    endif
    if g:tcommentTextObjectInlineComment != ''
        exec 'vmap' g:tcommentTextObjectInlineComment ' <Plug>TComment-ic'
        exec 'omap' g:tcommentTextObjectInlineComment ' <Plug>TComment-ic'
    endif
endif


let &cpo = s:save_cpo
unlet s:save_cpo
" vi: ft=vim:tw=72:ts=4:fo=w2croql
