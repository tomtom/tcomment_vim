" @Author:      Tom Link (mailto:micathom AT gmail com?subject=[vim])
" @Website:     https://github.com/tomtom
" @License:     GPL (see http://www.gnu.org/licenses/gpl.txt)
" @Last Change: 2018-03-20
" @Revision:    4


" return a list of filetypes for which a tcomment_{&ft} is defined
" :nodoc:
function! tcomment#complete#Complete(ArgLead, CmdLine, CursorPos) abort "{{{3
    call tcomment#type#Collect()
    let completions = copy(g:tcomment#types#names)
    let filetype = tcomment#filetype#Get()
    if index(completions, filetype) != -1
        Tlibtrace 'tcomment', filetype
        call insert(completions, filetype)
    endif
    if !empty(a:ArgLead)
        call filter(completions, 'v:val =~ ''\V\^''.a:ArgLead')
    endif
    let completions += tcomment#complete#Args(a:ArgLead, a:CmdLine, a:CursorPos)
    return completions
endf


let s:first_completion = 0

" :nodoc:
function! tcomment#complete#Args(ArgLead, CmdLine, CursorPos) abort "{{{3
    if v:version < 703 && !s:first_completion
        redraw
        let s:first_completion = 1
    endif
    let completions = ['as=', 'col=', 'count=', 'mode=', 'begin=', 'end=', 'rxbeg=', 'rxend=', 'rxmid=']
    if !empty(a:ArgLead)
        if a:ArgLead =~# '^as='
            call tcomment#type#Collect()
            let completions += map(copy(g:tcomment#types#names), '"as=". v:val')
        endif
        call filter(completions, 'v:val =~ ''\V\^''.a:ArgLead')
    endif
    return completions
endf

