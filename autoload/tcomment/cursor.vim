
function! tcomment#cursor#getStartEnd(beg, end, comment_mode) abort "{{{3
    " TLogVAR a:beg, a:end, a:comment_mode
    if type(a:beg) == 3
        let [lbeg, cbeg] = a:beg
        let [lend, cend] = a:end
    else
        let lbeg = a:beg
        let lend = a:end
        let comment_mode = a:comment_mode
        " TLogVAR comment_mode
        if comment_mode =~# 'R'
            let cbeg = virtcol('.')
            let cend = virtcol('$')
            let comment_mode = substitute(comment_mode, '\CR', 'G', 'g')
            " TLogVAR 'R', cbeg, cend, comment_mode
        elseif comment_mode =~# 'I'
            let cbeg = virtcol("'<")
            if cbeg == 0
                let cbeg = virtcol('.')
            endif
            let cend = virtcol("'>")
            if cend < virtcol('$') && (comment_mode =~# 'o' || &selection ==# 'inclusive')
                let cend += 1
                " TLogVAR cend, virtcol('$')
            endif
            " TLogVAR 'I', cbeg, cend, comment_mode
        else
            let cbeg = -1
            let cend = 0
            for lnum in range(a:beg, a:end)
                if getline(lnum) =~# '\S'
                    let indentwidth = indent(lnum)
                    " TLogVAR cbeg, lnum, indentwidth, getline(lnum)
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
    " TLogVAR lbeg, cbeg, lend, cend
    if lend < lbeg || (lend == lbeg && cend > 0 && cend < cbeg)
        return [lend, cend, lbeg, cbeg]
    else
        return [lbeg, cbeg, lend, cend]
    endif
endf


