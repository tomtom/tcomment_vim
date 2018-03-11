
function! tcomment#replace#DoReplacements(text, tokens, replacements) abort "{{{3
    if empty(a:tokens)
        return a:text
    else
        let rx = '\V\('. join(map(a:tokens, 'escape(v:val, ''\'')'), '\|') .'\)'
        let texts = split(a:text, rx .'\zs', 1)
        let texts = map(texts, 's:InlineReplacement(v:val, rx, a:tokens, a:replacements)')
        let text = join(texts, '')
        return text
    endif
endf


function! s:InlineReplacement(text, rx, tokens, replacements) abort "{{{3
    " TLogVAR a:text, a:rx, a:replacements
    let matches = split(a:text, '\ze'. a:rx .'\$', 1)
    if len(matches) == 1
        return a:text
    else
        let match = matches[-1]
        let idx = index(a:tokens, match)
        " TLogVAR matches, match, idx
        if idx != -1
            let matches[-1] = a:replacements[idx]
            " TLogVAR matches
            return join(matches, '')
        else
            throw 'TComment: Internal error: cannot find '. string(match) .' in '. string(a:tokens)
        endif
    endif
endf

