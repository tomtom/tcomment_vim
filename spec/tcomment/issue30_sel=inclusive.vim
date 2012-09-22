" @Author:      Tom Link (mailto:micathom AT gmail com?subject=[vim])
" @License:     GPL (see http://www.gnu.org/licenses/gpl.txt)
" @Created:     2012-09-22.
" @Last Change: 2012-09-22.
" @Revision:    9

SpecBegin 'title': 'issue30 - bug 2 inclusive'
            \, 'options': [{'&selection': 'inclusive'}]
            \, 'scratch': 'issue30_test.c'

It should comment last character with gc.
Should yield Buffer ':norm 3gg$vgc', 'issue30_test_2.c'

