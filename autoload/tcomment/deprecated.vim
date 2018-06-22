" @Author:      Tom Link (mailto:micathom AT gmail com?subject=[vim])
" @Website:     https://github.com/tomtom
" @License:     GPL (see http://www.gnu.org/licenses/gpl.txt)
" @Last Change: 2018-06-22
" @Revision:    55

function! tcomment#deprecated#Check() abort "{{{3
    let vars = {
                \   'tcommentModeExtra': 'g:tcomment#mode_extra'
                \ , 'tcommentOpModeExtra': 'g:tcomment#operator#mode_extra'
                \ , 'tcommentOptions': 'g:tcomment#options'
                \ , 'tcommentGuessFileType': 'g:tcomment#filetype#guess'
                \ , 'tcommentMaps': 'g:tcomment_maps'
                \ , 'tcommentMapLeader1': 'g:tcomment_mapleader1'
                \ , 'tcommentMapLeader2': 'g:tcomment_mapleader2'
                \ , 'tcommentMapLeaderOp1': 'g:tcomment_opleader1'
                \ , 'tcommentMapLeaderUncommentAnyway': 'g:tcomment_mapleader_uncomment_anyway'
                \ , 'tcommentMapLeaderCommentAnyway': 'g:tcomment_mapleader_comment_anyway'
                \ , 'tcommentTextObjectInlineComment': 'g:tcomment_textobject_inlinecomment'
                \ , 'tcomment#filetype_map': 'g:tcomment#filetype#map'
                \ , 'tcomment#syntax_substitute': 'g:tcomment#syntax#substitute'
                \ , 'tcommentSyntaxMap': 'g:tcomment#filetype#syntax_map'
                \ , 'tcommentLineC_fmt': 'g:tcomment#line_fmt_c'
                \ , 'tcommentInlineC': 'g:tcomment#inline_fmt_c'
                \ , 'tcommentInlineXML': 'g:tcomment#inline_fmt_xml'
                \ , 'tcommentBlockC': 'g:tcomment#block_fmt_c'
                \ , 'tcommentBlockXML': 'g:tcomment#block_fmt_xml'
                \ , 'tcommentBlockC2': 'g:tcomment#block2_fmt_c'
                \ }

    let patterns = {
                \   'tcommentGuessFileType_\(\w\+\)': 'g:tcomment#filetype#guess_\1'
                \ , 'tcommentIgnoreTypes_\(\w\+\)': 'g:tcomment#filetype#ignore_\1'
                \ }

    let pattern = '\C^\%(' . join(keys(patterns) + keys(vars), '\|') . '\)$'
    " let gvars = filter(keys(g:), 'v:val =~# pattern')
    " let gvars = filter(keys(g:), 'v:val =~# ''^tcomment''')
    let gvars = filter(keys(g:), 'strpart(v:val, 0, '. strlen('tcomment') .') ==# ''tcomment''')

    for gold in gvars
        let gnew = ''

        if has_key(vars, gold)
            let gnew = vars[gold]
        elseif gold =~# pattern
            for [search, replace] in items(patterns)
                if gold =~# search
                    let gnew = substitute(gold, search, replace, '')
                    break
                endif
            endfor
        endif

        if !empty(gnew)
            echom 'tcomment:' gold 'is deprecated; please use' gnew 'instead; your setting might be ignored'
            exec 'let' gnew '= g:'. gold
        endif
    endfor
endf

