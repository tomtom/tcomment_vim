" @Author:      Tom Link (mailto:micathom AT gmail com?subject=[vim])
" @Website:     https://github.com/tomtom
" @License:     GPL (see http://www.gnu.org/licenses/gpl.txt)
" @Last Change: 2018-03-20
" @Revision:    3


if exists(':Tlibtrace') != 2
    command! -nargs=+ -bang Tlibtrace :
endif


function! tcomment#textobject#InlineComment() abort "{{{3
    let cdef = tcomment#GuessCommentType({'comment_mode': 'I'})
    let cms  = escape(cdef.commentstring, '\')
    let pos  = getpos('.')
    let lnum = pos[1]
    let col  = pos[2]
    let cmtf = '\V'. printf(cms, '\.\{-}\%'. lnum .'l\%'. col .'c\.\{-}')
    Tlibtrace 'tcomment', cmtf, search(cmtf,'cwn')
    if search(cmtf, 'cw') > 0
        let pos0 = getpos('.')
        if search(cmtf, 'cwe') > 0
            let pos1 = getpos('.')
            exec 'norm!'
                        \ pos0[1].'gg'.pos0[2].'|v'.
                        \ pos1[1].'gg'.pos1[2].'|'.
                        \ (&selection ==# 'exclusive' ? 'l' : '')
        endif
    endif
endf


