" @Author:      Tom Link (mailto:micathom AT gmail com?subject=[vim])
" @Website:     https://github.com/tomtom
" @License:     GPL (see http://www.gnu.org/licenses/gpl.txt)
" @Last Change: 2018-03-19
" @Revision:    3


function! tcomment#operator#Op(type, ...) abort "{{{3
    let type = a:type
    let comment_mode = a:0 >= 1 ? a:1 : ''
    let bang = a:0 >= 2 ? a:2 : ''
    " TLogVAR type, comment_mode, bang
    if !exists('w:tcomment_pos')
        let w:tcomment_pos = getpos('.')
    endif
    let sel_save = &selection
    set selection=inclusive
    let reg_save = @@
    try
        if type ==# 'line'
            silent exe "normal! '[V']"
            let comment_mode1 = 'G'
        elseif type ==# 'block'
            silent exe "normal! `[\<C-V>`]"
            let comment_mode1 = 'I'
        elseif type ==# 'char'
            silent exe 'normal! `[v`]'
            let comment_mode1 = 'I'
        else
            silent exe 'normal! `[v`]'
            let comment_mode1 = 'i'
        endif
        if empty(comment_mode)
            let comment_mode = comment_mode1
        endif
        let lbeg = line("'[")
        let lend = line("']")
        let cend = virtcol("']")
        if type ==# 'char'
            if lbeg == lend && cend >= virtcol('$') - 1
                let comment_mode = 'R'
            elseif g:tcomment#ignore_char_type && lbeg != lend
                silent exe "normal! '[V']"
                let cend = virtcol("']")
                let comment_mode = 'G'
                let type = 'line'
            endif
        endif
        let cbeg = virtcol("'[")
        " TLogVAR comment_mode, comment_mode1, lbeg, lend, cbeg, cend, virtcol('$')
        " TLogVAR comment_mode
        " echom "DBG tcomment#operator#Op" lbeg virtcol("'[") virtcol("'<") lend virtcol("']") virtcol("'>")
        norm! 
        let comment_mode = tcomment#commentmode#AddExtra(comment_mode, g:tcommentOpModeExtra, lbeg, lend)
        " TLogVAR comment_mode, type
        "  if type =~ 'line\|block' || g:tcomment#ignore_char_type
        " if comment_mode =~# '[R]'
        "     call tcomment#Comment([lbeg, cbeg], [lend, cend], comment_mode.'o', bang)
        " elseif type =~ 'line\|block' || g:tcomment#ignore_char_type
        if type =~# '\%(line\|block\)'
            call tcomment#Comment(lbeg, lend, comment_mode.'o', bang)
        else
            call tcomment#Comment([lbeg, cbeg], [lend, cend], comment_mode.'o', bang)
        endif
    finally
        let &selection = sel_save
        let @@ = reg_save
        " TLogVAR g:tcommentOpModeExtra
        if g:tcommentOpModeExtra !~# '[#>]'
            if exists('w:tcomment_pos')
                " TLogVAR w:tcomment_pos
                if w:tcomment_pos != getpos('.')
                    call setpos('.', w:tcomment_pos)
                endif
                unlet! w:tcomment_pos
            else
                echohl WarningMsg
                echom "TComment: w:tcomment_pos wasn't set. Please report this to the plugin author"
                echohl NONE
            endif
        endif
    endtry
endf


function! tcomment#operator#Line(type) abort "{{{3
    " TLogVAR a:type
    call tcomment#operator#Op('line', 'L')
endf


function! tcomment#operator#Anyway(type) abort "{{{3
    " TLogVAR a:type
    call tcomment#operator#Op(a:type, '', '!')
endf


function! tcomment#operator#LineAnyway(type) abort "{{{3
    " TLogVAR a:type
    call tcomment#operator#Op('line', 'L', '!')
endf


