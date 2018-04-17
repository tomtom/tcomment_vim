" @Author:      Tom Link (mailto:micathom AT gmail com?subject=[vim])
" @Website:     https://github.com/tomtom
" @License:     GPL (see http://www.gnu.org/licenses/gpl.txt)
" @Last Change: 2018-04-17
" @Revision:    36


function! tcomment#deprecated#Check() abort "{{{3
    let g = keys(g:)
    let vars = {'tcommentModeExtra': {'new': 'g:tcomment#mode_extra'}
                \ , 'tcommentOpModeExtra': {'new': 'g:tcomment#operator#mode_extra'}
                \ , 'tcommentOptions': {'new': 'g:tcomment#options'}
                \ , 'tcommentGuessFileType': {'new': 'g:tcomment#filetype#guess'}
                \ , 'tcommentMaps': {'new': 'g:tcomment_maps'}
                \ , 'tcommentMapLeader1': {'new': 'g:tcomment_mapleader1'}
                \ , 'tcommentMapLeader2': {'new': 'g:tcomment_mapleader2'}
                \ , 'tcommentMapLeaderOp1': {'new': 'g:tcomment_opleader1'}
                \ , 'tcommentMapLeaderUncommentAnyway': {'new': 'g:tcomment_mapleader_uncomment_anyway'}
                \ , 'tcommentMapLeaderCommentAnyway': {'new': 'g:tcomment_mapleader_comment_anyway'}
                \ , 'tcommentTextObjectInlineComment': {'new': 'g:tcomment_textoject_inlinecomment'}
                \ , 'tcomment#filetype_map': {'new': 'g:tcomment#filetype#map'}
                \ , 'tcomment#syntax_substitute': {'new': 'g:tcomment#syntax#substitute'}
                \ , 'tcommentSyntaxMap': {'new': 'g:tcomment#filetype#syntax_map'}
                \ , 'tcommentLineC_fmt': {'new': 'g:tcomment#line_fmt_c'}
                \ , 'tcommentInlineC': {'new': 'g:tcomment#inline_fmt_c'}
                \ , 'tcommentInlineXML': {'new': 'g:tcomment#inline_fmt_xml'}
                \ , 'tcommentBlockC': {'new': 'g:tcomment#block_fmt_c'}
                \ , 'tcommentBlockXML': {'new': 'g:tcomment#block_fmt_xml'}
                \ , 'tcommentBlockC2': {'new': 'g:tcomment#block2_fmt_c'}
                \ , 'tcommentGuessFileType_\(\w\+\)': {'subst': 'g:tcomment#filetype#guess_\1'}
                \ , 'tcommentIgnoreTypes_\(\w\+\)': {'subst': 'g:tcomment#filetype#ignore_\1'}
                \ }
    for [old, newdef] in items(vars)
        let g1 = filter(copy(g), 'v:key =~ ''^''. old .''$''')
        for gold in g1
            if has_key(newdef, 'new')
                let gnew = newdef.new
            elseif has_key(newdef, 'subst')
                let gnew = substitute(gold, old, newdef.subst, '')
            else
                throw 'tcomment#deprecated#Check: Internal error: '. string(newdef)
            endif
            echom 'tcomment:' gold 'is deprecated; please use' gnew 'instead; your setting might be ignored'
            exec 'let' gnew '= g:'. gold
        endfor
    endfor
endf

