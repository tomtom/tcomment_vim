" @Author:      Tom Link (mailto:micathom AT gmail com?subject=[vim])
" @Website:     http://www.vim.org/account/profile.php?user_id=4037
" @License:     GPL (see http://www.gnu.org/licenses/gpl.txt)
" @Created:     2007-09-17.
" @Last Change: 2021-04-14.
" @Revision:    2046

scriptencoding utf-8

if exists(':Tlibtrace') != 2
    " :nodoc:
    command! -nargs=+ -bang Tlibtrace :
endif


if !exists('g:tcomment#blank_lines')
    " If 1, comment blank lines too.
    " If 2, also comment blank lines within indented code blocks 
    " (requires mixedindent -- see |tcomment#Comment()|).
    let g:tcomment#blank_lines = 2    "{{{2
endif

if !exists('g:tcomment#rstrip_on_uncomment')
    " If 1, remove right-hand whitespace on uncomment from empty lines.
    " If 2, remove right-hand whitespace on uncomment from all lines.
    let g:tcomment#rstrip_on_uncomment = 1   "{{{2
endif

if !exists('g:tcomment#mode_extra')
    " Modifies how commenting works.
    "   >  ... Move the cursor to the end of the comment
    "   >> ... Like above but move the cursor to the beginning of the next line
    "   >| ... Like above but move the cursor to the next line
    "   #  ... Move the cursor to the position of the commented text 
    "          (NOTE: this only works when creating empty comments using 
    "          |:TCommentInline| from normal or insert mode and should 
    "          not be set here as a global option.)
    let g:tcomment#mode_extra = ''   "{{{2
endif

if !exists('g:tcomment#options')
    " Other key-value options used by |tcomment#Comment()|.
    " If the buffer-local variable b:tcomment_options exists, it will be 
    " used in addition.
    "
    " Examples:
    " Put the opening comment marker always in the first column 
    " regardless of the block's indentation, put this into your |vimrc| 
    " file: >
    "   let g:tcomment#options = {'col': 1}
    "
    " Indent uncommented lines: >
    "   let g:tcomment#options = {'postprocess_uncomment': 'norm! %sgg=%sgg'}
    let g:tcomment#options = {}   "{{{2
endif

if !exists('g:tcomment#options_comments')
    " Additional args for |tcomment#Comment()| when using the 'comments' 
    " option.
    let g:tcomment#options_comments = {'whitespace': get(g:tcomment#options, 'whitespace', 'both')}   "{{{2
endif

if !exists('g:tcomment#options_commentstring')
    " Additional args for |tcomment#Comment()| when using the 
    " 'commentstring' option.
    let g:tcomment#options_commentstring = {'whitespace': get(g:tcomment#options, 'whitespace', 'both')}   "{{{2
endif

if !exists('g:tcomment#ignore_char_type')
    " |text-objects| for use with |tcomment#operator#Op| can have different 
    " types: line, block, char etc. Text objects like aB, it, at etc. 
    " have type char but this may not work reliably. By default, 
    " tcomment handles those text objects most often as if they were of 
    " type line. Set this variable to 0 in order to change this 
    " behaviour. Be prepared that the result may not always match your 
    " intentions.
    let g:tcomment#ignore_char_type = 1   "{{{2
endif

if !exists('g:tcomment#replacements_c')
    " Replacements for c filetype.
    " :read: let g:tcomment#replacements_c = {...}   "{{{2
    let g:tcomment#replacements_c = {
                \     '/*': {'guard_rx': '^\s*/\?\*', 'subst': '#<{(|'},
                \     '*/': {'guard_rx': '^\s*/\?\*', 'subst': '|)}>#'},
                \ }
endif

if !exists('g:tcomment#commentstring_c')
    let g:tcomment#commentstring_c = '/* %s */'   "{{{2
endif

if !exists('g:tcomment#line_fmt_c')
    " Generic c-like block comments.
    let g:tcomment#line_fmt_c = {
                \ 'commentstring_rx': '\%%(// %s\|/* %s */\)',
                \ 'commentstring': g:tcomment#commentstring_c,
                \ 'rxbeg': '\*\+',
                \ 'rxend': '',
                \ 'rxmid': '',
                \ 'replacements': g:tcomment#replacements_c
                \ }
endif


function! tcomment#GetLineC(...) abort
    let cmt = deepcopy(g:tcomment#line_fmt_c)
    if a:0 >= 1
        let cmt.commentstring = a:1
    endif
    if a:0 >= 2
        let cmt = extend(cmt, a:2)
    endif
    return cmt
endf


if !exists('g:tcomment#inline_fmt_c')
    " Generic c-like comments.
    " :read: let g:tcomment#inline_fmt_c = {...}   "{{{2
    let g:tcomment#inline_fmt_c = tcomment#GetLineC()
endif


if !exists('g:tcomment#block_fmt_c')
    let g:tcomment#block_fmt_c = {
                \ 'commentstring': '/*%s */',
                \ 'middle': ' * ',
                \ 'rxbeg': '\*\+',
                \ 'rxend': '',
                \ 'rxmid': '',
                \ 'replacements': g:tcomment#replacements_c
                \ }
endif
if !exists('g:tcomment#block2_fmt_c')
    " Generic c-like block comments (alternative markup).
    " :read: let g:tcomment#block2_fmt_c = {...}   "{{{2
    let g:tcomment#block2_fmt_c = {
                \ 'commentstring': '/**%s */',
                \ 'middle': ' * ',
                \ 'rxbeg': '\*\+',
                \ 'rxend': '\*\+',
                \ 'rxmid': '\*\+',
                \ 'replacements': g:tcomment#replacements_c
                \ }
endif

if !exists('g:tcomment#replacements_xml')
    " Replacements for xml filetype.
    " :read: let g:tcomment#replacements_xml = {...}   "{{{2
    let g:tcomment#replacements_xml = {
                \     '<!--': '&#60;&#33;&#45;&#45;',
                \     '-->': '&#45;&#45;&#62;',
                \     '&': '&#38;',
                \ }
endif

if !exists('g:tcomment#block_fmt_xml')
    " Generic xml-like block comments.
    " :read: let g:tcomment#block_fmt_xml = {...}   "{{{2
    let g:tcomment#block_fmt_xml = {
                \ 'commentstring': "<!--%s-->\n  ",
                \ 'replacements': g:tcomment#replacements_xml
                \ }
endif
if !exists('g:tcomment#inline_fmt_xml')
    " Generic xml-like comments.
    " :read: let g:tcomment#inline_fmt_xml = {...}   "{{{2
    let g:tcomment#inline_fmt_xml = {
                \ 'commentstring': "<!-- %s -->",
                \ 'replacements': g:tcomment#replacements_xml
                \ }
endif

if !exists('g:tcomment#ignore_comment_def')
    " A list of names or filetypes, which should be ignored by 
    " |tcomment#DefineType()| -- no custom comment definition will be 
    " stored for these names.
    "
    " This variable should be set before loading autoload/tcomment.vim.
    let g:tcomment#ignore_comment_def = []   "{{{2
endif

if !exists('g:tcomment#must_escape_expression_backslash')
    " Users of vim earlier than 7.3 might have to set this variable to 
    " true. Set this variable to 0, if you see unexpected "\r" char 
    " sequences in comments.
    "
    " The recommended value was `!(v:version > 702 || (v:version == 702 && has('patch407')))`.
    " It is now assumed though, that no unpatched versions of vim are in 
    " use.
    "
    " References:
    " Patch 7.2.407  when using :s with an expression backslashes are dropped
    " https://github.com/tomtom/tcomment_vim/issues/102
    let g:tcomment#must_escape_expression_backslash = 0   "{{{2
endif


let s:warning_definetype = 0

function! tcomment#DefineType(...) abort
    if !s:warning_definetype
        echohl WarningMsg
        echom 'tcomment: tcomment#DefineType() is deprecated; please use tcomment#type#Define() instead'
        echom 'tcomment: tcomment#DefineType() will be removed in a future release'
        echohl NONE
        let s:warning_definetype = 1
    endif
    return call('tcomment#type#Define', a:000)
endf


call tcomment#type#Collect()


" A function that makes the tcomment#filetype#Guess() function usable for other 
" library developers.
"
" The argument is a dictionary with the following keys:
"
"   beg ................ (default = line("."))
"   end ................ (default = line("."))
"   comment_mode ........ (default = "G")
"   filetype ........... (default = &filetype)
"   fallbackFiletype ... (default = "")
"
" This function return a dictionary that contains information about how 
" to make comments. The information about the filetype of the text 
" between lines "beg" and "end" is in the "filetype" key of the return 
" value. It returns the first discernible filetype it encounters.
" :display: tcomment#GuessFileType(?options={})
function! tcomment#GuessCommentType(...) abort "{{{3
    let options = a:0 >= 1 ? a:1 : {}
    let beg = get(options, 'beg', line('.'))
    let end = get(options, 'end', line('.'))
    let comment_mode = get(options, 'comment_mode', '')
    let filetype = get(options, 'filetype', &filetype)
    let fallbackFiletype = get(options, 'filetype', '')
    let ct = tcomment#filetype#Guess(beg, end,
          \ comment_mode, filetype, fallbackFiletype)
    call extend(ct, {'_args': {'beg': beg, 'end': end, 'comment_mode': comment_mode, 'filetype': filetype, 'fallbackFiletype': fallbackFiletype}})
    return ct
endf


" tcomment#Comment(line1, line2, ?comment_mode, ?comment_anyway, ?args...)
" args... are either:
"   1. a list of key=value pairs where known keys are (see also 
"      |g:tcomment#options|):
"         as=STRING        ... Use a specific comment definition
"         count=N          ... Repeat the comment string N times
"         col=N            ... Start the comment at column N (in block 
"                              mode; must be smaller than |indent()|)
"         mode=STRING      ... See the notes below on the "comment_mode" argument
"         mode_extra=STRING ... Add to comment_mode
"         begin=STRING     ... Comment prefix
"         end=STRING       ... Comment postfix
"         middle=STRING    ... Middle line comments in block mode
"         rxbeg=N          ... Regexp to find the substring of "begin" 
"                              that should be multiplied by "count"
"         rxend=N          ... The above for "end"
"         rxmid=N          ... The above for "middle"
"         mixedindent=BOOL ... If true, allow use of mixed 
"                              characters for indentation
"         commentstring_rx ... A regexp format string that matches 
"                              commented lines (no new groups may be 
"                              introduced, the |regexp| is |\V|; % have 
"                              to be doubled); "commentstring", "begin" 
"                              and optionally "end" must be defined or 
"                              deducible.
"         whitespace       ... Define whether commented text is 
"                              surrounded with whitespace; if
"                              both ... surround with whitespace (default)
"                              left ... keep whitespace on the left
"                              right... keep whitespace on the right
"                              no   ... don't use whitespace
"         strip_whitespace ... Strip trailing whitespace: if 1 
"                              (default), strip from empty lines only, 
"                              if 2, always strip whitespace; if 0, 
"                              don't strip any whitespace
"         postprocess_uncomment .. Run a |printf()| expression with 2 
"                              placeholders on uncommented lines, e.g. 
"                              'norm! %sgg=%sgg'.
"         choose           ... A list of commend definitions (a 
"                              dictionary as defined above) that may 
"                              contain an `if` key referring to an 
"                              expression; if this condition evaluates 
"                              to true, the item will be selected; the 
"                              last item in the list will be selected 
"                              anyway (see the bib definition for an 
"                              example)
"         if               ... an |eval()|able expression (only valid 
"                              within a choose list, see above)
"   2. 1-2 values for: ?commentPrefix, ?commentPostfix
"   3. a dictionary (internal use only)
"
" comment_mode (see also ¦g:tcomment#mode_extra¦):
"   G ... guess the value of comment_mode
"   B ... block (use extra lines for the comment markers)
"   L ... lines
"   i ... maybe inline, guess
"   I ... inline
"   R ... right (comment the line right of the cursor)
"   v ... visual
"   o ... operator
"   C ... force comment
"   K ... comment only uncommented lines
"   U ... force uncomment (if U and C are present, U wins)
" By default, each line in range will be commented by adding the comment 
" prefix and postfix.
function! tcomment#Comment(beg, end, ...) abort
    let comment_mode0  = tcomment#commentmode#AddExtra((a:0 >= 1 ? a:1 : 'G'), g:tcomment#mode_extra, a:beg, a:end)
    let comment_mode   = comment_mode0
    let comment_anyway = a:0 >= 2 ? (a:2 ==# '!') : 0
    Tlibtrace 'tcomment', a:beg, a:end, comment_mode, comment_anyway, a:000
    " save the cursor position
    if exists('w:tcomment_pos')
        let s:current_pos = copy(w:tcomment_pos)
    else
        let s:current_pos = getpos('.')
    endif
    let cursor_pos = getpos("'>")
    Tlibtrace 'tcomment', cursor_pos
    let s:cursor_pos = []
    if comment_mode =~# 'i'
        let blnum = line("'<")
        if blnum == line("'>")
            if virtcol('.') <= indent(blnum)
                let i_mode = 'G'
            else
                let i_mode = 'I'
            endif
        else
            let i_mode = 'G'
        endif
        let comment_mode = substitute(comment_mode, '\Ci', i_mode, 'g')
        Tlibtrace 'tcomment', 1, comment_mode
    endif
    let [lbeg, cbeg, lend, cend] = tcomment#cursor#GetStartEnd(a:beg, a:end, comment_mode)
    Tlibtrace 'tcomment', lbeg, cbeg, lend, cend, virtcol('$')
    if comment_mode ==? 'I' && comment_mode0 =~# 'i' && lbeg == lend && cend >= virtcol('$') - 1
        let comment_mode = substitute(comment_mode, '\CI', cbeg <= 1 ? 'G' : 'R', 'g')
        Tlibtrace 'tcomment', comment_mode
    endif
    let mode_extra = s:GetTempOption('mode_extra', '')
    Tlibtrace 'tcomment', mode_extra
    if !empty(mode_extra)
        let comment_mode = tcomment#commentmode#AddExtra(comment_mode, mode_extra, lbeg, lend)
        Tlibtrace 'tcomment', "mode_extra", comment_mode
        unlet s:temp_options.mode_extra
    endif
    " get the correct commentstring
    let cdef = copy(g:tcomment#options)
    Tlibtrace 'tcomment', 1, cdef
    if exists('b:tcomment_options')
        let cdef = extend(cdef, copy(b:tcomment_options))
        Tlibtrace 'tcomment', 2, cdef
    endif
    if a:0 >= 3 && type(a:3) == 4
        call extend(cdef, a:3)
        Tlibtrace 'tcomment', 3, cdef
    else
        let cdef0 = tcomment#commentdef#Get(lbeg, lend, comment_mode)
        Tlibtrace 'tcomment', 4.1, cdef, cdef0
        call extend(cdef, cdef0)
        Tlibtrace 'tcomment', 4.2, cdef
        let ax = 3
        if a:0 >= 3 && !empty(a:3) && stridx(a:3, '=') == -1
            let ax = 4
            let cdef.begin = a:3
            if a:0 >= 4 && !empty(a:4) && stridx(a:4, '=') == -1
                let ax = 5
                let cdef.end = a:4
            endif
        endif
        Tlibtrace 'tcomment', ax, a:0, a:000
        if a:0 >= ax
            let cdef = tcomment#commentdef#Extend(lbeg, lend, comment_mode, cdef, s:ParseArgs(lbeg, lend, comment_mode, a:000[ax - 1 : -1]))
            Tlibtrace 'tcomment', 5, cdef
        endif
        if !empty(get(cdef, 'begin', '')) || !empty(get(cdef, 'end', ''))
            let cdef.commentstring = tcomment#format#EncodeCommentPart(get(cdef, 'begin', ''))
                        \ . '%s'
                        \ . tcomment#format#EncodeCommentPart(get(cdef, 'end', ''))
        endif
        let comment_mode = cdef.mode
        Tlibtrace 'tcomment', 2, comment_mode
    endif
    if empty(comment_mode)
        echohl WarningMsg
        echom 'TComment: Comment mode is not supported for the current filetype:' string(comment_mode)
        echohl NONE
        return
    endif
    if exists('s:temp_options')
        let cdef = tcomment#commentdef#Extend(lbeg, lend, comment_mode, cdef, s:temp_options)
        Tlibtrace 'tcomment', 6, cdef
        unlet s:temp_options
    endif
    Tlibtrace 'tcomment', 7, cdef
    if has_key(cdef, 'whitespace')
        call tcomment#commentdef#SetWhitespaceMode(cdef)
    endif
    if !empty(filter(['count', 'cbeg', 'cend', 'cmid'], 'has_key(cdef, v:val)'))
        call tcomment#commentdef#RepeatCommentstring(cdef)
    endif
    let [is_rx, cms0] = tcomment#commentdef#GetBlockCommentRx(cdef)
    Tlibtrace 'tcomment', cms0
    "" make whitespace optional; this conflicts with comments that require some 
    "" whitespace
    let cmsrx = is_rx ? cms0 : escape(cms0, '\')
    let cmt_check = substitute(cmsrx, '\([	 ]\)', '\1\\?', 'g')
    "" turn commentstring into a search pattern
    Tlibtrace 'tcomment', cmt_check
    let cmt_check = tcomment#format#Printf1(cmt_check, '\(\_.\{-}\)')
    Tlibtrace 'tcomment', cdef, cmt_check
    let s:cdef = cdef
    " set comment_mode
    Tlibtrace 'tcomment', comment_mode
    let [lbeg, lend, uncomment] = s:GetCommentGeometry(cdef, lbeg, lend, cmt_check, comment_mode, cbeg, cend)
    Tlibtrace 'tcomment', lbeg, lend, cbeg, cend, uncomment, comment_mode, comment_anyway
    if uncomment
        if comment_mode =~# 'C' || comment_anyway
            let comment_do = 'c'
        else
            let comment_do = 'u'
        endif
    else
        if comment_mode =~# 'U'
            let comment_do = 'u'
        elseif comment_mode =~# 'K'
            let comment_do = 'k'
        else
            let comment_do = 'c'
        endif
    endif
    Tlibtrace 'tcomment', comment_anyway, comment_mode, mode_extra, comment_do
    if comment_do ==# 'c' && comment_mode !~# 'I'
        let cbeg = get(s:cdef, 'col', cbeg)
    endif
    Tlibtrace 'tcomment', cbeg
    " go
    Tlibtrace 'tcomment', comment_mode
    if comment_mode =~# 'B'
        " We want a comment block
        call s:CommentBlock(lbeg, lend, cbeg, cend, comment_mode, comment_do, cmt_check, s:cdef)
    else
        " We want commented lines
        " final search pattern for uncommenting
        let cmt_check   = '\V\^\(\s\{-}\)'. cmt_check .'\$'
        " final pattern for commenting
        let cmt_replace = tcomment#commentdef#GetCommentReplace(s:cdef, cms0)
        Tlibtrace 'tcomment', cmt_replace
        Tlibtrace 'tcomment', comment_mode, lbeg, cbeg, lend, cend
        let s:processline_lnum = lbeg
        let end_rx = tcomment#regex#EndPosRx(comment_mode, lend, cend)
        let postfix_rx = end_rx ==# '\$' ? '' : '\.\*\$'
        let prefix_rx = '\^\.\{-}' . tcomment#regex#StartPosRx(s:cdef, comment_mode, lbeg, cbeg)
        let comment_rx = '\V'
                    \ . '\('. prefix_rx . '\)'
                    \ .'\('
                    \ .'\(\_.\{-}\)'
                    \ . end_rx
                    \ .'\)'
                    \ .'\(' . postfix_rx . '\)'
        Tlibtrace 'tcomment', comment_rx, prefix_rx, end_rx, postfix_rx
        for lnum in range(lbeg, lend)
            let line0 = getline(lnum)
            Tlibtrace 'tcomment', line0
            let lmatch = matchlist(line0, comment_rx)
            Tlibtrace 'tcomment', lmatch
            if empty(lmatch) && g:tcomment#blank_lines >= 2
                let lline0 = tcomment#compatibility#Strdisplaywidth(line0)
                Tlibtrace 'tcomment', lline0, cbeg
                if lline0 < cbeg
                    let line0 = line0 . repeat(' ', cbeg - lline0)
                    let lmatch = [line0, line0, '', '', '']
                    Tlibtrace 'tcomment', 'padded', line0, lmatch
                endif
            endif
            if !empty(lmatch)
                let [part1, ok] = s:ProcessLine(comment_do, lmatch[2], cmt_check, cmt_replace)
                Tlibtrace 'tcomment', part1, ok
                if ok
                    let line1 = lmatch[1] . part1 . lmatch[4]
                    if comment_do ==# 'u'
                        if g:tcomment#rstrip_on_uncomment > 0
                        if g:tcomment#rstrip_on_uncomment == 2 || line1 !~# '\S'
                            let line1 = substitute(line1, '\s\+$', '', '')
                        endif
                        endif
                    endif
                    Tlibtrace 'tcomment', line1
                    if line1 !=# getline(lnum)
                        " Only set the line if it is different, to not 
                        " add an empty undo step.
                        " Ref: https://github.com/vim/vim/issues/2700
                        call setline(lnum, line1)
                    endif
                endif
            endif
        endfor
        if comment_do ==# 'u'
            let postprocess_uncomment = get(cdef, 'postprocess_uncomment', '')
            if !empty(postprocess_uncomment)
                exec printf(postprocess_uncomment, lbeg, lend)
            endif
        endif
    endif
    " reposition cursor
    Tlibtrace 'tcomment', 3, comment_mode
    if !empty(s:cursor_pos)
        let cursor_pos = s:cursor_pos
    endif
    if comment_mode =~# '>'
        call tcomment#cursor#SetPos('.', cursor_pos)
        if comment_mode !~? 'i'
            if comment_mode =~# '>>'
                norm! j^
            elseif comment_mode =~# '>|'
                norm! j
            endif
        endif
    elseif comment_mode =~# '#'
        call tcomment#cursor#SetPos('.', cursor_pos)
        if exists('w:tcomment_pos')
            let w:tcomment_pos = cursor_pos
        endif
    else
        call tcomment#cursor#SetPos('.', s:current_pos)
    endif
    unlet! s:cursor_pos s:current_pos s:cdef
endf


" :display: tcomment#CommentAs(beg, end, comment_anyway, filetype, ?args...)
" Where args is either:
"   1. A count NUMBER
"   2. An args list (see the notes on the "args" argument of 
"      |tcomment#Comment()|)
" comment text as if it were of a specific filetype
function! tcomment#CommentAs(beg, end, comment_anyway, filetype, ...) abort
    if a:filetype =~# '_block$'
        let comment_mode = 'B'
        let ft = substitute(a:filetype, '_block$', '', '')
    elseif a:filetype =~# '_inline$'
        let comment_mode = 'I'
        let ft = substitute(a:filetype, '_inline$', '', '')
    else 
        let comment_mode = 'G'
        let ft = a:filetype
    endif
    if a:0 >= 1
        if type(a:1) == 0
            let cdef = {'count': a:0 >= 1 ? a:1 : 1}
        else
            let cdef = s:ParseArgs(a:beg, a:end, comment_mode, a:000)
        endif
    else
        let cdef = {}
    endif
    call extend(cdef, tcomment#commentdef#GetForType(a:beg, a:end, comment_mode, ft))
    keepjumps call tcomment#Comment(a:beg, a:end, comment_mode, a:comment_anyway, cdef)
endf


function! tcomment#MaybeReuseOptions(name) abort "{{{3
    if exists('s:options_cache') && get(s:options_cache, 'name', '') == a:name
        if exists('s:temp_options')
            let s:temp_options = extend(deepcopy(s:options_cache.options), s:temp_options)
            let s:options_cache = {'name': a:name, 'options': s:temp_options}
        else
            let s:temp_options = deepcopy(s:options_cache.options)
        endif
    elseif exists('s:temp_options')
        let s:options_cache = {'name': a:name, 'options': s:temp_options}
    endif
endf


function! tcomment#ResetOption() abort "{{{3
    unlet! s:temp_options s:options_cache
endf


function! tcomment#SetOption(name, arg) abort "{{{3
    Tlibtrace 'tcomment', a:name, a:arg
    if !exists('s:temp_options')
        let s:temp_options = {}
    endif
    if empty(a:arg)
        if has_key(s:temp_options, a:name)
            call remove(s:temp_options, a:name)
        endif
    else
        let s:temp_options[a:name] = a:arg
    endif
endf


function! s:GetTempOption(name, default) abort "{{{3
    if exists('s:temp_options') && has_key(s:temp_options, a:name)
        return s:temp_options[a:name]
    else
        return a:default
    endif
endf


function! s:ParseArgs(beg, end, comment_mode, arglist) abort "{{{3
    let args = {}
    for arg in a:arglist
        let key = matchstr(arg, '^[^=]\+')
        let value = matchstr(arg, '=\zs.*$')
        if !empty(key)
            let args[key] = value
        endif
    endfor
    return tcomment#commentdef#Extend(a:beg, a:end, a:comment_mode, {}, args)
endf


function! s:GetCommentGeometry(cdef, beg, end, checkRx, comment_mode, cbeg, cend) abort
    Tlibtrace 'tcomment', a:beg, a:end, a:checkRx, a:comment_mode, a:cbeg, a:cend
    let beg = a:beg
    let end = a:end
    if a:comment_mode =~# 'U'
        let uncomment = 1
    elseif a:comment_mode =~# '[CK]'
        let uncomment = 0
    else
        if get(a:cdef, 'mixedindent', 1)
            let mdrx = '\V'. tcomment#regex#StartColRx(a:cdef, a:comment_mode, a:cbeg) .'\s\*'
            let cbeg1 = a:comment_mode =~? 'i' ? a:cbeg : a:cbeg + 1
            let mdrx .= tcomment#regex#StartColRx(a:cdef, a:comment_mode, cbeg1, 0) .'\s\*'
        else
            let mdrx = '\V'. tcomment#regex#StartColRx(a:cdef, a:comment_mode, a:cbeg) .'\s\*'
        endif
        let mdrx .= a:checkRx .'\s\*'. tcomment#regex#EndColRx(a:comment_mode, a:end, 0)
        Tlibtrace 'tcomment', mdrx
        let line = getline(beg)
        if a:cbeg != 0 && a:cend != 0
            let line = strpart(line, 0, a:cend - 1)
        endif
        let uncomment = (line =~ mdrx)
        Tlibtrace 'tcomment', 1, uncomment, line
        let n  = beg + 1
        if a:comment_mode =~# 'G'
            if uncomment
                while n <= end
                    if getline(n) =~# '\S'
                        if !(getline(n) =~ mdrx)
                            let uncomment = 0
                            Tlibtrace 'tcomment', 2, uncomment
                            break
                        endif
                    endif
                    let n = n + 1
                endwh
            endif
        elseif a:comment_mode =~# 'B'
            let t = @t
            try
                silent exec 'norm! '. beg.'G1|v'.end.'G$"ty'
                if &selection ==# 'inclusive' && @t =~# '\n$' && len(@t) > 1
                    let @t = @t[0 : -2]
                endif
                Tlibtrace 'tcomment', @t, mdrx
                let uncomment = (@t =~ mdrx)
                Tlibtrace 'tcomment', 3, uncomment
                if !uncomment && a:comment_mode =~? 'o'
                    let mdrx1 = substitute(mdrx, '\\$$', '\\n\\$', '')
                    Tlibtrace 'tcomment', mdrx1
                    if @t =~ mdrx1
                        let uncomment = 1
                        Tlibtrace 'tcomment', 4, uncomment
                    endif
                endif
            finally
                let @t = t
            endtry
        endif
    endif
    Tlibtrace 'tcomment', 5, beg, end, uncomment
    return [beg, end, uncomment]
endf


function! s:ProcessLine(comment_do, match, checkRx, replace) abort
    Tlibtrace 'tcomment', a:comment_do, a:match, a:checkRx, a:replace
    try
        if !(g:tcomment#blank_lines > 0 || a:match =~# '\S')
            return [a:match, 0]
        endif
        if a:comment_do ==# 'k'
            if a:match =~ a:checkRx
                return ['', 0]
            endif
        endif
        if a:comment_do ==# 'u'
            let m = matchlist(a:match, a:checkRx)
            if !empty(m)
                for irx in range(2, tcomment#regex#Count(a:checkRx, '\\\@<!\\('))
                    if !empty(m[irx])
                        break
                    endif
                endfor
                Tlibtrace 'tcomment', irx
            else
                let irx = 2
            endif
            let rv = substitute(a:match, a:checkRx, '\1\'. irx, '')
            let rv = s:UnreplaceInLine(rv, a:match)
        else
            let ml = len(a:match)
            let rv = s:ReplaceInLine(a:match, a:match)
            let rv = tcomment#format#Printf1(a:replace, rv)
            let strip_whitespace = get(s:cdef, 'strip_whitespace', 1)
            if strip_whitespace == 2 || (strip_whitespace == 1 && ml == 0)
                let rv = substitute(rv, '\s\+$', '', '')
            endif
        endif
        Tlibtrace 'tcomment', rv
        if s:cdef.mode =~# '>'
            let s:cursor_pos = getpos('.')
            let s:cursor_pos[2] += len(rv)
        elseif s:cdef.mode =~# '#'
            if empty(s:cursor_pos) || s:current_pos[1] == s:processline_lnum
                let prefix = matchstr(a:replace, '^.*%\@<!\ze%s')
                let prefix = substitute(prefix, '%\(.\)', '\1', 'g')
                let prefix_len = tcomment#compatibility#Strdisplaywidth(prefix)
                Tlibtrace 'tcomment', a:replace, prefix_len
                if prefix_len != -1
                    let s:cursor_pos = copy(s:current_pos)
                    if a:comment_do ==# 'u'
                        let s:cursor_pos[2] -= prefix_len
                        if s:cursor_pos[2] < 1
                            let s:cursor_pos[2] = 1
                        endif
                    else
                        let s:cursor_pos[2] += prefix_len
                    endif
                endif
            endif
        endif
        Tlibtrace 'tcomment', rv
        if g:tcomment#must_escape_expression_backslash
            let rv = escape(rv, "\\r")
        else
            let rv = escape(rv, "\r")
        endif
        Tlibtrace 'tcomment', rv
        return [rv, 1]
    finally
        let s:processline_lnum += 1
    endtry
endf


function! s:GetReplacements(cdef, text) abort "{{{3
    let replacements = {}
    for [rx, sdef] in items(s:cdef.replacements)
        if type(sdef) == 1
            let replacements[rx] = sdef
        elseif type(sdef) == 4
            if a:text =~# sdef.guard_rx
                let replacements[rx] = sdef.subst
            endif
        else
            throw 'tcomment: Malformed substitute in GetReplacements(): '. rx .' => '. string(sdef)
        endif
    endfor
    return replacements
endf


function! s:ReplaceInLine(text, match) abort "{{{3
    if has_key(s:cdef, 'replacements')
        let replacements = s:GetReplacements(s:cdef, s:cdef.commentstring)
        return s:DoReplacements(a:text, keys(replacements), values(replacements))
    else
        return a:text
    endif
endf


function! s:UnreplaceInLine(text, match) abort "{{{3
    if has_key(s:cdef, 'replacements')
        let replacements = s:GetReplacements(s:cdef, a:match)
        return s:DoReplacements(a:text, values(replacements), keys(replacements))
    else
        return a:text
    endif
endf


function! s:DoReplacements(text, tokens, replacements) abort "{{{3
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
    Tlibtrace 'tcomment', a:text, a:rx, a:replacements
    let matches = split(a:text, '\ze'. a:rx .'\$', 1)
    if len(matches) == 1
        return a:text
    else
        let match = matches[-1]
        let idx = index(a:tokens, match)
        Tlibtrace 'tcomment', matches, match, idx
        if idx != -1
            let matches[-1] = a:replacements[idx]
            Tlibtrace 'tcomment', matches
            return join(matches, '')
        else
            throw 'TComment: Internal error: cannot find '. string(match) .' in '. string(a:tokens)
        endif
    endif
endf


function! s:CommentBlock(beg, end, cbeg, cend, comment_mode, comment_do, checkRx, cdef) abort
    Tlibtrace 'tcomment', a:beg, a:end, a:cbeg, a:cend, a:comment_do, a:checkRx, a:cdef
    let indentStr = repeat(' ', a:cbeg)
    let t = @t
    let sel_save = &selection
    set selection=exclusive
    try
        silent exec 'norm! '. a:beg.'G1|v'.a:end.'G$"td'
        Tlibtrace 'tcomment', @t
        let ms = tcomment#commentdef#BlockGetMiddleString(a:cdef)
        let mx = escape(ms, '\')
        let cs = tcomment#commentdef#BlockGetCommentString(a:cdef)
        let prefix = substitute(matchstr(cs, '^.*%\@<!\ze%s'), '%\(.\)', '\1', 'g')
        let postfix = substitute(matchstr(cs, '%\@<!%s\zs.*$'), '%\(.\)', '\1', 'g')
        Tlibtrace 'tcomment', ms, mx, cs, prefix, postfix
        if a:comment_do ==? 'u'
            let @t = substitute(@t, '\V\^\s\*'. a:checkRx .'\$', '\1', '')
            Tlibtrace 'tcomment', 0, @t
            let tt = []
            " TODO: Correctly handle foreign comments with inconsistent 
            " whitespace around mx markers
            let mx1 = substitute(mx, ' $', '\\( \\?\\$\\| \\)', '')
            Tlibtrace 'tcomment', mx1
            let rx = '\V'. tcomment#regex#StartColRx(a:cdef, a:comment_mode, a:cbeg) . '\zs'. mx1
            Tlibtrace 'tcomment', rx
            for line in split(@t, '\n')
                let line1 = substitute(line, rx, '', '')
                Tlibtrace 'tcomment', line, line1
                let line1 = s:UnreplaceInLine(line1, line)
                call add(tt, line1)
            endfor
            let @t = join(tt, "\n")
            Tlibtrace 'tcomment', 1, @t
            let @t = substitute(@t, '^\n', '', '')
            Tlibtrace 'tcomment', 2, @t
            let @t = substitute(@t, '\n\s*$', '', '')
            Tlibtrace 'tcomment', 3, @t
            if a:comment_mode =~# '#'
                let s:cursor_pos = copy(s:current_pos)
                let prefix_lines = len(substitute(prefix, "[^\n]", '', 'g')) + 1
                let postfix_lines = len(substitute(postfix, "[^\n]", '', 'g')) + 1
                " TODO: more precise solution (when cursor is placed on 
                " postfix or prefix
                if s:cursor_pos[1] > a:beg
                    let s:cursor_pos[1] -= prefix_lines
                    if s:cursor_pos[1] > a:end - postfix_lines
                        let s:cursor_pos[1] -= postfix_lines
                    endif
                    if s:cursor_pos[1] < 1
                        let s:cursor_pos[1] = 1
                    endif
                endif
                let prefix_len = tcomment#compatibility#Strdisplaywidth(mx)
                let s:cursor_pos[2] -= prefix_len
                if s:cursor_pos[2] < 1
                    let s:cursor_pos[2] = 1
                endif
            endif
        else
            let cs = indentStr . substitute(cs, '%\@<!%s', '%s'. indentStr, '')
            Tlibtrace 'tcomment', cs, ms
            if !empty(ms)
                let lines = []
                let lnum = 0
                let indentlen = a:cbeg
                let rx = '^.\{-}\%>'. indentlen .'v\zs'
                Tlibtrace 'tcomment', indentStr, indentlen, rx, @t, empty(@t)
                if @t =~# '^\n\?$'
                    let lines = [indentStr . ms]
                    let cs .= "\n"
                    Tlibtrace 'tcomment', 1, lines
                else
                    for line in split(@t, '\n')
                        Tlibtrace 'tcomment', 1, line
                        let line = s:ReplaceInLine(line, line)
                        if line =~# '^\s*' && tcomment#compatibility#Strdisplaywidth(line) < indentlen
                            let line = indentStr . ms
                        elseif lnum == 0
                            let line = substitute(line, rx, ms, '')
                        else
                            let line = substitute(line, rx, mx, '')
                        endif
                        Tlibtrace 'tcomment', 2, line
                        call add(lines, line)
                        let lnum += 1
                    endfor
                    Tlibtrace 'tcomment', 2, lines
                endif
                let @t = join(lines, "\n")
                Tlibtrace 'tcomment', 3, @t
            endif
            let @t = tcomment#format#Printf1(cs, "\n". @t ."\n")
            Tlibtrace 'tcomment', 4, cs, @t, a:comment_mode
            if a:comment_mode =~# '#'
                let s:cursor_pos = copy(s:current_pos)
                let s:cursor_pos[1] += len(substitute(prefix, "[^\n]", '', 'g')) + 1
                let prefix_len = tcomment#compatibility#Strdisplaywidth(mx)
                let s:cursor_pos[2] += prefix_len
            endif
        endif
        silent norm! "tP
    finally
        let &selection = sel_save
        let @t = t
    endtry
endf


" vi: ft=vim:tw=72:ts=4:fo=w2croql
