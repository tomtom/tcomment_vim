" @Author:      Tom Link (mailto:micathom AT gmail com?subject=[vim])
" @Website:     https://github.com/tomtom
" @License:     GPL (see http://www.gnu.org/licenses/gpl.txt)
" @Last Change: 2018-03-19
" @Revision:    2


if exists('*strdisplaywidth')
    function! tcomment#compatibility#Strwidth(text) abort "{{{3
        return strdisplaywidth(a:text)
    endf
else
    function! tcomment#compatibility#Strwidth(text) abort "{{{3
        return len(a:text)
    endf
endif


if v:version >= 703
    function! tcomment#compatibility#Strdisplaywidth(...) abort "{{{3
        return call('strdisplaywidth', a:000)
    endf
else
    function! tcomment#compatibility#Strdisplaywidth(string, ...) abort "{{{3
        " NOTE: Col argument is ignored
        return strlen(substitute(a:string, '.', 'x', 'g'))
    endf
endif


