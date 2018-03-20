" @Author:      Tom Link (mailto:micathom AT gmail com?subject=[vim])
" @Website:     http://www.vim.org/account/profile.php?user_id=4037
" @License:     GPL (see http://www.gnu.org/licenses/gpl.txt)
" @Created:     2007-09-17.
" @Last Change: 2018-03-20.
" @Revision:    25

if exists(':Tlibtrace') != 2
    command! -nargs=+ -bang Tlibtrace :
endif


let s:definitions = {}
let g:tcomment#types#dirty = 1
let s:init = 0


" collect all known comment types
" :nodoc:
function! tcomment#type#Collect() abort
    if !s:init
        runtime! autoload/tcomment/types/*.vim
        let s:init = 1
    endif
    if g:tcomment#types#dirty
        let g:tcomment#types#names = keys(s:definitions)
        let g:tcomment#types#rx = '\V\^\('. join(g:tcomment#types#names, '\|') .'\)\(\u\.\*\)\?\$'
        let g:tcomment#types#dirty = 0
    endif
endf


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
" :display: tcomment#type#Define(name, commentdef, ?cdef={}, ?anyway=0)
function! tcomment#type#Define(name, commentdef, ...) abort
    let basename = matchstr(a:name, '^[^_]\+')
    let use = a:0 >= 2 ? a:2 : len(filter(copy(g:tcomment#ignore_comment_def), 'v:val == basename')) == 0
    Tlibtrace 'tcomment', a:name, use
    if use
        if type(a:commentdef) == 4
            let cdef = copy(a:commentdef)
        else
            let cdef = a:0 >= 1 ? a:1 : {}
            let cdef.commentstring = a:commentdef
        endif
        let s:definitions[a:name] = cdef
    endif
    let g:tcomment#types#dirty = 1
endf


" Return the comment definition for NAME.
"                                                       *b:tcomment_def_{NAME}*
" Return b:tcomment_def_{NAME} if the variable exists. Otherwise return 
" the comment definition as set with |tcomment#type#Define|.
function! tcomment#type#GetDefinition(name, ...) abort
    if exists('b:tcomment_def_'. a:name)
        return b:tcomment_def_{a:name}
    else
        return get(s:definitions, a:name, a:0 >= 1 ? a:1 : '')
    endif
endf


" :nodoc:
" Return 1 if a comment type is defined.
function! tcomment#type#Exists(name, ...) abort
    let comment_mode = a:0 >= 1 ? a:1 : ''
    let name = a:name
    if comment_mode =~? 'b'
        let name .= '_block'
    elseif comment_mode =~? 'i'
        let name .= '_inline'
    endif
    return has_key(s:definitions, name) ? name : ''
endf


" :doc:
" A dictionary of NAME => COMMENT DEFINITION (see |tcomment#type#Define()|) 
" that can be set in vimrc to override tcomment's default comment 
" styles.
" :read: let g:tcomment_types = {} "{{{2
if exists('g:tcomment_types')
    for [s:name, s:def] in items(g:tcomment_types)
        call tcomment#type#Define(s:name, s:def)
    endfor
    unlet! s:name s:def
endif

