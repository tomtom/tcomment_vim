" @Author:      Tom Link (mailto:micathom AT gmail com?subject=[vim])
" @Website:     http://www.vim.org/account/profile.php?user_id=4037
" @License:     GPL (see http://www.gnu.org/licenses/gpl.txt)
" @Created:     2007-09-17.
" @Last Change: 2018-03-19.
" @Revision:    12

if exists(':Tlibtrace') != 2
    command! -nargs=+ -bang Tlibtrace :
endif


" inspired by Meikel Brandmeyer's EnhancedCommentify.vim
" this requires that a syntax names are prefixed by the filetype name 
" tcomment#filetype#Guess(beg, end, comment_mode, filetype, ?fallbackFiletype)
function! tcomment#filetype#Guess(beg, end, comment_mode, filetype, ...) abort
    " TLogVAR a:beg, a:end, a:comment_mode, a:filetype, a:000
    let cdef0 = tcomment#commentdef#GetCustom(a:filetype, a:comment_mode)
    if a:0 >= 1 && !empty(a:1)
        let cdef = tcomment#commentdef#GetCustom(a:1, a:comment_mode)
        " TLogVAR 0, cdef
        let cdef = extend(cdef, cdef0, 'keep')
        " TLogVAR 1, cdef
        if empty(get(cdef, 'commentstring', ''))
            let guess_cdef = tcomment#vimoptions#MakeCommentDefinition(a:comment_mode)
            call extend(cdef, guess_cdef)
        endif
        " TLogVAR 2, cdef
    else
        let cdef = cdef0
        " TLogVAR 3, cdef
        if !has_key(cdef, 'commentstring')
            let cdef = tcomment#vimoptions#MakeCommentDefinition(a:comment_mode)
        endif
        " TLogVAR 4, cdef
    endif
    let beg = a:beg
    let end = nextnonblank(a:end)
    if end == 0
        let end = a:end
        let beg = prevnonblank(a:beg)
        if beg == 0
            let beg = a:beg
        endif
    endif
    let n  = beg
    " TLogVAR n, beg, end
    while n <= end
        let text = getline(n)
        let indentstring = matchstr(text, '^\s*')
        let m = tcomment#compatibility#Strwidth(indentstring)
        " let m  = indent(n) + 1
        let le = tcomment#compatibility#Strwidth(text)
        " TLogVAR n, m, le
        while m <= le
            let syntax_name = tcomment#syntax#GetSyntaxName(n, m)
            " TLogVAR syntax_name, n, m
            unlet! ftype_map
            let ftype_map = get(g:tcommentSyntaxMap, syntax_name, '')
            " TLogVAR ftype_map
            if !empty(ftype_map) && type(ftype_map) == 4
                if n < a:beg
                    let key = 'prevnonblank'
                elseif n > a:end
                    let key = 'nextnonblank'
                else
                    let key = ''
                endif
                if empty(key) || !has_key(ftype_map, key)
                    let ftypeftype = get(ftype_map, 'filetype', {})
                    " TLogVAR ftype_map, ftypeftype
                    unlet! ftype_map
                    let ftype_map = get(ftypeftype, a:filetype, '')
                else
                    let mapft = ''
                    for mapdef in ftype_map[key]
                        if strpart(text, m - 1) =~# '^'. mapdef.match
                            let mapft = mapdef.filetype
                            break
                        endif
                    endfor
                    unlet! ftype_map
                    if empty(mapft)
                        let ftype_map = ''
                    else
                        let ftype_map = mapft
                    endif
                endif
            endif
            if !empty(ftype_map)
                " TLogVAR ftype_map
                return tcomment#commentdef#GetCustom(ftype_map, a:comment_mode, cdef.commentstring)
            elseif syntax_name =~ g:tcomment#types#rx
                let ft = substitute(syntax_name, g:tcomment#types#rx, '\1', '')
                " TLogVAR ft
                if exists('g:tcommentIgnoreTypes_'. a:filetype) && g:tcommentIgnoreTypes_{a:filetype} =~ '\<'.ft.'\>'
                    let m += 1
                else
                    return tcomment#commentdef#GetCustom(ft, a:comment_mode, cdef.commentstring)
                endif
            elseif empty(syntax_name) || syntax_name ==? 'None' || syntax_name =~# '^\u\+$' || syntax_name =~# '^\u\U*$'
                let m += 1
            else
                break
            endif
        endwh
        let n += 1
    endwh
    " TLogVAR cdef
    return cdef
endf


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
