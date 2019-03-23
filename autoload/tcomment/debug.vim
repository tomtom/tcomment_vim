" @Author:      Tom Link (mailto:micathom AT gmail com?subject=[vim])
" @Website:     https://github.com/tomtom
" @License:     GPL (see http://www.gnu.org/licenses/gpl.txt)
" @Last Change: 2019-03-23
" @Revision:    10


function! tcomment#debug#CollectInfo() abort "{{{3
    redir @+>
    echom 'TCOMMENT: &ft =' &filetype '=>' tcomment#filetype#Get()
    echom 'TCOMMENT: stx =' synIDattr(synID(line('.'), col('.'), 1), 'name') '=>' tcomment#syntax#GetSyntaxName(line('.'), col('.'))
    echom 'TCOMMENT: ct  =' string(tcomment#GuessCommentType())
    redir END
    echom 'The info was also copied to the clipboard @+'
    echom 'Please see also :help tcomment-debug'
endf

