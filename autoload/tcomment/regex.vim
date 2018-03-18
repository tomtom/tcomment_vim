" @Author:      Tom Link (mailto:micathom AT gmail com?subject=[vim])
" @Website:     http://www.vim.org/account/profile.php?user_id=4037
" @License:     GPL (see http://www.gnu.org/licenses/gpl.txt)
" @Created:     2007-09-17.
" @Last Change: 2018-03-18.
" @Revision:    4


function! tcomment#regex#Count(string, rx) abort
    return len(split(a:string, a:rx, 1)) - 1
endf


function! tcomment#regex#Printf1(fmt, expr) abort
    let n = tcomment#regex#Count(a:fmt, '%\@<!\%(%%\)*%s')
    let exprs = repeat([a:expr], n)
    " TLogVAR a:fmt, a:expr, exprs
    let rv = call(function('printf'), [a:fmt] + exprs)
    " TLogVAR rv
    return rv
endf

