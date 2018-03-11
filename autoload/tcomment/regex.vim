

function! tcomment#regex#count(string, rx) abort
    return len(split(a:string, a:rx, 1)) - 1
endf


function! tcomment#regex#Printf1(fmt, expr) abort
    let n = tcomment#regex#count(a:fmt, '%\@<!\%(%%\)*%s')
    let exprs = repeat([a:expr], n)
    " TLogVAR a:fmt, a:expr, exprs
    let rv = call(function('printf'), [a:fmt] + exprs)
    " TLogVAR rv
    return rv
endf
