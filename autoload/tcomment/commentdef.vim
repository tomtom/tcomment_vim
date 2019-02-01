" @Author:      Tom Link (mailto:micathom AT gmail com?subject=[vim])
" @Website:     https://github.com/tomtom
" @License:     GPL (see http://www.gnu.org/licenses/gpl.txt)
" @Last Change: 2019-01-31
" @Revision:    21

if exists(':Tlibtrace') != 2
    command! -nargs=+ -bang Tlibtrace :
endif


function! tcomment#commentdef#GetForType(beg, end, comment_mode, filetype) abort "{{{3
    let cdef = tcomment#commentdef#Get(a:beg, a:end, a:comment_mode, a:filetype)
    Tlibtrace 'tcomment', cdef
    let cms  = cdef.commentstring
    let comment_mode = cdef.mode
    let pre  = substitute(cms, '%\@<!%s.*$', '', '')
    let pre  = substitute(pre, '%%', '%', 'g')
    let post = substitute(cms, '^.\{-}%\@<!%s', '', '')
    let post = substitute(post, '%%', '%', 'g')
    let cdef.begin = pre
    let cdef.end   = post
    return cdef
endf


" tcomment#commentdef#Get(beg, end, comment_mode, ?filetype="")
function! tcomment#commentdef#Get(beg, end, comment_mode, ...) abort
    let ft = a:0 >= 1 ? a:1 : ''
    Tlibtrace 'tcomment', a:beg, a:end, a:comment_mode, ft
    if !empty(ft)
        let cdef = tcomment#commentdef#GetCustom(ft, a:comment_mode)
    else
        let cdef = {'mode': a:comment_mode}
    endif
    Tlibtrace 'tcomment', cdef
    let cms = get(cdef, 'commentstring', '')
    if empty(cms)
        let filetype = tcomment#filetype#Get(ft)
        Tlibtrace 'tcomment', filetype
        if exists('b:commentstring')
            let cms = b:commentstring
            Tlibtrace 'tcomment', 1, cms
            return tcomment#commentdef#GetCustom(filetype, a:comment_mode, cms)
        elseif exists('b:commentStart') && !empty(b:commentStart)
            let cms = tcomment#format#EncodeCommentPart(b:commentStart) .' %s'
            Tlibtrace 'tcomment', 2, cms
            if exists('b:commentEnd') && !empty(b:commentEnd)
                let cms = cms .' '. tcomment#format#EncodeCommentPart(b:commentEnd)
            endif
            return tcomment#commentdef#GetCustom(filetype, a:comment_mode, cms)
        else
            let [use_guess_ft, alt_filetype] = tcomment#filetype#GetAlt(ft, cdef)
            Tlibtrace 'tcomment', use_guess_ft, alt_filetype
            if use_guess_ft
                return tcomment#filetype#Guess(a:beg, a:end,
                      \ a:comment_mode, filetype, alt_filetype,
                      \ g:tcomment#types#rx)
            else
                let guess_cdef = tcomment#vimoptions#MakeCommentDefinition(a:comment_mode)
                Tlibtrace 'tcomment', guess_cdef
                return tcomment#commentdef#GetCustom(filetype, a:comment_mode, guess_cdef.commentstring, guess_cdef)
            endif
        endif
        let cdef.commentstring = cms
    endif
    return cdef
endf


" tcomment#commentdef#GetCustom(filetype, comment_mode, ?default="", ?default_cdef={})
function! tcomment#commentdef#GetCustom(filetype, comment_mode, ...) abort
    Tlibtrace 'tcomment', a:filetype, a:comment_mode, a:000
    let comment_mode   = a:comment_mode
    let custom_comment = tcomment#type#Exists(a:filetype)
    let custom_comment_mode = tcomment#type#Exists(a:filetype, comment_mode)
    let supported_comment_mode = !empty(custom_comment_mode) ? comment_mode : ''
    Tlibtrace 'tcomment', custom_comment, custom_comment_mode
    let default = a:0 >= 1 ? a:1 : ''
    let default_cdef = a:0 >= 2 ? a:2 : {}
    let default_supports_comment_mode = get(default_cdef, 'comment_mode', custom_comment_mode)
    Tlibtrace 'tcomment', default, default_supports_comment_mode
    if comment_mode =~# '[ILB]' && !empty(custom_comment_mode)
        let def = tcomment#type#GetDefinition(custom_comment_mode)
        Tlibtrace 'tcomment', 1, def
    elseif !empty(custom_comment)
        let def = tcomment#type#GetDefinition(custom_comment)
        let comment_mode = tcomment#commentmode#Guess(comment_mode, supported_comment_mode)
        Tlibtrace 'tcomment', 3, def, comment_mode
    elseif !empty(default)
        if empty(default_cdef)
            let def = {'commentstring': default}
        else
            let def = default_cdef
        endif
        let comment_mode = tcomment#commentmode#Guess(comment_mode, default_supports_comment_mode)
        Tlibtrace 'tcomment', 4, def, comment_mode
    else
        let def = {}
        let comment_mode = tcomment#commentmode#Guess(comment_mode, '')
        Tlibtrace 'tcomment', 5, def, comment_mode
    endif
    let cdef = copy(def)
    if !has_key(cdef, 'mode')
        let cdef.mode = comment_mode
    endif
    let cdef.filetype = a:filetype
    Tlibtrace 'tcomment', cdef
    return cdef
endf


function! tcomment#commentdef#Extend(beg, end, comment_mode, cdef, args) abort
    for [key, value] in items(a:args)
        Tlibtrace 'tcomment', key, value
        if key ==# 'as'
            call extend(a:cdef, tcomment#commentdef#GetForType(a:beg, a:end, a:comment_mode, value))
        elseif key ==# 'mode'
            let a:cdef.mode = tcomment#commentmode#AddExtra(a:comment_mode, value, a:beg, a:end)
        elseif key ==# 'mode_extra'
            if has_key(a:cdef, 'mode')
                let mode = tcomment#commentmode#AddExtra(a:comment_mode, a:cdef.mode, a:beg, a:end)
                Tlibtrace 'tcomment', 'mode', mode
            else
                let mode = a:comment_mode
                Tlibtrace 'tcomment', 'mode == comment_mode', mode
            endif
            let a:cdef.mode = tcomment#commentmode#AddExtra(mode, value, a:beg, a:end)
        elseif key ==# 'count'
            let a:cdef[key] = str2nr(value)
        else
            let a:cdef[key] = value
        endif
        Tlibtrace 'tcomment', get(a:cdef, 'comment_mode', '')
    endfor
    return a:cdef
endf


function! tcomment#commentdef#GetCommentReplace(cdef, cms0) abort
    if has_key(a:cdef, 'commentstring_rx')
        let rs = tcomment#commentdef#BlockGetCommentString(a:cdef)
    else
        let rs = a:cms0
    endif
    return rs
endf


function! tcomment#commentdef#GetBlockCommentRx(cdef) abort
    if has_key(a:cdef, 'commentstring_rx')
        return [1, a:cdef.commentstring_rx]
    else
        let cms0 = tcomment#commentdef#BlockGetCommentString(a:cdef)
        " let cms0 = escape(cms0, '\')
        return [0, cms0]
    endif
endf


function! tcomment#commentdef#BlockGetCommentString(cdef) abort
    if has_key(a:cdef, 'middle')
        return a:cdef.commentstring
    else
        return matchstr(a:cdef.commentstring, '^.\{-}\ze\(\n\|$\)')
    endif
endf


function! tcomment#commentdef#BlockGetMiddleString(cdef) abort
    if has_key(a:cdef, 'middle')
        return a:cdef.middle
    else
        return matchstr(a:cdef.commentstring, '\n\zs.*')
    endif
endf


function! tcomment#commentdef#SetWhitespaceMode(cdef) abort "{{{3
    let mode = a:cdef.whitespace
    let cms = tcomment#commentdef#BlockGetCommentString(a:cdef)
    let mid = tcomment#commentdef#BlockGetMiddleString(a:cdef)
    let cms0 = cms
    let mid0 = mid
    Tlibtrace 'tcomment', mode, cms, mid
    if mode =~# '^\(n\%[o]\|l\%[eft]\|r\%[ight]\)$'
        " Remove whitespace on the left
        if mode =~# '^n\%[o]$' || mode =~# '^r\%[ight]$'
            let cms = substitute(cms, '\s\+\ze%\@<!%s', '', 'g')
            let mid = substitute(mid, '\s\+\ze%\@<!%s', '', 'g')
        endif
        " Remove whitespace on the right
        if mode =~# '^n\%[o]$' || mode =~# '^l\%[eft]$'
            let cms = substitute(cms, '%\@<!%s\zs\s\+', '', 'g')
            let mid = substitute(mid, '%\@<!%s\zs\s\+', '', 'g')
        endif
        if mode =~# '^l\%[eft]$'
            if mid !~# '%s'
                let mid .= ' '
            endif
        endif
    elseif mode =~# '^\(b\%[oth]\)$'
        let cms = substitute(cms, '\S\zs\ze%\@<!%s', ' ', 'g')
        let cms = substitute(cms, '%\@<!%s\zs\ze\S', ' ', 'g')
        if mid =~# '%s'
            let mid = substitute(mid, '\S\zs\ze%\@<!%s', ' ', 'g')
            let mid = substitute(mid, '%\@<!%s\zs\ze\S', ' ', 'g')
        else
            let mid .= ' '
        endif
    endif
    if cms != cms0
        Tlibtrace 'tcomment', cms
        let a:cdef.commentstring = cms
    endif
    if mid != mid0
        Tlibtrace 'tcomment', mid
        let a:cdef.middle = mid
    endif
    Tlibtrace 'tcomment', a:cdef
    return a:cdef
endf


function! tcomment#commentdef#RepeatCommentstring(cdef) abort "{{{3
    Tlibtrace 'tcomment', a:cdef
    let cms = tcomment#commentdef#BlockGetCommentString(a:cdef)
    let mid = tcomment#commentdef#BlockGetMiddleString(a:cdef)
    let cms_fbeg = match(cms, '\s*%\@<!%s')
    let cms_fend = matchend(cms, '%\@<!%s\s*')
    let rxbeg = get(a:cdef, 'rxbeg', '^.*$')
    let rxend = get(a:cdef, 'rxend', '^.*$')
    let rpbeg = repeat('&', get(a:cdef, 'cbeg', get(a:cdef, 'count', 1)))
    let rpend = repeat('&', get(a:cdef, 'cend', get(a:cdef, 'count', 1)))
    let cmsbeg = cms[0 : cms_fbeg - 1]
    if !empty(rxbeg)
        let cmsbeg = substitute(cmsbeg, rxbeg, rpbeg, '')
    endif
    let cmsend = cms[cms_fend : -1]
    if !empty(rxend)
        let cmsend = substitute(cmsend, rxend, rpend, '')
    endif
    let a:cdef.commentstring = cmsbeg . cms[cms_fbeg : cms_fend - 1] . cmsend
    Tlibtrace 'tcomment', cms, a:cdef.commentstring
    if !empty(mid)
        let rxmid = get(a:cdef, 'rxmid', '^.*$')
        if empty(rxmid)
            let a:cdef.middle = mid
        else
            let rpmid = repeat('&', get(a:cdef, 'cmid', get(a:cdef, 'count', 1)))
            let a:cdef.middle = substitute(mid, rxmid, rpmid, '')
            Tlibtrace 'tcomment', mid, a:cdef.middle
        endif
    endif
    return a:cdef
endf

