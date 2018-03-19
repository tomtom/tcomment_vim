" @Author:      Tom Link (mailto:micathom AT gmail com?subject=[vim])
" @Website:     http://www.vim.org/account/profile.php?user_id=4037
" @License:     GPL (see http://www.gnu.org/licenses/gpl.txt)
" @Created:     2007-09-17.
" @Last Change: 2018-03-19.
" @Revision:    8


function! tcomment#regex#Count(string, rx) abort
    return len(split(a:string, a:rx, 1)) - 1
endf


function! tcomment#regex#StartColRx(cdef, comment_mode, col, ...) abort
    let mixedindent = a:0 >= 1 ? a:1 : get(a:cdef, 'mixedindent', 1)
    " TLogVAR a:comment_mode, a:col, mixedindent
    if a:comment_mode =~# '[IR]'
        let col = mixedindent ? a:col - 1 : a:col
        let c0 = 1
    else
        let col = a:col
        let c0 = 2
    endif
    " TLogVAR col, c0, mixedindent
    if col < c0
        return '\^'
    elseif mixedindent
        return '\%>'. col .'v'
    else
        return '\%'. col .'v'
    endif
endf


function! tcomment#regex#EndColRx(comment_mode, lnum, pos) abort
    " TLogVAR a:comment_mode, a:lnum, a:pos
    let line = getline(a:lnum)
    let cend = tcomment#compatibility#Strdisplaywidth(line)
    " TLogVAR cend
    if a:pos == 0 || a:pos >= cend
        return '\$'
    else
        if a:comment_mode =~? 'i' && a:comment_mode =~# 'o'
            let mod = '>'
        else
            let mod = ''
        endif
        " TLogVAR &selection, mod
        return '\%'. mod . a:pos .'v'
    endif
endf


function! tcomment#regex#StartPosRx(cdef, comment_mode, line, col) abort
    " TLogVAR a:comment_mode, a:line, a:col
    " if a:comment_mode =~# 'I'
    "     return tcomment#regex#StartLineRx(a:line) . tcomment#regex#StartColRx(a:comment_mode, a:col)
    " else
        let rv = tcomment#regex#StartColRx(a:cdef, a:comment_mode, a:col)
    " endif
    " TLogVAR rv
    return rv
endf


function! tcomment#regex#EndPosRx(comment_mode, lnum, col) abort
    " TLogVAR a:comment_mode, a:lnum, a:col
    " if a:comment_mode =~# 'I'
    "     return tcomment#regex#EndLineRx(a:lnum) . tcomment#regex#EndColRx(a:col)
    " else
        return tcomment#regex#EndColRx(a:comment_mode, a:lnum, a:col)
    " endif
endf


function! tcomment#regex#StartLineRx(pos) abort
    return '\%'. a:pos .'l'
endf


function! tcomment#regex#EndLineRx(pos) abort
    return '\%'. a:pos .'l'
endf

