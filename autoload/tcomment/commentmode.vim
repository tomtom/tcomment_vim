" @Author:      Tom Link (mailto:micathom AT gmail com?subject=[vim])
" @Website:     http://www.vim.org/account/profile.php?user_id=4037
" @License:     GPL (see http://www.gnu.org/licenses/gpl.txt)
" @Created:     2007-09-17.
" @Last Change: 2018-03-20.
" @Revision:    7

if exists(':Tlibtrace') != 2
    command! -nargs=+ -bang Tlibtrace :
endif


function! tcomment#commentmode#AddExtra(comment_mode, extra, beg, end) abort "{{{3
    Tlibtrace 'tcomment', a:comment_mode, a:extra
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
        Tlibtrace 'tcomment', a:comment_mode, a:extra, comment_mode, extra, rv
        return rv
    endif
endf


function! tcomment#commentmode#Guess(comment_mode, supported_comment_modes) abort "{{{3
    Tlibtrace 'tcomment', a:comment_mode, a:supported_comment_modes
    let special = substitute(a:comment_mode, '\c[^ukc]', '', 'g')
    let cmode = tolower(a:comment_mode)
    let ccmodes = split(tolower(a:supported_comment_modes), '\zs')
    let ccmodes = filter(ccmodes, 'stridx(cmode, v:val) != -1')
    let guess = substitute(a:comment_mode, '\w\+', 'G', 'g')
    Tlibtrace 'tcomment', ccmodes, guess
    if a:comment_mode =~# '[BR]'
        let rv = !empty(ccmodes) ? a:comment_mode : guess
    elseif a:comment_mode =~# '[I]'
        let rv = !empty(ccmodes) ? a:comment_mode : ''
    else
        let rv = guess
    endif
    return tcomment#commentmode#AddExtra(rv, special, 0, 1)
endf

