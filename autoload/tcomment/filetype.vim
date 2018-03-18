" @Author:      Tom Link (mailto:micathom AT gmail com?subject=[vim])
" @Website:     http://www.vim.org/account/profile.php?user_id=4037
" @License:     GPL (see http://www.gnu.org/licenses/gpl.txt)
" @Created:     2007-09-17.
" @Last Change: 2018-03-18.
" @Revision:    3


function! tcomment#filetype#Get(...) abort "{{{3
    let ft = a:0 >= 1 && !empty(a:1) ? a:1 : &filetype
    let poss = a:0 >= 2 ? a:2 : [-1, 1, 0]
    for pos in poss
        Tlibtrace 'tcomment', ft, pos
        if pos == -1
            let rv = ft
        else
            let fts = split(ft, '^\@!\.')
            " TLogVAR fts
            " let ft = substitute(ft, '\..*$', '', '')
            let rv = get(fts, pos, ft)
            " TLogVAR fts, rv
        endif
        let fts_rx = '^\%('. join(map(keys(g:tcomment#filetype_map), 'escape(v:val, ''\'')'), '\|') .'\)$'
        Tlibtrace 'tcomment', fts_rx
        if rv =~ fts_rx
            for [ft_rx, ftrv] in items(g:tcomment#filetype_map)
                " TLogVAR ft_rx, ftrv
                if rv =~ ft_rx
                    let rv = substitute(rv, ft_rx, ftrv, '')
                    Tlibtrace 'tcomment', ft_rx, rv
                    Tlibtrace 'tcomment', rv
                    return rv
                endif
            endfor
        endif
    endfor
    Tlibtrace 'tcomment', ft
    return ft
endf


" Handle sub-filetypes etc.
function! tcomment#filetype#GetAlt(filetype, cdef) abort "{{{3
    let filetype = empty(a:filetype) ? tcomment#filetype#Get(&filetype, [-1]) : a:filetype
    Tlibtrace 'tcomment', a:filetype, filetype
    if g:tcommentGuessFileType || (exists('g:tcommentGuessFileType_'. filetype) 
                \ && g:tcommentGuessFileType_{filetype} =~# '[^0]')
        if g:tcommentGuessFileType_{filetype} == 1
            if filetype =~# '^.\{-}\..\+$'
                let alt_filetype = tcomment#filetype#Get(filetype)
            else
                let alt_filetype = ''
            endif
        else
            let alt_filetype = g:tcommentGuessFileType_{filetype}
        endif
        Tlibtrace 'tcomment', 1, alt_filetype
        return [1, alt_filetype]
    elseif filetype =~# '^.\{-}\..\+$'
        " Unfortunately the handling of "sub-filetypes" isn't 
        " consistent. Some use MAJOR.MINOR, others use MINOR.MAJOR.
        let alt_filetype = tcomment#filetype#Get(filetype)
        " if alt_filetype == filetype
        "     let alt_filetype = tcomment#filetype#Get(filetype, 1)
        "     if alt_filetype == a:filetype
        "         let alt_filetype = tcomment#filetype#Get(filetype, 0)
        "     endif
        " endif
        Tlibtrace 'tcomment', 2, alt_filetype
        return [1, alt_filetype]
    else
        Tlibtrace 'tcomment', 3, ''
        return [0, '']
    endif
endf



" vi: ft=vim:tw=72:ts=4:fo=w2croql
