" @Author:      Tom Link (mailto:micathom AT gmail com?subject=[vim])
" @Website:     http://www.vim.org/account/profile.php?user_id=4037
" @License:     GPL (see http://www.gnu.org/licenses/gpl.txt)
" @Created:     2007-09-17.
" @Last Change: 2018-03-20.
" @Revision:    10

if exists(':Tlibtrace') != 2
    command! -nargs=+ -bang Tlibtrace :
endif


function! tcomment#regex#Count(string, rx) abort
    return len(split(a:string, a:rx, 1)) - 1
endf


function! tcomment#regex#StartColRx(cdef, comment_mode, col, ...) abort
    let mixedindent = a:0 >= 1 ? a:1 : get(a:cdef, 'mixedindent', 1)
    Tlibtrace 'tcomment', a:comment_mode, a:col, mixedindent
    if a:comment_mode =~# '[IR]'
        let col = mixedindent ? a:col - 1 : a:col
        let c0 = 1
    else
        let col = a:col
        let c0 = 2
    endif
    Tlibtrace 'tcomment', col, c0, mixedindent
    if col < c0
        return '\^'
    elseif mixedindent
        return '\%>'. col .'v'
    else
        return '\%'. col .'v'
    endif
endf


function! tcomment#regex#EndColRx(comment_mode, lnum, pos) abort
    Tlibtrace 'tcomment', a:comment_mode, a:lnum, a:pos
    let line = getline(a:lnum)
    let cend = tcomment#compatibility#Strdisplaywidth(line)
    Tlibtrace 'tcomment', cend
    if a:pos == 0 || a:pos >= cend
        return '\$'
    else
        if a:comment_mode =~? 'i' && a:comment_mode =~# 'o'
            let mod = '>'
        else
            let mod = ''
        endif
        Tlibtrace 'tcomment', &selection, mod
        return '\%'. mod . a:pos .'v'
    endif
endf


function! tcomment#regex#StartPosRx(cdef, comment_mode, line, col) abort
    Tlibtrace 'tcomment', a:comment_mode, a:line, a:col
    let rv = tcomment#regex#StartColRx(a:cdef, a:comment_mode, a:col)
    Tlibtrace 'tcomment', rv
    return rv
endf


function! tcomment#regex#EndPosRx(comment_mode, lnum, col) abort
    Tlibtrace 'tcomment', a:comment_mode, a:lnum, a:col
    return tcomment#regex#EndColRx(a:comment_mode, a:lnum, a:col)
endf


function! tcomment#regex#StartLineRx(pos) abort
    return '\%'. a:pos .'l'
endf


function! tcomment#regex#EndLineRx(pos) abort
    return '\%'. a:pos .'l'
endf

