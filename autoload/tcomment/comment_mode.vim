
function! tcomment#comment_mode#add_extra(comment_mode, extra, beg, end) abort "{{{3
    " TLogVAR a:comment_mode, a:extra
    if a:beg == a:end
        let extra = substitute(a:extra, '\C[B]', '', 'g')
    else
        let extra = substitute(a:extra, '\C[IR]', '', 'g')
    endif
    if empty(extra)
        return a:comment_mode
    else
        let comment_mode = a:comment_mode
        if extra =~# 'B'
            let comment_mode = substitute(comment_mode, '\c[gir]', '', 'g')
        endif
        if extra =~# '[IR]'
            let comment_mode = substitute(comment_mode, '\c[gb]', '', 'g')
        endif
        if extra =~# '[BLIRK]' && comment_mode =~# 'G'
            let comment_mode = substitute(comment_mode, '\c[G]', '', 'g')
        endif
        let rv = substitute(comment_mode, '\c['. extra .']', '', 'g') . extra
        " TLogVAR a:comment_mode, a:extra, comment_mode, extra, rv
        return rv
    endif
endf


