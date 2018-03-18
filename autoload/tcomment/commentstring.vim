" @Author:      Tom Link (mailto:micathom AT gmail com?subject=[vim])
" @Website:     http://www.vim.org/account/profile.php?user_id=4037
" @License:     GPL (see http://www.gnu.org/licenses/gpl.txt)
" @Created:     2007-09-17.
" @Last Change: 2018-03-18.
" @Revision:    5


function! s:DefaultValue(option) abort
    exec 'let '. a:option .' = &'. a:option
    exec 'set '. a:option .'&'
    exec 'let default = &'. a:option
    exec 'let &'. a:option .' = '. a:option
    return default
endf


let s:default_comments       = s:DefaultValue('comments')
let s:default_comment_string = s:DefaultValue('commentstring')
let s:null_comment_string    = '%s'


function! tcomment#commentstring#GuessVimOptions(comment_mode) abort
    " TLogVAR a:comment_mode
    let commentstring = &commentstring
    " let valid_f = (match(substitute(commentstring, '%\@<!\(%%\)*%s', '', 'g'), '%\@<!%[^%]') == -1)
    let valid_f = (match(commentstring, '%\@<!%\%([^%s]\|$\)') == -1)
    if !valid_f
        let commentstring = substitute(commentstring, '%\@<!%\ze\([^%s]\|$\)', '%%', 'g')
    endif
    let valid_cms = (match(commentstring, '%\@<!\(%%\)*%s') != -1)
    let ccmodes = 'r'
    if commentstring =~# '\S\s*%s\s*\S'
        let ccmodes .= 'bi'
    endif
    let guess_comment_mode = tcomment#commentmode#GuessCommentMode(a:comment_mode, ccmodes)
    " TLogVAR guess_comment_mode
    if commentstring != s:default_comment_string && valid_cms
        " The &commentstring appears to have been set and to be valid
        let cdef = copy(g:tcomment#options_commentstring)
        let cdef.mode = guess_comment_mode
        let cdef.commentstring = commentstring
        return cdef
    endif
    if &comments != s:default_comments
        " the commentstring is the default one, so we assume that it wasn't 
        " explicitly set; we then try to reconstruct &cms from &comments
        let cdef = s:ConstructFromCommentsOption(a:comment_mode)
        " TLogVAR comments_cdef
        if !empty(cdef)
            call extend(cdef, g:tcomment#options_comments)
            return cdef
        endif
    endif
    if valid_cms
        " Before &commentstring appeared not to be set. As we don't know 
        " better we return it anyway if it is valid
        let cdef = copy(g:tcomment#options_commentstring)
        let cdef.mode = guess_comment_mode
        let cdef.commentstring = commentstring
        return cdef
    else
        " &commentstring is invalid. So we return the identity string.
        let cdef = {}
        let cdef.mode = guess_comment_mode
        let cdef.commentstring = s:null_comment_string
        return cdef
    endif
endf
" tcomment#commentstring#GetCustom(ft, comment_mode, ?default="", ?default_cdef={})
function! tcomment#commentstring#GetCustom(ft, comment_mode, ...) abort
    " TLogVAR a:ft, a:comment_mode, a:000
    let comment_mode   = a:comment_mode
    let custom_comment = tcomment#TypeExists(a:ft)
    let custom_comment_mode = tcomment#TypeExists(a:ft, comment_mode)
    let supported_comment_mode = !empty(custom_comment_mode) ? comment_mode : ''
    " TLogVAR custom_comment, custom_comment_mode
    let default = a:0 >= 1 ? a:1 : ''
    let default_cdef = a:0 >= 2 ? a:2 : {}
    let default_supports_comment_mode = get(default_cdef, 'comment_mode', custom_comment_mode)
    " TLogVAR default, default_supports_comment_mode
    if comment_mode =~# '[ILB]' && !empty(custom_comment_mode)
        let def = tcomment#GetCommentDef(custom_comment_mode)
        " TLogVAR 1, def
    elseif !empty(custom_comment)
        let def = tcomment#GetCommentDef(custom_comment)
        let comment_mode = tcomment#commentmode#GuessCommentMode(comment_mode, supported_comment_mode)
        " TLogVAR 3, def, comment_mode
    elseif !empty(default)
        if empty(default_cdef)
            let def = {'commentstring': default}
        else
            let def = default_cdef
        endif
        let comment_mode = tcomment#commentmode#GuessCommentMode(comment_mode, default_supports_comment_mode)
        " TLogVAR 4, def, comment_mode
    else
        let def = {}
        let comment_mode = tcomment#commentmode#GuessCommentMode(comment_mode, '')
        " TLogVAR 5, def, comment_mode
    endif
    let cdef = copy(def)
    if !has_key(cdef, 'mode')
        let cdef.mode = comment_mode
    endif
    let cdef.filetype = a:ft
    " TLogVAR cdef
    return cdef
endf


function! s:ExtractCommentsPart() abort
    let comments = {
                \ 'line': {'string': '', 'flags': ''},
                \ 's':    {'string': '', 'flags': ''},
                \ 'm':    {'string': '', 'flags': ''},
                \ 'e':    {'string': '', 'flags': ''},
                \ }
    let rx = '\C\([nbfsmelrOx0-9-]*\):\(\%(\\,\|[^,]\)*\)'
    let comparts = split(&l:comments, rx .'\zs,')
    for part in comparts
        let ml = matchlist(part, '^'. rx .'$')
        let flags = ml[1]
        let string = substitute(ml[2], '\\,', ',', 'g')
        if flags !~# 'O'
            let flag = matchstr(flags, '^[sme]')
            if empty(flag)
                let flag = 'line'
            endif
            let string = substitute(string, '%', '%%', 'g')
            let comments[flag] = {'string': string, 'flags': flags}
        endif
    endfor
    return comments
endf


function! s:ConstructFromCommentsOption(comment_mode) abort
    " TLogVAR a:comment_mode
    let cdef = {}
    let comments = s:ExtractCommentsPart()
    " TLogVAR comments
    if a:comment_mode =~? '[bi]' && !empty(comments.s.string)
        let cdef.mode = a:comment_mode
        let cdef.commentstring = comments.s.string .' %s '. comments.e.string
        if a:comment_mode =~? '[b]' && !empty(comments.m.string)
            let mshift = str2nr(matchstr(comments.s.flags, '\(^\|[^-]\)\zs\d\+'))
            let mindent = repeat(' ', mshift)
            let cdef.middle = mindent . comments.m.string
        endif
        " TLogVAR cdef
        return cdef
    endif
    let ccmodes = 'r'
    if !empty(comments.e.string)
        let ccmodes .= 'bi'
    endif
    let comment_mode = tcomment#commentmode#GuessCommentMode(a:comment_mode, ccmodes)
    if !empty(comments.line.string)
        let cdef.mode = comment_mode
        let cdef.commentstring = comments.line.string .' %s'
    elseif !empty(comments.s.string)
        let cdef.mode = comment_mode
        let cdef.commentstring = comments.s.string .' %s '. comments.e.string
    endif
    return cdef
endf


function! tcomment#commentstring#getCommentReplace(cdef, cms0) abort
    if has_key(a:cdef, 'commentstring_rx')
        let rs = tcomment#commentstring#BlockGetCommentString(a:cdef)
    else
        let rs = a:cms0
    endif
    return rs
    " return escape(rs, '"/')
endf


function! tcomment#commentstring#getBlockCommentRx(cdef) abort
    if has_key(a:cdef, 'commentstring_rx')
        return a:cdef.commentstring_rx
    else
        let cms0 = tcomment#commentstring#BlockGetCommentString(a:cdef)
        let cms0 = escape(cms0, '\')
        return cms0
    endif
endf


function! tcomment#commentstring#BlockGetCommentString(cdef) abort
    if has_key(a:cdef, 'middle')
        return a:cdef.commentstring
    else
        return matchstr(a:cdef.commentstring, '^.\{-}\ze\(\n\|$\)')
    endif
endf


function! tcomment#commentstring#BlockGetMiddleString(cdef) abort
    if has_key(a:cdef, 'middle')
        return a:cdef.middle
    else
        return matchstr(a:cdef.commentstring, '\n\zs.*')
    endif
endf


function! tcomment#commentstring#SetWhitespaceMode(cdef) abort "{{{3
    let mode = a:cdef.whitespace
    let cms = tcomment#commentstring#BlockGetCommentString(a:cdef)
    let mid = tcomment#commentstring#BlockGetMiddleString(a:cdef)
    let cms0 = cms
    let mid0 = mid
    " TLogVAR mode, cms, mid
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
        " TLogVAR cms
        let a:cdef.commentstring = cms
    endif
    if mid != mid0
        " TLogVAR mid
        let a:cdef.middle = mid
    endif
    " TLogVAR a:cdef
    return a:cdef
endf


function! tcomment#commentstring#RepeatCommentstring(cdef) abort "{{{3
    " TLogVAR a:cdef
    let cms = tcomment#commentstring#BlockGetCommentString(a:cdef)
    let mid = tcomment#commentstring#BlockGetMiddleString(a:cdef)
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
    " TLogVAR cms, a:cdef.commentstring
    if !empty(mid)
        let rxmid = get(a:cdef, 'rxmid', '^.*$')
        if empty(rxmid)
            let a:cdef.middle = mid
        else
            let rpmid = repeat('&', get(a:cdef, 'cmid', get(a:cdef, 'count', 1)))
            let a:cdef.middle = substitute(mid, rxmid, rpmid, '')
            " TLogVAR mid, a:cdef.middle
        endif
    endif
    return a:cdef
endf


" vi: ft=vim:tw=72:ts=4:fo=w2croql
