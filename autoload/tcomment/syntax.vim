" @Author:      Tom Link (mailto:micathom AT gmail com?subject=[vim])
" @Website:     http://www.vim.org/account/profile.php?user_id=4037
" @License:     GPL (see http://www.gnu.org/licenses/gpl.txt)
" @Created:     2007-09-17.
" @Last Change: 2018-03-20.
" @Revision:    6

if exists(':Tlibtrace') != 2
    command! -nargs=+ -bang Tlibtrace :
endif


if !exists('g:tcomment#syntax#substitute')
    " :read: let g:tcomment#syntax#substitute = {...}   "{{{2
    " Perform replacements on the syntax name.
    let g:tcomment#syntax#substitute = {
                \ '\C^javaScript\ze\(\u\|$\)': {'sub': 'javascript'},
                \ '\C^js\ze\(\u\|$\)': {'sub': 'javascript'}
                \ }
endif


function! tcomment#syntax#GetSyntaxName(lnum, col) abort "{{{3
    let syntax_name = synIDattr(synID(a:lnum, a:col, 1), 'name')
    if !empty(g:tcomment#syntax#substitute)
        for [rx, subdef] in items(g:tcomment#syntax#substitute)
            if !has_key(subdef, 'if') || eval(subdef.if)
                let syntax_name = substitute(syntax_name, rx, subdef.sub, 'g')
            endif
        endfor
    endif
    Tlibtrace 'tcomment', syntax_name
    return syntax_name
endf

