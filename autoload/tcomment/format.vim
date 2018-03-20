" @Author:      Tom Link (mailto:micathom AT gmail com?subject=[vim])
" @Website:     https://github.com/tomtom
" @License:     GPL (see http://www.gnu.org/licenses/gpl.txt)
" @Last Change: 2018-03-20
" @Revision:    5


function! tcomment#format#EncodeCommentPart(string) abort
    return substitute(a:string, '%', '%%', 'g')
endf


function! tcomment#format#Printf1(fmt, expr) abort
    let n = tcomment#regex#Count(a:fmt, '%\@<!\%(%%\)*%s')
    let exprs = repeat([a:expr], n)
    Tlibtrace 'tcomment', a:fmt, a:expr, exprs
    let rv = call(function('printf'), [a:fmt] + exprs)
    Tlibtrace 'tcomment', rv
    return rv
endf

