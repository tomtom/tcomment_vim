" tComment.vim -- An easily extensible & universal comment plugin 
" @Author:      Tom Link (micathom AT gmail com)
" @License:     GPL (see http://www.gnu.org/licenses/gpl.txt)
" @Created:     27-Dez-2004.
" @Last Change: 2018-06-18.
" @Revision:    996
" GetLatestVimScripts: 1173 1 tcomment.vim

if &cp || exists('loaded_tcomment')
    finish
endif
let loaded_tcomment = 400

let s:save_cpo = &cpo
set cpo&vim

call tcomment#deprecated#Check()


if !exists('g:tcomment_maps')
    " If true, set maps.
    let g:tcomment_maps = 1   "{{{2
endif

if !exists("g:tcomment_mapleader1")
    " g:tcomment_mapleader1 should be a shortcut that can be used with 
    " map, imap, vmap.
    let g:tcomment_mapleader1 = '<c-_>' "{{{2
endif

if !exists("g:tcomment_mapleader2")
    " g:tcomment_mapleader2 should be a shortcut that can be used with 
    " map, xmap.
    let g:tcomment_mapleader2 = '<Leader>_' "{{{2
endif

if !exists("g:tcomment_opleader1")
    " See |tcomment-operator|.
    let g:tcomment_opleader1 = 'gc' "{{{2
endif

if !exists("g:tcomment_mapleader_uncomment_anyway")
    " See |tcomment-operator|.
    let g:tcomment_mapleader_uncomment_anyway = 'g<' "{{{2
endif

if !exists("g:tcomment_mapleader_comment_anyway")
    " See |tcomment-operator|.
    let g:tcomment_mapleader_comment_anyway = 'g>' "{{{2
endif

if !exists('g:tcomment_textobject_inlinecomment')
    let g:tcomment_textobject_inlinecomment = 'ic'   "{{{2
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
command! -bar -bang -range -nargs=* -complete=customlist,tcomment#complete#Args TComment
            \ keepjumps call tcomment#Comment(<line1>, <line2>, 'G', "<bang>", <f-args>)

" :display: :[range]TCommentAs[!] commenttype ?ARGS...
" TCommentAs requires g:tcomment_{filetype} to be defined.
" With a bang '!', always comment the line.
"
" ARGS... are either (see also |tcomment#Comment()|):
"   1. a list of key=value pairs
"   2. 1-2 values for: ?commentBegin, ?commentEnd
command! -bar -bang -complete=customlist,tcomment#complete#Complete -range -nargs=+ TCommentAs 
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
command! -bar -bang -range -nargs=* -complete=customlist,tcomment#complete#Args TCommentRight
            \ keepjumps call tcomment#Comment(<line1>, <line2>, 'R', "<bang>", <f-args>)

" :display: :[range]TCommentBlock[!] ?ARGS...
" Comment as "block", e.g. use the {&ft}_block comment style. The 
" commented text isn't indented or reformated.
" With a bang '!', always comment the line.
"
" ARGS... are either (see also |tcomment#Comment()|):
"   1. a list of key=value pairs
"   2. 1-2 values for: ?commentBegin, ?commentEnd
command! -bar -bang -range -nargs=* -complete=customlist,tcomment#complete#Args TCommentBlock
            \ keepjumps call tcomment#Comment(<line1>, <line2>, 'B', "<bang>", <f-args>)

" :display: :[range]TCommentInline[!] ?ARGS...
" Use the {&ft}_inline comment style.
" With a bang '!', always comment the line.
"
" ARGS... are either (see also |tcomment#Comment()|):
"   1. a list of key=value pairs
"   2. 1-2 values for: ?commentBegin, ?commentEnd
command! -bar -bang -range -nargs=* -complete=customlist,tcomment#complete#Args TCommentInline
            \ keepjumps call tcomment#Comment(<line1>, <line2>, 'I', "<bang>", <f-args>)

" :display: :[range]TCommentMaybeInline[!] ?ARGS...
" With a bang '!', always comment the line.
"
" ARGS... are either (see also |tcomment#Comment()|):
"   1. a list of key=value pairs
"   2. 1-2 values for: ?commentBegin, ?commentEnd
command! -bar -bang -range -nargs=* -complete=customlist,tcomment#complete#Args TCommentMaybeInline
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
noremap <Plug>TComment_<c-_>ca :<c-u>call tcomment#SetOption("as", input("Comment as: ", &filetype, "customlist,tcomment#complete#Complete"))<cr>

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


function! s:MapOp(name, extra, op, invoke) "{{{3
    let opfunc = 'TCommentOpFunc_'. substitute(a:name, '[^a-zA-Z0-9_]', '_', 'G')
    let fn = [
                \ 'function! '. opfunc .'(...)',
                \ 'call tcomment#MaybeReuseOptions('. string(opfunc) .')',
                \ a:extra,
                \ 'return call('. string(a:op) .', a:000)',
                \ 'endf'
                \ ]
    exec join(fn, "\n")
    exec printf('nnoremap <silent> <Plug>TComment_%s '.
                \ ':<c-u>call tcomment#ResetOption() \| if v:count > 0 \| call tcomment#SetOption("count", v:count) \| endif \| let w:tcommentPos = getpos(".") \|'.
                \ 'set opfunc=%s<cr>%s',
                \ a:name, opfunc, a:invoke)
endf


call s:MapOp('Uncomment',  'call tcomment#SetOption("mode_extra", "U")', 'tcomment#operator#Op', 'g@')
call s:MapOp('Uncommentc', 'call tcomment#SetOption("mode_extra", "U")', 'tcomment#operator#Line', 'g@$')
call s:MapOp('Uncommentb', 'call tcomment#SetOption("mode_extra", "UB")', 'tcomment#operator#Line', 'g@')
xnoremap <silent> <Plug>TComment_Uncomment :<c-u>if v:count > 0 \| call tcomment#SetOption("count", v:count) \| endif \| call tcomment#SetOption("mode_extra", "U") \| '<,'>TCommentMaybeInline<cr>

call s:MapOp('Comment',  '', 'tcomment#operator#Anyway', 'g@')
call s:MapOp('Commentl', '', 'tcomment#operator#Line', 'g@$')
call s:MapOp('Commentc', '', 'tcomment#operator#LineAnyway', 'g@$')
call s:MapOp('Commentb', 'call tcomment#SetOption("mode_extra", "B")', 'tcomment#operator#Line', 'g@')
xnoremap <silent> <Plug>TComment_Comment :<c-u>if v:count > 0 \| call tcomment#SetOption("count", v:count) \| endif \| '<,'>TCommentMaybeInline!<cr>

vnoremap <Plug>TComment_ic :<c-U>call tcomment#textobject#InlineComment()<cr>
noremap <Plug>TComment_ic :<c-U>call tcomment#textobject#InlineComment()<cr>

call s:MapOp('gcc', '', 'tcomment#operator#Line', 'g@$')
call s:MapOp('gcb', 'call tcomment#SetOption("mode_extra", "B")', 'tcomment#operator#Line', 'g@')
xnoremap <Plug>TComment_gc :TCommentMaybeInline<cr>

call s:MapOp('gc', '', 'tcomment#operator#Op', 'g@')
call s:MapOp('gC', '', 'tcomment#operator#Line', 'g@')

for s:i in range(1, 9)
    exec 'noremap <Plug>TComment_<c-_>' . s:i . ' :call tcomment#SetOption("count", '. s:i .')<cr>'
    exec 'inoremap <Plug>TComment_<c-_>' . s:i . ' <c-\><c-o>:call tcomment#SetOption("count", '. s:i .')<cr>'
    exec 'vnoremap <Plug>TComment_<c-_>' . s:i . ' :call tcomment#SetOption("count", '. s:i .')<cr>'
endfor
for s:i in range(1, 9)
    call s:MapOp('gc' . s:i .'c', 'call tcomment#SetOption("count", '. s:i .')', 'tcomment#operator#Op', 'g@')
endfor
unlet s:i

delfun s:MapOp


if g:tcomment_maps
    if g:tcomment_mapleader1 != ''
        exec 'map '. g:tcomment_mapleader1 . g:tcomment_mapleader1 .' <Plug>TComment_<c-_><c-_>'
        exec 'vmap '. g:tcomment_mapleader1 . g:tcomment_mapleader1 .' <Plug>TComment_<c-_><c-_>'
        exec 'imap '. g:tcomment_mapleader1 . g:tcomment_mapleader1 .' <Plug>TComment_<c-_><c-_>'
        exec 'map '. g:tcomment_mapleader1 .'p <Plug>TComment_<c-_>p'
        exec 'imap '. g:tcomment_mapleader1 .'p <Plug>TComment_<c-_>p'
        exec 'map '. g:tcomment_mapleader1 .'<space> <Plug>TComment_<c-_><space>'
        exec 'imap '. g:tcomment_mapleader1 .'<space> <Plug>TComment_<c-_><space>'
        exec 'imap '. g:tcomment_mapleader1 .'r <Plug>TComment_<c-_>r'
        exec 'map '. g:tcomment_mapleader1 .'r <Plug>TComment_<c-_>r'
        exec 'vmap '. g:tcomment_mapleader1 .'i <Plug>TComment_<c-_>i'
        exec 'map '. g:tcomment_mapleader1 .'i <Plug>TComment_<c-_>i'
        exec 'imap '. g:tcomment_mapleader1 .'i <Plug>TComment_<c-_>i'
        exec 'map '. g:tcomment_mapleader1 .'b <Plug>TComment_<c-_>b'
        exec 'imap '. g:tcomment_mapleader1 .'b <Plug>TComment_<c-_>b'
        exec 'map '. g:tcomment_mapleader1 .'a <Plug>TComment_<c-_>a'
        exec 'imap '. g:tcomment_mapleader1 .'a <Plug>TComment_<c-_>a'
        exec 'map '. g:tcomment_mapleader1 .'n <Plug>TComment_<c-_>n'
        exec 'imap '. g:tcomment_mapleader1 .'n <Plug>TComment_<c-_>n'
        exec 'map '. g:tcomment_mapleader1 .'s <Plug>TComment_<c-_>s'
        exec 'imap '. g:tcomment_mapleader1 .'s <Plug>TComment_<c-_>s'
        exec 'map '. g:tcomment_mapleader1 .'cc <Plug>TComment_<c-_>cc'
        exec 'map '. g:tcomment_mapleader1 .'ca <Plug>TComment_<c-_>ca'
        for s:i in range(1, 9)
            exec 'map '. g:tcomment_mapleader1 . s:i .' <Plug>TComment_<c-_>'.s:i
            exec 'imap '. g:tcomment_mapleader1 . s:i .' <Plug>TComment_<c-_>'.s:i
            exec 'vmap '. g:tcomment_mapleader1 . s:i .' <Plug>TComment_<c-_>'.s:i
        endfor
        unlet s:i
    endif
    if g:tcomment_mapleader2 != ''
        exec 'map '. g:tcomment_mapleader2 .'_ <Plug>TComment_<Leader>__'
        exec 'xmap '. g:tcomment_mapleader2 .'_ <Plug>TComment_<Leader>__'
        exec 'map '. g:tcomment_mapleader2 .'p <Plug>TComment_<Leader>_p'
        exec 'map '. g:tcomment_mapleader2 .'<space> <Plug>TComment_<Leader>_<space>'
        exec 'xmap '. g:tcomment_mapleader2 .'i <Plug>TComment_<Leader>_i'
        exec 'map '. g:tcomment_mapleader2 .'r <Plug>TComment_<Leader>_r'
        exec 'map '. g:tcomment_mapleader2 .'b <Plug>TComment_<Leader>_b'
        exec 'map '. g:tcomment_mapleader2 .'a <Plug>TComment_<Leader>_a'
        exec 'map '. g:tcomment_mapleader2 .'n <Plug>TComment_<Leader>_n'
        exec 'map '. g:tcomment_mapleader2 .'s <Plug>TComment_<Leader>_s'
    endif
    if g:tcomment_opleader1 != ''
        exec 'nmap <silent> '. g:tcomment_opleader1 .' <Plug>TComment_gc'
        for s:i in range(1, 9)
            exec 'nmap <silent> '. g:tcomment_opleader1 . s:i .' <Plug>TComment_gc'.s:i
            exec 'nmap <silent> '. g:tcomment_opleader1 . s:i .'c <Plug>TComment_gc'.s:i.'c'
        endfor
        unlet s:i
        exec 'nmap <silent> '. g:tcomment_opleader1 .'c <Plug>TComment_gcc'
        exec 'nmap <silent> '. g:tcomment_opleader1 .'b <Plug>TComment_gcb'
        exec 'xmap '. g:tcomment_opleader1 .' <Plug>TComment_gc'
    endif
   if g:tcomment_mapleader_uncomment_anyway != ''
        exec 'nmap <silent> '. g:tcomment_mapleader_uncomment_anyway .' <Plug>TComment_Uncomment'
        exec 'nmap <silent> '. g:tcomment_mapleader_uncomment_anyway .'c <Plug>TComment_Uncommentc'
        exec 'nmap <silent> '. g:tcomment_mapleader_uncomment_anyway .'b <Plug>TComment_Uncommentb'
        exec 'xmap '. g:tcomment_mapleader_uncomment_anyway .' <Plug>TComment_Uncomment'
    endif
   if g:tcomment_mapleader_comment_anyway != ''
        exec 'nmap <silent> '. g:tcomment_mapleader_comment_anyway .' <Plug>TComment_Comment'
        exec 'nmap <silent> '. g:tcomment_mapleader_comment_anyway .'c <Plug>TComment_Commentc'
        exec 'nmap <silent> '. g:tcomment_mapleader_comment_anyway .'b <Plug>TComment_Commentb'
        exec 'xmap '. g:tcomment_mapleader_comment_anyway .' <Plug>TComment_Comment'
    endif
    if g:tcomment_textobject_inlinecomment != ''
        exec 'vmap' g:tcomment_textobject_inlinecomment ' <Plug>TComment_ic'
        exec 'omap' g:tcomment_textobject_inlinecomment ' <Plug>TComment_ic'
    endif
endif


let &cpo = s:save_cpo
unlet s:save_cpo
" vi: ft=vim:tw=72:ts=4:fo=w2croql
