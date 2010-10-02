" tComment.vim -- An easily extensible & universal comment plugin 
" @Author:      Tom Link (micathom AT gmail com)
" @License:     GPL (see http://www.gnu.org/licenses/gpl.txt)
" @Created:     27-Dez-2004.
" @Last Change: 2010-10-02.
" @Revision:    709
" 
" GetLatestVimScripts: 1173 1 tComment.vim

if &cp || exists('loaded_tcomment')
    finish
endif
let loaded_tcomment = 201

if !exists("g:tcommentMapLeader1")
    " g:tcommentMapLeader1 should be a shortcut that can be used with 
    " map, imap, vmap.
    let g:tcommentMapLeader1 = '<c-_>'
endif
if !exists("g:tcommentMapLeader2")
    " g:tcommentMapLeader2 should be a shortcut that can be used with 
    " map, xmap.
    let g:tcommentMapLeader2 = '<Leader>_'
endif
if !exists("g:tcommentMapLeaderOp1")
    let g:tcommentMapLeaderOp1 = 'gc'
endif
if !exists("g:tcommentMapLeaderOp2")
    let g:tcommentMapLeaderOp2 = 'gC'
endif
if !exists("g:tcommentOpModeExtra")
    let g:tcommentOpModeExtra = ''
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



if (g:tcommentMapLeader1 != '')
    exec 'noremap <silent> '. g:tcommentMapLeader1 . g:tcommentMapLeader1 .' :TComment<cr>'
    exec 'vnoremap <silent> '. g:tcommentMapLeader1 . g:tcommentMapLeader1 .' :TCommentMaybeInline<cr>'
    exec 'inoremap <silent> '. g:tcommentMapLeader1 . g:tcommentMapLeader1 .' <c-o>:TComment<cr>'
    exec 'noremap <silent> '. g:tcommentMapLeader1 .'p m`vip:TComment<cr>``'
    exec 'inoremap <silent> '. g:tcommentMapLeader1 .'p <c-o>:norm! m`vip<cr>:TComment<cr><c-o>``'
    exec 'noremap '. g:tcommentMapLeader1 .'<space> :TComment '
    exec 'inoremap '. g:tcommentMapLeader1 .'<space> <c-o>:TComment '
    exec 'inoremap <silent> '. g:tcommentMapLeader1 .'r <c-o>:TCommentRight<cr>'
    exec 'noremap <silent> '. g:tcommentMapLeader1 .'r :TCommentRight<cr>'
    exec 'vnoremap <silent> '. g:tcommentMapLeader1 .'i :TCommentInline<cr>'
    exec 'vnoremap <silent> '. g:tcommentMapLeader1 .'r :TCommentRight<cr>'
    exec 'noremap '. g:tcommentMapLeader1 .'b :TCommentBlock<cr>'
    exec 'inoremap '. g:tcommentMapLeader1 .'b <c-o>:TCommentBlock<cr>'
    exec 'noremap '. g:tcommentMapLeader1 .'a :TCommentAs '
    exec 'inoremap '. g:tcommentMapLeader1 .'a <c-o>:TCommentAs '
    exec 'noremap '. g:tcommentMapLeader1 .'n :TCommentAs <c-r>=&ft<cr> '
    exec 'inoremap '. g:tcommentMapLeader1 .'n <c-o>:TCommentAs <c-r>=&ft<cr> '
    exec 'noremap '. g:tcommentMapLeader1 .'s :TCommentAs <c-r>=&ft<cr>_'
    exec 'inoremap '. g:tcommentMapLeader1 .'s <c-o>:TCommentAs <c-r>=&ft<cr>_'
endif
if (g:tcommentMapLeader2 != '')
    exec 'noremap <silent> '. g:tcommentMapLeader2 .'_ :TComment<cr>'
    exec 'xnoremap <silent> '. g:tcommentMapLeader2 .'_ :TCommentMaybeInline<cr>'
    exec 'noremap <silent> '. g:tcommentMapLeader2 .'p vip:TComment<cr>'
    exec 'noremap '. g:tcommentMapLeader2 .'<space> :TComment '
    exec 'xnoremap <silent> '. g:tcommentMapLeader2 .'i :TCommentInline<cr>'
    exec 'noremap <silent> '. g:tcommentMapLeader2 .'r :TCommentRight<cr>'
    exec 'xnoremap <silent> '. g:tcommentMapLeader2 .'r :TCommentRight<cr>'
    exec 'noremap '. g:tcommentMapLeader2 .'b :TCommentBlock<cr>'
    exec 'noremap '. g:tcommentMapLeader2 .'a :TCommentAs '
    exec 'noremap '. g:tcommentMapLeader2 .'n :TCommentAs <c-r>=&ft<cr> '
    exec 'noremap '. g:tcommentMapLeader2 .'s :TCommentAs <c-r>=&ft<cr>_'
endif
if (g:tcommentMapLeaderOp1 != '')
    exec 'nnoremap <silent> '. g:tcommentMapLeaderOp1 .' :let w:tcommentPos = getpos(".") \| set opfunc=tcomment#Operator<cr>g@'
    exec 'nnoremap <silent> '. g:tcommentMapLeaderOp1 .'c :let w:tcommentPos = getpos(".") \| set opfunc=tcomment#OperatorLine<cr>g@$'
    exec 'xnoremap <silent> '. g:tcommentMapLeaderOp1 .' :TCommentMaybeInline<cr>'
endif 
if (g:tcommentMapLeaderOp2 != '')
    exec 'nnoremap <silent> '. g:tcommentMapLeaderOp2 .' :let w:tcommentPos = getpos(".") \| set opfunc=tcomment#OperatorAnyway<cr>g@'
    exec 'nnoremap <silent> '. g:tcommentMapLeaderOp2 .'c :let w:tcommentPos = getpos(".") \| set opfunc=tcomment#OperatorLineAnyway<cr>g@$'
    exec 'xnoremap <silent> '. g:tcommentMapLeaderOp2 .' :TCommentMaybeInline<cr>'
endif 

finish


-----------------------------------------------------------------------
History

0.1
- Initial release

0.2
- Fixed uncommenting of non-aligned comments
- improved support for block comments (with middle lines and indentation)
- using TCommentBlock for file types that don't have block comments creates 
single line comments
- removed the TCommentAsBlock command (TCommentAs provides its functionality)
- removed g:tcommentSetCMS
- the default key bindings have slightly changed

1.3
- slightly improved recognition of embedded syntax
- if no commentstring is defined in whatever way, reconstruct one from 
&comments
- The TComment... commands now have bang variants that don't act as toggles 
but always comment out the selected text
- fixed problem with commentstrings containing backslashes
- comment as visual block (allows commenting text to the right of the main 
text, i.e., this command doesn't work on whole lines but on the text to the 
right of the cursor)
- enable multimode for dsl, vim filetypes
- added explicit support for some other file types I ran into

1.4
- Fixed problem when &commentstring was invalid (e.g. lua)
- perl_block by Kyosuke Takayama.
- <c-_>s mapped to :TCommentAs <c-r>=&ft<cr>

1.5
- "Inline" visual comments (uses the &filetype_inline style if 
available; doesn't check if the filetype actually supports this kind of 
comments); tComment can't currently deduce inline comment styles from 
&comments or &commentstring (I personally hardly ever use them); default 
map: <c-_>i or <c-_>I
- In visual mode: if the selection spans several lines, normal mode is 
selected; if the selection covers only a part of one line, inline mode 
is selected
- Fixed problem with lines containing ^M or ^@ characters.
- It's no longer necessary to call TCommentCollectFileTypes() after 
defining a new filetype via TCommentDefineType()
- Disabled single <c-_> mappings
- Renamed TCommentVisualBlock to TCommentRight
- FIX: Forgot 'x' in ExtractCommentsPart() (thanks to Fredrik Acosta)

1.6
- Ignore sql when guessing the comment string in php files; tComment 
sometimes chooses the wrong comment string because the use of sql syntax 
is used too loosely in php files; if you want to comment embedded sql 
code you have to use TCommentAs
- Use keepjumps in commands.
- Map <c-_>p & <L>_p to vip:TComment<cr>
- Made key maps configurable via g:tcommentMapLeader1 and 
g:tcommentMapLeader2

1.7
- gc{motion} (see g:tcommentMapLeaderOp1) functions as a comment toggle 
operator (i.e., something like gcl... works, mostly); gC{motion} (see 
g:tcommentMapLeaderOp2) will unconditionally comment the text.
- TCommentAs takes an optional second argument (the comment level)
- New "n" map: TCommentAs &filetype [COUNT]
- Defined mail comments/citations
- g:tcommentSyntaxMap: Map syntax names to filetypes for buffers with 
mixed syntax groups that don't match the filetypeEmbeddedsyntax scheme (e.g.  
'vimRubyRegion', which should be commented as ruby syntax, not as vim 
syntax)
- FIX: Comments in vim*Region
- TComment: The use of the type argument has slightly changed (IG -> i, 
new: >)

1.8
- Definitly require vim7
- Split the plugin into autoload & plugin.
- g:TCommentFileTypes is a list
- Fixed some block comment strings
- Removed extraneous newline in some block comments.
- Maps for visal mode (thanks Krzysztof Goj)

1.9
- Fix left offset for inline comments (via operator binding)

1.10
- tcomment#Operator defines w:tcommentPos if invoked repeatedly
- s:GuessFileType: use len(getline()) instead of col()

1.11
- Support for erlang (thanks to Zhang Jinzhu)

1.12
- Moved the definition of some variables from plugin/tComment.vim to 
autoload/tcomment.vim
- Changed comment string for eruby (proposed by Vinicius Baggio)
- Support for x86conf

2.0
- Enabled key=value pairs to configure commenting
- Renamed the file plugin/tComment.vim to plugin/tcomment.vim
- Renamed certain global functions to tcomment#...

2.1
- FIX

