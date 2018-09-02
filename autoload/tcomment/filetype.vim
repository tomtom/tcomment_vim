" @Author:      Tom Link (mailto:micathom AT gmail com?subject=[vim])
" @Website:     http://www.vim.org/account/profile.php?user_id=4037
" @License:     GPL (see http://www.gnu.org/licenses/gpl.txt)
" @Created:     2007-09-17.
" @Last Change: 2018-09-02.
" @Revision:    41

if exists(':Tlibtrace') != 2
    command! -nargs=+ -bang Tlibtrace :
endif


if !exists('g:tcomment#filetype#guess')
    " Guess the file type based on syntax names always or for some fileformat only
    " If non-zero, try to guess filetypes.
    " tcomment also checks g:tcomment#filetype#guess_{&filetype} for 
    " filetype specific values.
    "
    " Values:
    "   0        ... don't guess
    "   1        ... guess
    "   FILETYPE ... assume this filetype
    "
    " NOTE: Issue 222, 224: Default=1 doesn't work well
    let g:tcomment#filetype#guess = 0   "{{{2
endif
if !exists('g:tcomment#filetype#guess_cpp')
    " See |g:tcomment#filetype#guess_php|.
    let g:tcomment#filetype#guess_cpp = 0   "{{{2
endif
if !exists('g:tcomment#filetype#guess_blade')
    " See |g:tcomment#filetype#guess_php|.
    let g:tcomment#filetype#guess_blade = 'html'   "{{{2
endif
" if !exists('g:tcomment#filetype#guess_django')
"     let g:tcomment#filetype#guess_django = 1   "{{{2
" endif
if !exists('g:tcomment#filetype#guess_dsl')
    " For dsl documents, assume filetype = xml.
    let g:tcomment#filetype#guess_dsl = 'xml'   "{{{2
endif
" if !exists('g:tcomment#filetype#guess_eruby')
"     let g:tcomment#filetype#guess_eruby = 1   "{{{2
" endif
" if !exists('g:tcomment#filetype#guess_html')
"     let g:tcomment#filetype#guess_html = 1   "{{{2
" endif
if !exists('g:tcomment#filetype#guess_jinja')
    let g:tcomment#filetype#guess_jinja = 'html'   "{{{2
endif
" if !exists('g:tcomment#filetype#guess_perl')
"     let g:tcomment#filetype#guess_perl = 1   "{{{2
" endif
if !exists('g:tcomment#filetype#guess_php')
    " In php documents, the php part is usually marked as phpRegion. We 
    " thus assume that the buffers default comment style isn't php but 
    " html.
    let g:tcomment#filetype#guess_php = 'html'   "{{{2
endif
if !exists('g:tcomment#filetype#guess_rmd')
    let g:tcomment#filetype#guess_rmd = 'markdown'   "{{{2
endif
if !exists('g:tcomment#filetype#guess_rnoweb')
    let g:tcomment#filetype#guess_rnoweb = 'r'   "{{{2
endif
" if !exists('g:tcomment#filetype#guess_smarty')
"     let g:tcomment#filetype#guess_smarty = 1   "{{{2
" endif
" if !exists('g:tcomment#filetype#guess_tskeleton')
"     let g:tcomment#filetype#guess_tskeleton = 1   "{{{2
" endif
" if !exists('g:tcomment#filetype#guess_vim')
"     let g:tcomment#filetype#guess_vim = 1   "{{{2
" endif
if !exists('g:tcomment#filetype#guess_vue')
    let g:tcomment#filetype#guess_vue = 'html'   "{{{2
endif


if !exists('g:tcomment#filetype#ignore_php')
    " In php files, some syntax regions are wrongly highlighted as sql 
    " markup. We thus ignore sql syntax when guessing the filetype in 
    " php files.
    let g:tcomment#filetype#ignore_php = 'sql'   "{{{2
endif
if !exists('g:tcomment#filetype#ignore_blade')
    let g:tcomment#filetype#ignore_blade = 'html'   "{{{2
endif


if !exists('g:tcomment#filetype#map')
    " Keys must match the full |filetype|. Regexps must be |magic|. No 
    " regexp modifiers (like |\V|) are allowed.
    " let g:tcomment#filetype#map = {...}   "{{{2
    let g:tcomment#filetype#map = {
                \ 'cpp.doxygen': 'cpp',
                \ 'mkd': 'html',
                \ 'rails-views': 'html',
                \ 'tblgen': 'cpp',
                \ }
endif
if exists('g:tcomment#filetype#map_user')
    let g:tcomment#filetype#map = extend(g:tcomment#filetype#map, g:tcomment#filetype#map_user)
endif


if !exists('g:tcomment#filetype#syntax_map')
    " tcomment guesses filetypes based on the name of the current syntax 
    " region. This works well if the syntax names match 
    " /filetypeSomeName/. Other syntax names have to be explicitly 
    " mapped onto the corresponding filetype.
    " :read: let g:tcomment#filetype#syntax_map = {...}   "{{{2
    let g:tcomment#filetype#syntax_map = {
                \ 'bladeEcho':          'php',
                \ 'bladePhpParenBlock': 'php',
                \ 'erubyExpression':    'ruby',
                \ 'rmdRChunk':          'r',
                \ 'vimMzSchemeRegion':  'scheme',
                \ 'vimPerlRegion':      'perl',
                \ 'vimPythonRegion':    'python',
                \ 'vimRubyRegion':      'ruby',
                \ 'vimTclRegion':       'tcl',
                \ 'Delimiter': {
                \     'filetype': {
                \         'php': 'php',
                \     },
                \ },
                \ 'phpRegionDelimiter': {
                \     'prevnonblank': [
                \         {'match': '<?php', 'filetype': 'php'},
                \         {'match': '?>', 'filetype': 'html'},
                \     ],
                \     'nextnonblank': [
                \         {'match': '?>', 'filetype': 'php'},
                \         {'match': '<?php', 'filetype': 'html'},
                \     ],
                \ },
                \ }
endif
if exists('g:tcomment#filetype#syntax_map_user')
    let g:tcomment#filetype#syntax_map = extend(g:tcomment#filetype#syntax_map, g:tcomment#filetype#syntax_map_user)
endif


" inspired by Meikel Brandmeyer's EnhancedCommentify.vim
" this requires that a syntax names are prefixed by the filetype name 
" tcomment#filetype#Guess(beg, end, comment_mode, filetype, ?fallbackFiletype)
function! tcomment#filetype#Guess(beg, end, comment_mode, filetype, ...) abort
    Tlibtrace 'tcomment', a:beg, a:end, a:comment_mode, a:filetype, a:000
    let cdef0 = tcomment#commentdef#GetCustom(a:filetype, a:comment_mode)
    if a:0 >= 1 && !empty(a:1)
        let cdef = tcomment#commentdef#GetCustom(a:1, a:comment_mode)
        Tlibtrace 'tcomment', 0, cdef
        let cdef = extend(cdef, cdef0, 'keep')
        Tlibtrace 'tcomment', 1, cdef
        if empty(get(cdef, 'commentstring', ''))
            let guess_cdef = tcomment#vimoptions#MakeCommentDefinition(a:comment_mode)
            call extend(cdef, guess_cdef)
        endif
        Tlibtrace 'tcomment', 2, cdef
    else
        let cdef = cdef0
        Tlibtrace 'tcomment', 3, cdef
        if !has_key(cdef, 'commentstring')
            let cdef = tcomment#vimoptions#MakeCommentDefinition(a:comment_mode)
        endif
        Tlibtrace 'tcomment', 4, cdef
    endif
    let beg = a:beg
    let end = nextnonblank(a:end)
    if end == 0
        let end = a:end
        let beg = prevnonblank(a:beg)
        if beg == 0
            let beg = a:beg
        endif
    endif
    let n  = beg
    Tlibtrace 'tcomment', n, beg, end
    while n <= end
        let text = getline(n)
        let indentstring = matchstr(text, '^\s*')
        let m = tcomment#compatibility#Strwidth(indentstring)
        " let m  = indent(n) + 1
        let le = tcomment#compatibility#Strwidth(text)
        Tlibtrace 'tcomment', n, m, le
        while m <= le
            let syntax_name = tcomment#syntax#GetSyntaxName(n, m)
            Tlibtrace 'tcomment', syntax_name, n, m
            unlet! ftype_map
            let ftype_map = get(g:tcomment#filetype#syntax_map, syntax_name, '')
            Tlibtrace 'tcomment', ftype_map
            if !empty(ftype_map) && type(ftype_map) == 4
                if n < a:beg
                    let key = 'prevnonblank'
                elseif n > a:end
                    let key = 'nextnonblank'
                else
                    let key = ''
                endif
                if empty(key) || !has_key(ftype_map, key)
                    let ftypeftype = get(ftype_map, 'filetype', {})
                    Tlibtrace 'tcomment', ftype_map, ftypeftype
                    unlet! ftype_map
                    let ftype_map = get(ftypeftype, a:filetype, '')
                else
                    let mapft = ''
                    for mapdef in ftype_map[key]
                        if strpart(text, m - 1) =~# '^'. mapdef.match
                            let mapft = mapdef.filetype
                            break
                        endif
                    endfor
                    unlet! ftype_map
                    if empty(mapft)
                        let ftype_map = ''
                    else
                        let ftype_map = mapft
                    endif
                endif
            endif
            if !empty(ftype_map)
                Tlibtrace 'tcomment', ftype_map
                return tcomment#commentdef#GetCustom(ftype_map, a:comment_mode, cdef.commentstring)
            elseif syntax_name =~ g:tcomment#types#rx
                let ft = substitute(syntax_name, g:tcomment#types#rx, '\1', '')
                Tlibtrace 'tcomment', ft
                if exists('g:tcomment#filetype#ignore_'. a:filetype) && g:tcomment#filetype#ignore_{a:filetype} =~ '\<'.ft.'\>'
                    let m += 1
                else
                    return tcomment#commentdef#GetCustom(ft, a:comment_mode, cdef.commentstring)
                endif
            elseif empty(syntax_name) || syntax_name ==? 'None' || syntax_name =~# '^\u\+$' || syntax_name =~# '^\u\U*$'
                let m += 1
            else
                break
            endif
        endwh
        let n += 1
    endwh
    Tlibtrace 'tcomment', cdef
    return cdef
endf


function! tcomment#filetype#Get(...) abort "{{{3
    let ft = a:0 >= 1 && !empty(a:1) ? a:1 : &filetype
    let poss = a:0 >= 2 ? a:2 : [-1, 1, 0]
    for pos in poss
        Tlibtrace 'tcomment', ft, pos
        if pos == -1
            let rv = ft
        else
            let fts = split(ft, '^\@!\.')
            Tlibtrace 'tcomment', fts
            " let ft = substitute(ft, '\..*$', '', '')
            let rv = get(fts, pos, ft)
            Tlibtrace 'tcomment', fts, rv
        endif
        let fts_rx = '^\%('. join(map(keys(g:tcomment#filetype#map), 'escape(v:val, ''\'')'), '\|') .'\)$'
        Tlibtrace 'tcomment', fts_rx
        if rv =~ fts_rx
            for [ft_rx, ftrv] in items(g:tcomment#filetype#map)
                Tlibtrace 'tcomment', ft_rx, ftrv
                if rv =~ ft_rx
                    let rv = substitute(rv, ft_rx, ftrv, '')
                    Tlibtrace 'tcomment', ft_rx, rv
                    return rv
                endif
            endfor
        endif
    endfor
    Tlibtrace 'tcomment', ft
    return ft
endf


" Handle sub-filetypes etc.
function! tcomment#filetype#GetAlt(filetype, cdef) abort "{{{3
    let filetype = empty(a:filetype) ? tcomment#filetype#Get(&filetype, [-1]) : a:filetype
    let vfiletype = substitute(filetype, '[.]', '_', 'g')
    Tlibtrace 'tcomment', a:filetype, filetype
    let guess = get(a:cdef, 'guess',
                \ exists('g:tcomment#filetype#guess_'. vfiletype) ?
                \    g:tcomment#filetype#guess_{vfiletype} :
                \    g:tcomment#filetype#guess)
    if guess ==# '1'
        if filetype =~# '^.\{-}\..\+$'
            let alt_filetype = tcomment#filetype#Get(filetype)
        else
            let alt_filetype = ''
        endif
        Tlibtrace 'tcomment', 1, alt_filetype
        return [1, alt_filetype]
    elseif !empty(guess)
        Tlibtrace 'tcomment', 2, guess
        return [1, guess]
    elseif filetype =~# '^.\{-}\..\+$'
        " Unfortunately the handling of "sub-filetypes" isn't 
        " consistent. Some use MAJOR.MINOR, others use MINOR.MAJOR.
        let alt_filetype = tcomment#filetype#Get(filetype)
        " if alt_filetype == filetype
        "     let alt_filetype = tcomment#filetype#Get(filetype, 1)
        "     if alt_filetype == a:filetype
        "         let alt_filetype = tcomment#filetype#Get(filetype, 0)
        "     endif
        " endif
        Tlibtrace 'tcomment', 3, alt_filetype
        return [1, alt_filetype]
    else
        Tlibtrace 'tcomment', 4, ''
        return [0, '']
    endif
endf



" vi: ft=vim:tw=72:ts=4:fo=w2croql
