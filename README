tcomment provides easy to use, file-type sensible comments for Vim. It 
can handle embedded syntax.

TComment works like a toggle, i.e., it will comment out text that 
contains uncommented lines, and it will remove comment markup for 
already commented text (i.e. text that contains no uncommented lines).

If the file-type is properly defined, TComment will figure out which 
comment string to use. Otherwise you use |tcomment#DefineType()| to 
override the default choice.

TComment can properly handle an embedded syntax, e.g., ruby/python/perl 
regions in vim scripts, HTML or JavaScript in php code etc.

Demo:
http://vimsomnia.blogspot.com/2010/11/tcomment-vim-plugin.html


                                                    *tcomment-maps*
Key bindings~

Most of the time the default toggle keys will do what you want (or to be 
more precise: what I think you want it to do ;-).

                                                    *g:tcommentMapLeaderOp1*
                                                    *g:tcommentMapLeaderOp2*
As operator (the prefix can be customized via g:tcommentMapLeaderOp1 
and g:tcommentMapLeaderOp2):

    gc{motion}   :: Toggle comments (for small comments within one line 
                    the &filetype_inline style will be used, if 
                    defined)
    gcc          :: Toggle comment for the current line
    gC{motion}   :: Comment region
    gCc          :: Comment the current line

By default the cursor stays put. If you want the cursor to the end of 
the commented text, set |g:tcommentOpModeExtra| to '>' (but this may not 
work properly with exclusive motions).

Primary key maps:

    <c-_><c-_>   :: :TComment
    <c-_><space> :: :TComment <QUERY COMMENT-BEGIN ?COMMENT-END>
    <c-_>b       :: :TCommentBlock
    <c-_>a       :: :TCommentAs <QUERY COMMENT TYPE>
    <c-_>n       :: :TCommentAs &filetype <QUERY COUNT>
    <c-_>s       :: :TCommentAs &filetype_<QUERY COMMENT SUBTYPE>
    <c-_>i       :: :TCommentInline
    <c-_>r       :: :TCommentRight
    <c-_>p       :: Comment the current inner paragraph

A secondary set of key maps is defined for normal mode.

    <Leader>__       :: :TComment
    <Leader>_p       :: Comment the current inner paragraph
    <Leader>_<space> :: :TComment <QUERY COMMENT-BEGIN ?COMMENT-END>
    <Leader>_i       :: :TCommentInline
    <Leader>_r       :: :TCommentRight
    <Leader>_b       :: :TCommentBlock
    <Leader>_a       :: :TCommentAs <QUERY COMMENT TYPE>
    <Leader>_n       :: :TCommentAs &filetype <QUERY COUNT>
    <Leader>_s       :: :TCommentAs &filetype_<QUERY COMMENT SUBTYPE>


-----------------------------------------------------------------------

Status:  Works for me (there may be some minor quirks)
Install: See http://github.com/tomtom/vimtlib/blob/master/INSTALL.TXT
See http://github.com/tomtom for related plugins.

