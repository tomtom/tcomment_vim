" @Author:      Tom Link (mailto:micathom AT gmail com?subject=[vim])
" @Website:     http://www.vim.org/account/profile.php?user_id=4037
" @License:     GPL (see http://www.gnu.org/licenses/gpl.txt)
" @Created:     2007-09-17.
" @Last Change: 2018-03-20.
" @Revision:    7

if exists(':Tlibtrace') != 2
    command! -nargs=+ -bang Tlibtrace :
endif


function! tcomment#cursor#GetStartEnd(beg, end, comment_mode) abort "{{{3
    Tlibtrace 'tcomment', a:beg, a:end, a:comment_mode
    if type(a:beg) == 3
        let [lbeg, cbeg] = a:beg
        let [lend, cend] = a:end
    else
        let lbeg = a:beg
        let lend = a:end
        let comment_mode = a:comment_mode
        Tlibtrace 'tcomment', comment_mode
        if comment_mode =~# 'R'
            let cbeg = virtcol('.')
            let cend = virtcol('$')
            let comment_mode = substitute(comment_mode, '\CR', 'G', 'g')
            Tlibtrace 'tcomment', 'R', cbeg, cend, comment_mode
        elseif comment_mode =~# 'I'
            let cbeg = virtcol("'<")
            if cbeg == 0
                let cbeg = virtcol('.')
            endif
            let cend = virtcol("'>")
            if cend < virtcol('$') && (comment_mode =~# 'o' || &selection ==# 'inclusive')
                let cend += 1
                Tlibtrace 'tcomment', cend, virtcol('$')
            endif
            Tlibtrace 'tcomment', 'I', cbeg, cend, comment_mode
        else
            let cbeg = -1
            let cend = 0
            for lnum in range(a:beg, a:end)
                if getline(lnum) =~# '\S'
                    let indentwidth = indent(lnum)
                    Tlibtrace 'tcomment', cbeg, lnum, indentwidth, getline(lnum)
                    if cbeg == -1 || indentwidth < cbeg
                        let cbeg = indentwidth
                    endif
                endif
            endfor
            if cbeg == -1
                let cbeg = 0
            endif
        endif
    endif
    Tlibtrace 'tcomment', lbeg, cbeg, lend, cend
    if lend < lbeg || (lend == lbeg && cend > 0 && cend < cbeg)
        return [lend, cend, lbeg, cbeg]
    else
        return [lbeg, cbeg, lend, cend]
    endif
endf


function! tcomment#cursor#SetPos(expr, pos) abort "{{{3
    if getpos(a:expr) != a:pos
        call setpos(a:expr, a:pos)
    endif
endf

