" @Author:      Tom Link (mailto:micathom AT gmail com?subject=[vim])
" @Website:     http://www.vim.org/account/profile.php?user_id=4037
" @License:     GPL (see http://www.gnu.org/licenses/gpl.txt)
" @Created:     2007-09-17.
" @Last Change: 2018-03-18.
" @Revision:    1907

scriptencoding utf-8

" call tlog#Log('Load: '. expand('<sfile>')) " vimtlib-sfile
if exists(':Tlibtrace') != 2
    " :nodoc:
    command! -nargs=+ -bang Tlibtrace :
endif
if exists(':Tlibassert') != 2
    " :nodoc:
    command! -nargs=+ -bang Tlibassert :
endif
if exists(':Tlibtype') != 2
    " :nodoc:
    command! -nargs=+ Tlibtype :
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

if !exists('g:tcommentModeExtra')
    " Modifies how commenting works.
    "   >  ... Move the cursor to the end of the comment
    "   >> ... Like above but move the cursor to the next line
    "   #  ... Move the cursor to the position of the commented text 
    "          (NOTE: this only works when creating empty comments using 
    "          |:TCommentInline| from normal or insert mode and should 
    "          not be set here as a global option.)
    let g:tcommentModeExtra = ''   "{{{2
endif

if !exists('g:tcommentOpModeExtra')
    " Modifies how the operator works.
    " See |g:tcommentModeExtra| for a list of possible values.
    let g:tcommentOpModeExtra = ''   "{{{2
endif

if !exists('g:tcommentOptions')
    " Other key-value options used by |tcomment#Comment()|.
    "
    " Examples:
    " Put the opening comment marker always in the first column 
    " regardless of the block's indentation, put this into your |vimrc| 
    " file: >
    "   let g:tcommentOptions = {'col': 1}
    "
    " Indent uncommented lines: >
    "   let g:tcommentOptions = {'postprocess_uncomment': 'norm! %sgg=%sgg'}
    let g:tcommentOptions = {}   "{{{2
endif

if !exists('g:tcomment#options_comments')
    " Additional args for |tcomment#Comment()| when using the 'comments' 
    " option.
    let g:tcomment#options_comments = {'whitespace': get(g:tcommentOptions, 'whitespace', 'both')}   "{{{2
endif

if !exists('g:tcomment#options_commentstring')
    " Additional args for |tcomment#Comment()| when using the 
    " 'commentstring' option.
    let g:tcomment#options_commentstring = {'whitespace': get(g:tcommentOptions, 'whitespace', 'both')}   "{{{2
endif

if !exists('g:tcomment#ignore_char_type')
    " |text-objects| for use with |tcomment#Operator| can have different 
    " types: line, block, char etc. Text objects like aB, it, at etc. 
    " have type char but this may not work reliably. By default, 
    " tcomment handles those text objects most often as if they were of 
    " type line. Set this variable to 0 in order to change this 
    " behaviour. Be prepared that the result may not always match your 
    " intentions.
    let g:tcomment#ignore_char_type = 1   "{{{2
endif

if !exists('g:tcommentGuessFileType')
    " Guess the file type based on syntax names always or for some fileformat only
    " If non-zero, try to guess filetypes.
    " tcomment also checks g:tcommentGuessFileType_{&filetype} for 
    " filetype specific values.
    "
    " Values:
    "   0        ... don't guess
    "   1        ... guess
    "   FILETYPE ... assume this filetype
    let g:tcommentGuessFileType = 0   "{{{2
endif
if !exists('g:tcommentGuessFileType_blade')
    " See |g:tcommentGuessFileType_php|.
    let g:tcommentGuessFileType_blade = 'html'   "{{{2
endif
if !exists('g:tcommentGuessFileType_django')
    let g:tcommentGuessFileType_django = 1   "{{{2
endif
if !exists('g:tcommentGuessFileType_dsl')
    " For dsl documents, assume filetype = xml.
    let g:tcommentGuessFileType_dsl = 'xml'   "{{{2
endif
if !exists('g:tcommentGuessFileType_eruby')
    let g:tcommentGuessFileType_eruby = 1   "{{{2
endif
if !exists('g:tcommentGuessFileType_html')
    let g:tcommentGuessFileType_html = 1   "{{{2
endif
if !exists('g:tcommentGuessFileType_jinja')
    let g:tcommentGuessFileType_jinja = 'html'   "{{{2
endif
if !exists('g:tcommentGuessFileType_php')
    " In php documents, the php part is usually marked as phpRegion. We 
    " thus assume that the buffers default comment style isn't php but 
    " html.
    let g:tcommentGuessFileType_php = 'html'   "{{{2
endif
if !exists('g:tcommentGuessFileType_rmd')
    let g:tcommentGuessFileType_rmd = 'markdown'   "{{{2
endif
if !exists('g:tcommentGuessFileType_rnoweb')
    let g:tcommentGuessFileType_rnoweb = 'r'   "{{{2
endif
if !exists('g:tcommentGuessFileType_smarty')
    let g:tcommentGuessFileType_smarty = 1   "{{{2
endif
if !exists('g:tcommentGuessFileType_tskeleton')
    let g:tcommentGuessFileType_tskeleton = 1   "{{{2
endif
if !exists('g:tcommentGuessFileType_vim')
    let g:tcommentGuessFileType_vim = 1   "{{{2
endif
if !exists('g:tcommentGuessFileType_vue')
    let g:tcommentGuessFileType_vue = 'html'   "{{{2
endif

if !exists('g:tcommentIgnoreTypes_php')
    " In php files, some syntax regions are wrongly highlighted as sql 
    " markup. We thus ignore sql syntax when guessing the filetype in 
    " php files.
    let g:tcommentIgnoreTypes_php = 'sql'   "{{{2
endif

if !exists('g:tcommentIgnoreTypes_blade')
    let g:tcommentIgnoreTypes_blade = 'html'   "{{{2
endif

if !exists('g:tcomment#syntax_substitute')
    " :read: let g:tcomment#syntax_substitute = {...}   "{{{2
    " Perform replacements on the syntax name.
    let g:tcomment#syntax_substitute = {
                \ '\C^javaScript\ze\(\u\|$\)': {'sub': 'javascript'},
                \ '\C^js\ze\(\u\|$\)': {'sub': 'javascript'}
                \ }
endif

if !exists('g:tcomment#filetype_map')
    " Keys must match the full |filetype|. Regexps must be |magic|. No 
    " regexp modifiers (like |\V|) are allowed.
    " let g:tcomment#filetype_map = {...}   "{{{2
    let g:tcomment#filetype_map = {
                \ 'cpp.doxygen': 'cpp',
                \ 'mkd': 'html',
                \ 'rails-views': 'html',
                \ 'tblgen': 'cpp',
                \ }
endif

if !exists('g:tcommentSyntaxMap')
    " tcomment guesses filetypes based on the name of the current syntax 
    " region. This works well if the syntax names match 
    " /filetypeSomeName/. Other syntax names have to be explicitly 
    " mapped onto the corresponding filetype.
    " :read: let g:tcommentSyntaxMap = {...}   "{{{2
    let g:tcommentSyntaxMap = {
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

if !exists('g:tcomment#replacements_c')
    " Replacements for c filetype.
    " :read: let g:tcomment#replacements_c = {...}   "{{{2
    let g:tcomment#replacements_c = {
                \     '/*': '#<{(|',
                \     '*/': '|)}>#',
                \ }
endif

if !exists('g:tcommentLineC_fmt')
    " Generic c-like block comments.
    let g:tcommentLineC_fmt = {
                \ 'commentstring_rx': '\%%(// %s\|/* %s */\)',
                \ 'commentstring': '/* %s */',
                \ 'rxbeg': '\*\+',
                \ 'rxend': '',
                \ 'rxmid': '',
                \ 'replacements': g:tcomment#replacements_c
                \ }
endif


function! tcomment#GetLineC(...) abort
    let cmt = deepcopy(g:tcommentLineC_fmt)
    if a:0 >= 1
        let cmt.commentstring = a:1
    endif
    return cmt
endf


if !exists('g:tcommentInlineC')
    " Generic c-like comments.
    " :read: let g:tcommentInlineC = {...}   "{{{2
    let g:tcommentInlineC = tcomment#GetLineC()
endif


if !exists('g:tcommentBlockC')
    let g:tcommentBlockC = {
                \ 'commentstring': '/*%s */',
                \ 'middle': ' * ',
                \ 'rxbeg': '\*\+',
                \ 'rxend': '',
                \ 'rxmid': '',
                \ 'replacements': g:tcomment#replacements_c
                \ }
endif
if !exists('g:tcommentBlockC2')
    " Generic c-like block comments (alternative markup).
    " :read: let g:tcommentBlockC2 = {...}   "{{{2
    let g:tcommentBlockC2 = {
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
                \     '-': '&#45;',
                \     '&': '&#38;',
                \ }
endif

if !exists('g:tcommentBlockXML')
    " Generic xml-like block comments.
    " :read: let g:tcommentBlockXML = {...}   "{{{2
    let g:tcommentBlockXML = {
                \ 'commentstring': "<!--%s-->\n  ",
                \ 'replacements': g:tcomment#replacements_xml
                \ }
endif
if !exists('g:tcommentInlineXML')
    " Generic xml-like comments.
    " :read: let g:tcommentInlineXML = {...}   "{{{2
    let g:tcommentInlineXML = {
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
    " The reommended value was `!(v:version > 702 || (v:version == 702 && has('patch407')))`.
    " It is now assumed though, that no unpatched versions of vim are in 
    " use.
    "
    " References:
    " Patch 7.2.407  when using :s with an expression backslashes are dropped
    " https://github.com/tomtom/tcomment_vim/issues/102
    let g:tcomment#must_escape_expression_backslash = 0   "{{{2
endif

" :doc:
" A dictionary of NAME => COMMENT DEFINITION (see |tcomment#DefineType|) 
" that can be set in vimrc to override tcomment's default comment 
" styles.
" :read: let g:tcomment_types = {} "{{{2
if exists('g:tcomment_types')
    for [s:name, s:def] in items(g:tcomment_types)
        call tcomment#DefineType(s:name, s:def)
    endfor
    unlet! s:name s:def
endif

let s:types_dirty = 1

let s:definitions = {}

" If you don't explicitly define a comment style, |:TComment| will use 
" 'commentstring' instead. We override the default values here in order 
" to have a blank after the comment marker. Block comments work only if 
" we explicitly define the markup.
"
" NAME usually is a 'filetype'. You can use special suffixes to define 
" special comment types. E.g. the name "FILETYPE_block" is used for 
" block comments for 'filetype'. The name "FILETYPE_inline" is used for 
" inline comments. If no specialized comment definition exists, the 
" normal one with name "FILETYPE" is used.
"
" The comment definition can be either a string or a dictionary.
"
" If it is a string:
" The format for block comments is similar to 'commentstrings' with the 
" exception that the format strings for blocks can contain a second line 
" that defines how "middle lines" (see :h format-comments) should be 
" displayed.
"
" Example: If the string is "--%s--\n-- ", lines will be commented as 
" "--%s--" but the middle lines in block comments will be commented as 
" "--%s".
"
" If it is a dictionary:
" See the help on the args argument of |tcomment#Comment| (see item 1, 
" args is a list of key=value pairs) to find out which fields can be 
" used.
" :display: tcomment#DefineType(name, commentdef, ?cdef={}, ?anyway=0)
function! tcomment#DefineType(name, commentdef, ...) abort
    let basename = matchstr(a:name, '^[^_]\+')
    let use = a:0 >= 2 ? a:2 : len(filter(copy(g:tcomment#ignore_comment_def), 'v:val == basename')) == 0
    " TLogVAR a:name, use
    if use
        if type(a:commentdef) == 4
            let cdef = copy(a:commentdef)
        else
            let cdef = a:0 >= 1 ? a:1 : {}
            let cdef.commentstring = a:commentdef
        endif
        let s:definitions[a:name] = cdef
    endif
    let s:types_dirty = 1
endf

" Return the comment definition for NAME.
"                                                       *b:tcomment_def_{NAME}*
" Return b:tcomment_def_{NAME} if the variable exists. Otherwise return 
" the comment definition as set with |tcomment#DefineType|.
function! tcomment#GetCommentDef(name, ...) abort
    if exists('b:tcomment_def_'. a:name)
        return b:tcomment_def_{a:name}
    else
        return get(s:definitions, a:name, a:0 >= 1 ? a:1 : '')
    endif
endf

" :nodoc:
" Return 1 if a comment type is defined.
function! tcomment#TypeExists(name, ...) abort
    let comment_mode = a:0 >= 1 ? a:1 : ''
    let name = a:name
    if comment_mode =~? 'b'
        let name .= '_block'
    elseif comment_mode =~? 'i'
        let name .= '_inline'
    endif
    return has_key(s:definitions, name) ? name : ''
endf


" tcomment#Comment(line1, line2, ?comment_mode, ?comment_anyway, ?args...)
" args... are either:
"   1. a list of key=value pairs where known keys are (see also 
"      |g:tcommentOptions|):
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
"   2. 1-2 values for: ?commentPrefix, ?commentPostfix
"   3. a dictionary (internal use only)
"
" comment_mode (see also ¦g:tcommentModeExtra¦):
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
    let comment_mode0  = tcomment#commentmode#AddExtra((a:0 >= 1 ? a:1 : 'G'), g:tcommentModeExtra, a:beg, a:end)
    let comment_mode   = comment_mode0
    let comment_anyway = a:0 >= 2 ? (a:2 ==# '!') : 0
    " TLogVAR a:beg, a:end, comment_mode, comment_anyway, a:000
    " save the cursor position
    if exists('w:tcomment_pos')
        let s:current_pos = copy(w:tcomment_pos)
    else
        let s:current_pos = getpos('.')
    endif
    " echom "DBG current_pos=" string(s:current_pos)
    let cursor_pos = getpos("'>")
    " TLogVAR cursor_pos
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
        " TLogVAR 1, comment_mode
    endif
    let [lbeg, cbeg, lend, cend] = tcomment#cursor#GetStartEnd(a:beg, a:end, comment_mode)
    " TLogVAR lbeg, cbeg, lend, cend, virtcol('$')
    if comment_mode ==? 'I' && comment_mode0 =~# 'i' && lbeg == lend && cend >= virtcol('$') - 1
        let comment_mode = substitute(comment_mode, '\CI', cbeg <= 1 ? 'G' : 'R', 'g')
        " TLogVAR comment_mode
    endif
    let mode_extra = s:GetTempOption('mode_extra', '')
    " TLogVAR mode_extra
    if !empty(mode_extra)
        let comment_mode = tcomment#commentmode#AddExtra(comment_mode, mode_extra, lbeg, lend)
        " TLogVAR "mode_extra", comment_mode
        unlet s:temp_options.mode_extra
    endif
    " get the correct commentstring
    let cdef = copy(g:tcommentOptions)
    " TLogVAR 1, cdef
    if exists('b:tcommentOptions')
        let cdef = extend(cdef, copy(b:tcommentOptions))
        " TLogVAR 2, cdef
    endif
    if a:0 >= 3 && type(a:3) == 4
        call extend(cdef, a:3)
        " TLogVAR 3, cdef
    else
        let cdef0 = s:GetCommentDefinition(lbeg, lend, comment_mode)
        " TLogVAR 4.1, cdef, cdef0
        call extend(cdef, cdef0)
        " TLogVAR 4.2, cdef
        let ax = 3
        if a:0 >= 3 && !empty(a:3) && stridx(a:3, '=') == -1
            let ax = 4
            let cdef.begin = a:3
            if a:0 >= 4 && !empty(a:4) && stridx(a:4, '=') == -1
                let ax = 5
                let cdef.end = a:4
            endif
        endif
        " TLogVAR ax, a:0, a:000
        if a:0 >= ax
            " let cdef = extend(cdef, s:ParseArgs(lbeg, lend, comment_mode, a:000[ax - 1 : -1]))
            let cdef = s:ExtendCDef(lbeg, lend, comment_mode, cdef, s:ParseArgs(lbeg, lend, comment_mode, a:000[ax - 1 : -1]))
            " TLogVAR 5, cdef
        endif
        if !empty(get(cdef, 'begin', '')) || !empty(get(cdef, 'end', ''))
            let cdef.commentstring = s:EncodeCommentPart(get(cdef, 'begin', ''))
                        \ . '%s'
                        \ . s:EncodeCommentPart(get(cdef, 'end', ''))
        endif
        let comment_mode = cdef.mode
        " TLogVAR 2, comment_mode
    endif
    if empty(comment_mode)
        echohl WarningMsg
        echom 'TComment: Comment mode is not supported for the current filetype:' string(comment_mode)
        echohl NONE
        return
    endif
    if exists('s:temp_options')
        let cdef = s:ExtendCDef(lbeg, lend, comment_mode, cdef, s:temp_options)
        " TLogVAR 6, cdef
        " echom "DBG s:temp_options" string(s:temp_options)
        unlet s:temp_options
    endif
    " TLogVAR 7, cdef
    if has_key(cdef, 'whitespace')
        call tcomment#commentstring#SetWhitespaceMode(cdef)
    endif
    if !empty(filter(['count', 'cbeg', 'cend', 'cmid'], 'has_key(cdef, v:val)'))
        call tcomment#commentstring#RepeatCommentstring(cdef)
    endif
    " echom "DBG" string(a:000)
    let cms0 = tcomment#commentstring#getBlockCommentRx(cdef)
    " TLogVAR cms0
    "" make whitespace optional; this conflicts with comments that require some 
    "" whitespace
    let cmt_check = substitute(cms0, '\([	 ]\)', '\1\\?', 'g')
    "" turn commentstring into a search pattern
    " TLogVAR cmt_check
    let cmt_check = tcomment#regex#Printf1(cmt_check, '\(\_.\{-}\)')
    " TLogVAR cdef, cmt_check
    let s:cdef = cdef
    " set comment_mode
    " TLogVAR comment_mode
    let [lbeg, lend, uncomment] = s:CommentDef(lbeg, lend, cmt_check, comment_mode, cbeg, cend)
    " TLogVAR lbeg, lend, cbeg, cend, uncomment, comment_mode, comment_anyway
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
    " TLogVAR comment_anyway, comment_mode, mode_extra, comment_do
    " " echom "DBG" string(s:cdef)
    if comment_do ==# 'c' && comment_mode !~# 'I'
        let cbeg = get(s:cdef, 'col', cbeg)
    endif
    " TLogVAR cbeg
    " go
    " TLogVAR comment_mode
    if comment_mode =~# 'B'
        " We want a comment block
        call s:CommentBlock(lbeg, lend, cbeg, cend, comment_mode, comment_do, cmt_check, s:cdef)
    else
        " We want commented lines
        " final search pattern for uncommenting
        let cmt_check   = '\V\^\(\s\{-}\)'. cmt_check .'\$'
        " let cmt_check   = escape(cmt_check, '"/\')
        " final pattern for commenting
        let cmt_replace = tcomment#commentstring#getCommentReplace(s:cdef, cms0)
        " TLogVAR cmt_replace
        " TLogVAR comment_mode, lbeg, cbeg, lend, cend
        let s:processline_lnum = lbeg
        let end_rx = s:EndPosRx(comment_mode, lend, cend)
        let postfix_rx = end_rx ==# '\$' ? '' : '\.\*\$'
        let prefix_rx = '\^\.\{-}' . s:StartPosRx(comment_mode, lbeg, cbeg)
        let comment_rx = '\V'
                    \ . '\('. prefix_rx . '\)'
                    \ .'\('
                    \ .'\(\_.\{-}\)'
                    \ . end_rx
                    \ .'\)'
                    \ .'\(' . postfix_rx . '\)'
        " TLogVAR comment_rx, prefix_rx, end_rx, postfix_rx
        " let @x = comment_rx " DBG
        for lnum in range(lbeg, lend)
            let line0 = getline(lnum)
            " TLogVAR line0
            let lmatch = matchlist(line0, comment_rx)
            " TLogVAR lmatch
            if empty(lmatch) && g:tcomment#blank_lines >= 2
                let lline0 = s:Strdisplaywidth(line0)
                " TLogVAR lline0, cbeg
                if lline0 < cbeg
                    let line0 = line0 . repeat(' ', cbeg - lline0)
                    let lmatch = [line0, line0, '', '', '']
                    " TLogVAR 'padded', line0, lmatch
                endif
            endif
            if !empty(lmatch)
                let [part1, ok] = s:ProcessLine(comment_do, lmatch[2], cmt_check, cmt_replace)
                " TLogVAR part1, ok
                if ok
                    let line1 = lmatch[1] . part1 . lmatch[4]
                    if comment_do ==# 'u'
                        if g:tcomment#rstrip_on_uncomment > 0
                        if g:tcomment#rstrip_on_uncomment == 2 || line1 !~# '\S'
                            let line1 = substitute(line1, '\s\+$', '', '')
                        endif
                        endif
                    endif
                    " TLogVAR line1
                    call setline(lnum, line1)
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
    " TLogVAR 3, comment_mode
    " echom "DBG s:cursor_pos" string(s:cursor_pos)
    if !empty(s:cursor_pos)
        let cursor_pos = s:cursor_pos
    endif
    if comment_mode =~# '>'
        call setpos('.', cursor_pos)
        if comment_mode !~? 'i' && comment_mode =~# '>>'
            norm! l^
        endif
    elseif comment_mode =~# '#'
        call setpos('.', cursor_pos)
        if exists('w:tcomment_pos')
            let w:tcomment_pos = cursor_pos
        endif
    else
        call setpos('.', s:current_pos)
    endif
    unlet! s:cursor_pos s:current_pos s:cdef
endf


if v:version >= 703
    function! s:Strdisplaywidth(...) abort "{{{3
        return call('strdisplaywidth', a:000)
    endf
else
    function! s:Strdisplaywidth(string, ...) abort "{{{3
        " NOTE: Col argument is ignored
        return strlen(substitute(a:string, '.', 'x', 'g'))
    endf
endif


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


function! s:GetTempOption(name, default) abort "{{{3
    if exists('s:temp_options') && has_key(s:temp_options, a:name)
        return s:temp_options[a:name]
    else
        return a:default
    endif
endf


function! tcomment#ResetOption() abort "{{{3
    unlet! s:temp_options s:options_cache
endf


function! tcomment#SetOption(name, arg) abort "{{{3
    " TLogVAR a:name, a:arg
    if !exists('s:temp_options')
        let s:temp_options = {}
    endif
    " if index(['count', 'as'], a:name) != -1
        if empty(a:arg)
            if has_key(s:temp_options, a:name)
                call remove(s:temp_options, a:name)
            endif
        else
            let s:temp_options[a:name] = a:arg
        endif
    " endif
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
    return s:ExtendCDef(a:beg, a:end, a:comment_mode, {}, args)
endf


function! s:ExtendCDef(beg, end, comment_mode, cdef, args) abort
    for [key, value] in items(a:args)
        " TLogVAR key, value
        if key ==# 'as'
            call extend(a:cdef, s:GetCommentDefinitionForType(a:beg, a:end, a:comment_mode, value))
        elseif key ==# 'mode'
            " let a:cdef[key] = a:comment_mode . value
            let a:cdef.mode = tcomment#commentmode#AddExtra(a:comment_mode, value, a:beg, a:end)
        elseif key ==# 'mode_extra'
            if has_key(a:cdef, 'mode')
                let mode = tcomment#commentmode#AddExtra(a:comment_mode, a:cdef.mode, a:beg, a:end)
                " TLogVAR 'mode', mode
            else
                let mode = a:comment_mode
                " TLogVAR 'mode == comment_mode', mode
            endif
            let a:cdef.mode = tcomment#commentmode#AddExtra(mode, value, a:beg, a:end)
        elseif key ==# 'count'
            let a:cdef[key] = str2nr(value)
        else
            let a:cdef[key] = value
        endif
        " TLogVAR get(a:cdef, 'comment_mode', '')
    endfor
    return a:cdef
endf


function! tcomment#Operator(type, ...) abort "{{{3
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
        " echom "DBG tcomment#Operator" lbeg virtcol("'[") virtcol("'<") lend virtcol("']") virtcol("'>")
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


function! tcomment#OperatorLine(type) abort "{{{3
    " TLogVAR a:type
    call tcomment#Operator('line', 'L')
endf


function! tcomment#OperatorAnyway(type) abort "{{{3
    " TLogVAR a:type
    call tcomment#Operator(a:type, '', '!')
endf


function! tcomment#OperatorLineAnyway(type) abort "{{{3
    " TLogVAR a:type
    call tcomment#Operator('line', 'L', '!')
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
    " echom "DBG" string(cdef)
    call extend(cdef, s:GetCommentDefinitionForType(a:beg, a:end, comment_mode, ft))
    keepjumps call tcomment#Comment(a:beg, a:end, comment_mode, a:comment_anyway, cdef)
endf


" collect all known comment types
" :nodoc:
function! tcomment#CollectFileTypes() abort
    if s:types_dirty
        let s:types = keys(s:definitions)
        let s:types_rx = '\V\^\('. join(s:types, '\|') .'\)\(\u\.\*\)\?\$'
        let s:types_dirty = 0
    endif
endf

call tcomment#CollectFileTypes()


" return a list of filetypes for which a tcomment_{&ft} is defined
" :nodoc:
function! tcomment#Complete(ArgLead, CmdLine, CursorPos) abort "{{{3
    call tcomment#CollectFileTypes()
    let completions = copy(s:types)
    let filetype = tcomment#filetype#Get()
    if index(completions, filetype) != -1
        " TLogVAR filetype
        call insert(completions, filetype)
    endif
    if !empty(a:ArgLead)
        call filter(completions, 'v:val =~ ''\V\^''.a:ArgLead')
    endif
    let completions += tcomment#CompleteArgs(a:ArgLead, a:CmdLine, a:CursorPos)
    return completions
endf


let s:first_completion = 0

" :nodoc:
function! tcomment#CompleteArgs(ArgLead, CmdLine, CursorPos) abort "{{{3
    if v:version < 703 && !s:first_completion
        redraw
        let s:first_completion = 1
    endif
    let completions = ['as=', 'col=', 'count=', 'mode=', 'begin=', 'end=', 'rxbeg=', 'rxend=', 'rxmid=']
    if !empty(a:ArgLead)
        if a:ArgLead =~# '^as='
            call tcomment#CollectFileTypes()
            let completions += map(copy(s:types), '"as=". v:val')
        endif
        call filter(completions, 'v:val =~ ''\V\^''.a:ArgLead')
    endif
    return completions
endf


function! s:EncodeCommentPart(string) abort
    return substitute(a:string, '%', '%%', 'g')
endf


function! s:GetCommentDefinitionForType(beg, end, comment_mode, filetype) abort "{{{3
    let cdef = s:GetCommentDefinition(a:beg, a:end, a:comment_mode, a:filetype)
    " TLogVAR cdef
    let cms  = cdef.commentstring
    let comment_mode = cdef.mode
    let pre  = substitute(cms, '%\@<!%s.*$', '', '')
    let pre  = substitute(pre, '%%', '%', 'g')
    let post = substitute(cms, '^.\{-}%\@<!%s', '', '')
    let post = substitute(post, '%%', '%', 'g')
    let cdef.begin = pre
    let cdef.end   = post
    return cdef
endf


" s:GetCommentDefinition(beg, end, comment_mode, ?filetype="")
function! s:GetCommentDefinition(beg, end, comment_mode, ...) abort
    let ft = a:0 >= 1 ? a:1 : ''
    Tlibtrace 'tcomment', a:beg, a:end, a:comment_mode, ft
    if !empty(ft)
        let cdef = tcomment#commentstring#GetCustom(ft, a:comment_mode)
    else
        let cdef = {'mode': a:comment_mode}
    endif
    " TLogVAR cdef
    let cms = get(cdef, 'commentstring', '')
    if empty(cms)
        let filetype = tcomment#filetype#Get(ft)
        Tlibtrace 'tcomment', filetype
        if exists('b:commentstring')
            let cms = b:commentstring
            " TLogVAR 1, cms
            return tcomment#commentstring#GetCustom(filetype, a:comment_mode, cms)
        elseif exists('b:commentStart') && !empty(b:commentStart)
            let cms = s:EncodeCommentPart(b:commentStart) .' %s'
            " TLogVAR 2, cms
            if exists('b:commentEnd') && !empty(b:commentEnd)
                let cms = cms .' '. s:EncodeCommentPart(b:commentEnd)
            endif
            return tcomment#commentstring#GetCustom(filetype, a:comment_mode, cms)
        else
            let [use_guess_ft, alt_filetype] = tcomment#filetype#GetAlt(ft, cdef)
            Tlibtrace 'tcomment', use_guess_ft, alt_filetype
            if use_guess_ft
                return s:GuessFileType(a:beg, a:end,
                      \ a:comment_mode, filetype, alt_filetype,
                      \ s:types_rx)
            else
                let guess_cdef = tcomment#commentstring#GuessVimOptions(a:comment_mode)
                " TLogVAR guess_cdef
                return tcomment#commentstring#GetCustom(filetype, a:comment_mode, guess_cdef.commentstring, guess_cdef)
            endif
        endif
        let cdef.commentstring = cms
    endif
    return cdef
endf


function! s:StartColRx(comment_mode, col, ...) abort
    let mixedindent = a:0 >= 1 ? a:1 : get(s:cdef, 'mixedindent', 1)
    " TLogVAR a:comment_mode, a:col, mixedindent
    if a:comment_mode =~# '[IR]'
        let col = mixedindent ? a:col - 1 : a:col
        let c0 = 1
    else
        let col = a:col
        let c0 = 2
    endif
    " TLogVAR col, c0, mixedindent
    if col < c0
        return '\^'
    elseif mixedindent
        return '\%>'. col .'v'
    else
        return '\%'. col .'v'
    endif
endf


function! s:EndColRx(comment_mode, lnum, pos) abort
    " TLogVAR a:comment_mode, a:lnum, a:pos
    let line = getline(a:lnum)
    let cend = s:Strdisplaywidth(line)
    " TLogVAR cend
    if a:pos == 0 || a:pos >= cend
        return '\$'
    else
        if a:comment_mode =~? 'i' && a:comment_mode =~# 'o'
            let mod = '>'
        else
            let mod = ''
        endif
        " TLogVAR &selection, mod
        return '\%'. mod . a:pos .'v'
    endif
endf


function! s:StartPosRx(comment_mode, line, col) abort
    " TLogVAR a:comment_mode, a:line, a:col
    " if a:comment_mode =~# 'I'
    "     return s:StartLineRx(a:line) . s:StartColRx(a:comment_mode, a:col)
    " else
        let rv = s:StartColRx(a:comment_mode, a:col)
    " endif
    " TLogVAR rv
    return rv
endf


function! s:EndPosRx(comment_mode, lnum, col) abort
    " TLogVAR a:comment_mode, a:lnum, a:col
    " if a:comment_mode =~# 'I'
    "     return s:EndLineRx(a:lnum) . s:EndColRx(a:col)
    " else
        return s:EndColRx(a:comment_mode, a:lnum, a:col)
    " endif
endf


function! s:StartLineRx(pos) abort
    return '\%'. a:pos .'l'
endf


function! s:EndLineRx(pos) abort
    return '\%'. a:pos .'l'
endf



function! s:CommentDef(beg, end, checkRx, comment_mode, cbeg, cend) abort
    " TLogVAR a:beg, a:end, a:checkRx, a:comment_mode, a:cbeg, a:cend
    let beg = a:beg
    let end = a:end
    if a:comment_mode =~# 'U'
        let uncomment = 1
    elseif a:comment_mode =~# '[CK]'
        let uncomment = 0
    else
        if get(s:cdef, 'mixedindent', 1)
            let mdrx = '\V'. s:StartColRx(a:comment_mode, a:cbeg) .'\s\*'
            let cbeg1 = a:comment_mode =~? 'i' ? a:cbeg : a:cbeg + 1
            let mdrx .= s:StartColRx(a:comment_mode, cbeg1, 0) .'\s\*'
        else
            let mdrx = '\V'. s:StartColRx(a:comment_mode, a:cbeg) .'\s\*'
        endif
        let mdrx .= a:checkRx .'\s\*'. s:EndColRx(a:comment_mode, a:end, 0)
        " let mdrx = '\V'. s:StartPosRx(a:comment_mode, beg, a:cbeg) .'\s\*'. a:checkRx .'\s\*'. s:EndPosRx(a:comment_mode, end, 0)
        " TLogVAR mdrx
        let line = getline(beg)
        if a:cbeg != 0 && a:cend != 0
            let line = strpart(line, 0, a:cend - 1)
        endif
        let uncomment = (line =~ mdrx)
        " TLogVAR 1, uncomment, line
        let n  = beg + 1
        if a:comment_mode =~# 'G'
            if uncomment
                while n <= end
                    if getline(n) =~# '\S'
                        if !(getline(n) =~ mdrx)
                            let uncomment = 0
                            " TLogVAR 2, uncomment
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
                " TLogVAR @t, mdrx
                let uncomment = (@t =~ mdrx)
                " TLogVAR 3, uncomment
                if !uncomment && a:comment_mode =~? 'o'
                    let mdrx1 = substitute(mdrx, '\\$$', '\\n\\$', '')
                    " TLogVAR mdrx1
                    if @t =~ mdrx1
                        let uncomment = 1
                        " TLogVAR 4, uncomment
                    endif
                endif
            finally
                let @t = t
            endtry
        endif
    endif
    " TLogVAR 5, beg, end, uncomment
    return [beg, end, uncomment]
endf


function! s:ProcessLine(comment_do, match, checkRx, replace) abort
    " TLogVAR a:comment_do, a:match, a:checkRx, a:replace
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
                " TLogVAR irx
            else
                let irx = 2
            endif
            let rv = substitute(a:match, a:checkRx, '\1\'. irx, '')
            let rv = s:UnreplaceInLine(rv)
        else
            let ml = len(a:match)
            let rv = s:ReplaceInLine(a:match)
            let rv = tcomment#regex#Printf1(a:replace, rv)
            let strip_whitespace = get(s:cdef, 'strip_whitespace', 1)
            if strip_whitespace == 2 || (strip_whitespace == 1 && ml == 0)
                let rv = substitute(rv, '\s\+$', '', '')
            endif
        endif
        " TLogVAR rv
        " echom "DBG s:cdef.mode=" string(s:cdef.mode) "s:cursor_pos=" string(s:cursor_pos)
        if s:cdef.mode =~# '>'
            let s:cursor_pos = getpos('.')
            let s:cursor_pos[2] += len(rv)
        elseif s:cdef.mode =~# '#'
            if empty(s:cursor_pos) || s:current_pos[1] == s:processline_lnum
                let prefix = matchstr(a:replace, '^.*%\@<!\ze%s')
                let prefix = substitute(prefix, '%\(.\)', '\1', 'g')
                let prefix_len = s:Strdisplaywidth(prefix)
                " TLogVAR a:replace, prefix_len
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
                    " echom "DBG s:current_pos=" string(s:current_pos) "s:cursor_pos=" string(s:cursor_pos)
                endif
            endif
        endif
        " TLogVAR rv
        if g:tcomment#must_escape_expression_backslash
            let rv = escape(rv, "\\r")
        else
            let rv = escape(rv, "\r")
        endif
        " TLogVAR rv
        " let rv = substitute(rv, '\n', '\\\n', 'g')
        " TLogVAR rv
        return [rv, 1]
    finally
        let s:processline_lnum += 1
    endtry
endf


function! s:ReplaceInLine(text) abort "{{{3
    if has_key(s:cdef, 'replacements')
        let replacements = s:cdef.replacements
        return tcomment#replace#DoReplacements(a:text, keys(replacements), values(replacements))
    else
        return a:text
    endif
endf


function! s:UnreplaceInLine(text) abort "{{{3
    if has_key(s:cdef, 'replacements')
        let replacements = s:cdef.replacements
        return tcomment#replace#DoReplacements(a:text, values(replacements), keys(replacements))
    else
        return a:text
    endif
endf


function! s:CommentBlock(beg, end, cbeg, cend, comment_mode, comment_do, checkRx, cdef) abort
    " TLogVAR a:beg, a:end, a:cbeg, a:cend, a:comment_do, a:checkRx, a:cdef
    let indentStr = repeat(' ', a:cbeg)
    let t = @t
    let sel_save = &selection
    set selection=exclusive
    try
        silent exec 'norm! '. a:beg.'G1|v'.a:end.'G$"td'
        " TLogVAR @t
        let ms = tcomment#commentstring#BlockGetMiddleString(a:cdef)
        let mx = escape(ms, '\')
        let cs = tcomment#commentstring#BlockGetCommentString(a:cdef)
        let prefix = substitute(matchstr(cs, '^.*%\@<!\ze%s'), '%\(.\)', '\1', 'g')
        let postfix = substitute(matchstr(cs, '%\@<!%s\zs.*$'), '%\(.\)', '\1', 'g')
        " TLogVAR ms, mx, cs, prefix, postfix
        if a:comment_do ==? 'u'
            let @t = substitute(@t, '\V\^\s\*'. a:checkRx .'\$', '\1', '')
            let tt = []
            " TODO: Correctly handle foreign comments with inconsistent 
            " whitespace around mx markers
            let rx = '\V'. s:StartColRx(a:comment_mode, a:cbeg) . '\zs'. mx
            " TLogVAR mx1, rx
            for line in split(@t, '\n')
                let line1 = substitute(line, rx, '', '')
                call add(tt, line1)
            endfor
            let @t = join(tt, "\n")
            " TLogVAR @t
            let @t = substitute(@t, '^\n', '', '')
            let @t = substitute(@t, '\n\s*$', '', '')
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
                let prefix_len = s:Strdisplaywidth(mx)
                let s:cursor_pos[2] -= prefix_len
                if s:cursor_pos[2] < 1
                    let s:cursor_pos[2] = 1
                endif
            endif
        else
            let cs = indentStr . substitute(cs, '%\@<!%s', '%s'. indentStr, '')
            " TLogVAR cs, ms
            if !empty(ms)
                let lines = []
                let lnum = 0
                let indentlen = a:cbeg
                let rx = '^.\{-}\%>'. indentlen .'v\zs'
                " TLogVAR indentStr, indentlen, rx, @t, empty(@t)
                if @t =~# '^\n\?$'
                    let lines = [indentStr . ms]
                    let cs .= "\n"
                    " TLogVAR 1, lines
                else
                    for line in split(@t, '\n')
                        " TLogVAR 1, line
                        if lnum == 0
                            let line = substitute(line, rx, ms, '')
                        else
                            let line = substitute(line, rx, mx, '')
                        endif
                        " TLogVAR 2, line
                        call add(lines, line)
                        let lnum += 1
                    endfor
                    " TLogVAR 2, lines
                endif
                let @t = join(lines, "\n")
                " TLogVAR 3, @t
            endif
            let @t = tcomment#regex#Printf1(cs, "\n". @t ."\n")
            " TLogVAR 4, cs, @t, a:comment_mode
            if a:comment_mode =~# '#'
                let s:cursor_pos = copy(s:current_pos)
                let s:cursor_pos[1] += len(substitute(prefix, "[^\n]", '', 'g')) + 1
                let prefix_len = s:Strdisplaywidth(mx)
                let s:cursor_pos[2] += prefix_len
                " echom "DBG s:current_pos=" string(s:current_pos) "s:cursor_pos=" string(s:cursor_pos)
            endif
        endif
        silent norm! "tP
    finally
        let &selection = sel_save
        let @t = t
    endtry
endf


if exists('*strdisplaywidth')
    function! s:Strwidth(text) abort "{{{3
        return strdisplaywidth(a:text)
    endf
else
    function! s:Strwidth(text) abort "{{{3
        return len(a:text)
    endf
endif


" inspired by Meikel Brandmeyer's EnhancedCommentify.vim
" this requires that a syntax names are prefixed by the filetype name 
" s:GuessFileType(beg, end, comment_mode, filetype, ?fallbackFiletype)
function! s:GuessFileType(beg, end, comment_mode, filetype, ...) abort
    " TLogVAR a:beg, a:end, a:comment_mode, a:filetype, a:000
    let cdef0 = tcomment#commentstring#GetCustom(a:filetype, a:comment_mode)
    if a:0 >= 1 && !empty(a:1)
        let cdef = tcomment#commentstring#GetCustom(a:1, a:comment_mode)
        " TLogVAR 0, cdef
        let cdef = extend(cdef, cdef0, 'keep')
        " TLogVAR 1, cdef
        if empty(get(cdef, 'commentstring', ''))
            let guess_cdef = tcomment#commentstring#GuessVimOptions(a:comment_mode)
            call extend(cdef, guess_cdef)
        endif
        " TLogVAR 2, cdef
    else
        let cdef = cdef0
        " TLogVAR 3, cdef
        if !has_key(cdef, 'commentstring')
            let cdef = tcomment#commentstring#GuessVimOptions(a:comment_mode)
        endif
        " TLogVAR 4, cdef
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
    " TLogVAR n, beg, end
    while n <= end
        let text = getline(n)
        let indentstring = matchstr(text, '^\s*')
        let m = s:Strwidth(indentstring)
        " let m  = indent(n) + 1
        let le = s:Strwidth(text)
        " TLogVAR n, m, le
        while m <= le
            let syntax_name = tcomment#syntax#GetSyntaxName(n, m)
            " TLogVAR syntax_name, n, m
            unlet! ftype_map
            let ftype_map = get(g:tcommentSyntaxMap, syntax_name, '')
            " TLogVAR ftype_map
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
                    " TLogVAR ftype_map, ftypeftype
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
                " TLogVAR ftype_map
                return tcomment#commentstring#GetCustom(ftype_map, a:comment_mode, cdef.commentstring)
            elseif syntax_name =~ s:types_rx
                let ft = substitute(syntax_name, s:types_rx, '\1', '')
                " TLogVAR ft
                if exists('g:tcommentIgnoreTypes_'. a:filetype) && g:tcommentIgnoreTypes_{a:filetype} =~ '\<'.ft.'\>'
                    let m += 1
                else
                    return tcomment#commentstring#GetCustom(ft, a:comment_mode, cdef.commentstring)
                endif
            elseif empty(syntax_name) || syntax_name ==? 'None' || syntax_name =~# '^\u\+$' || syntax_name =~# '^\u\U*$'
                let m += 1
            else
                break
            endif
        endwh
        let n += 1
    endwh
    " TLogVAR cdef
    return cdef
endf

" A function that makes the s:GuessFileType() function usable for other 
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
    return s:GuessFileType(beg, end,
          \ comment_mode, filetype, fallbackFiletype)
endf


function! tcomment#TextObjectInlineComment() abort "{{{3
    let cdef = tcomment#GuessCommentType({'comment_mode': 'I'})
    let cms  = escape(cdef.commentstring, '\')
    let pos  = getpos('.')
    let lnum = pos[1]
    let col  = pos[2]
    let cmtf = '\V'. printf(cms, '\.\{-}\%'. lnum .'l\%'. col .'c\.\{-}')
    " TLogVAR cmtf, search(cmtf,'cwn')
    if search(cmtf, 'cw') > 0
        let pos0 = getpos('.')
        if search(cmtf, 'cwe') > 0
            let pos1 = getpos('.')
            exec 'norm!'
                        \ pos0[1].'gg'.pos0[2].'|v'.
                        \ pos1[1].'gg'.pos1[2].'|'.
                        \ (&selection ==# 'exclusive' ? 'l' : '')
        endif
    endif
endf


" vi: ft=vim:tw=72:ts=4:fo=w2croql
