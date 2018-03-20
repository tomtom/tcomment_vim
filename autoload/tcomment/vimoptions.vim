" @Author:      Tom Link (mailto:micathom AT gmail com?subject=[vim])
" @Website:     http://www.vim.org/account/profile.php?user_id=4037
" @License:     GPL (see http://www.gnu.org/licenses/gpl.txt)
" @Created:     2007-09-17.
" @Last Change: 2018-03-20.
" @Revision:    15


if exists(':Tlibtrace') != 2
    command! -nargs=+ -bang Tlibtrace :
endif


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


function! tcomment#vimoptions#MakeCommentDefinition(comment_mode) abort
    Tlibtrace 'tcomment', a:comment_mode
    let commentstring = &commentstring
    let valid_f = (match(commentstring, '%\@<!%\%([^%s]\|$\)') == -1)
    if !valid_f
        let commentstring = substitute(commentstring, '%\@<!%\ze\([^%s]\|$\)', '%%', 'g')
    endif
    let valid_cms = (match(commentstring, '%\@<!\(%%\)*%s') != -1)
    let ccmodes = 'r'
    if commentstring =~# '\S\s*%s\s*\S'
        let ccmodes .= 'bi'
    endif
    let guess_comment_mode = tcomment#commentmode#Guess(a:comment_mode, ccmodes)
    Tlibtrace 'tcomment', guess_comment_mode
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
        Tlibtrace 'tcomment', cdef
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
    Tlibtrace 'tcomment', a:comment_mode
    let cdef = {}
    let comments = s:ExtractCommentsPart()
    Tlibtrace 'tcomment', comments
    if a:comment_mode =~? '[bi]' && !empty(comments.s.string)
        let cdef.mode = a:comment_mode
        let cdef.commentstring = comments.s.string .' %s '. comments.e.string
        if a:comment_mode =~? '[b]' && !empty(comments.m.string)
            let mshift = str2nr(matchstr(comments.s.flags, '\(^\|[^-]\)\zs\d\+'))
            let mindent = repeat(' ', mshift)
            let cdef.middle = mindent . comments.m.string
        endif
        Tlibtrace 'tcomment', cdef
        return cdef
    endif
    let ccmodes = 'r'
    if !empty(comments.e.string)
        let ccmodes .= 'bi'
    endif
    let comment_mode = tcomment#commentmode#Guess(a:comment_mode, ccmodes)
    if !empty(comments.line.string)
        let cdef.mode = comment_mode
        let cdef.commentstring = comments.line.string .' %s'
    elseif !empty(comments.s.string)
        let cdef.mode = comment_mode
        let cdef.commentstring = comments.s.string .' %s '. comments.e.string
    endif
    return cdef
endf


" vi: ft=vim:tw=72:ts=4:fo=w2croql
