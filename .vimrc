if version < 700
    echo "~/.vimrc: Vim 7.0+ is required!, you should upgrade your vim to latest version."
endif

set nocompatible
" �ر� vi ����ģʽ

set fileencodings=utf8,utf-8,gbk,gb2312,gb18030,cp936,ucs-bom,default,latin1
set fileformats=unix,dos,mac
set encoding=utf-8
set fileencoding=utf-8

" ����ƥ������
"" no loop
:inoremap ( ()<ESC>i
:inoremap ) <c-r>=ClosePair(')')<CR>
:inoremap { {}<ESC>i
:inoremap } <c-r>=ClosePair('}')<CR>
:inoremap [ []<ESC>i
:inoremap ] <c-r>=ClosePair(']')<CR>
:inoremap " ""<ESC>i
:inoremap ' ''<ESC>i
function! ClosePair(char)
    if getline('.')[col('.') - 1] == a:char
        return "\<Right>"
    else
        return a:char
    endif
endfunction

" ���˸��ʱ�жϵ�ǰ���ǰһ���ַ���
" ����������ţ���ɾ����Ӧ���������Լ������м������
function! RemovePairs()
    let l:line = getline(".")
    let l:previous_char = l:line[col(".")-1] " ȡ�õ�ǰ���ǰһ���ַ�

    if index(["(", "[", "{"], l:previous_char) != -1
        let l:original_pos = getpos(".")
        execute "normal %"
        let l:new_pos = getpos(".")

        " ���û��ƥ���������
        if l:original_pos == l:new_pos
            execute "normal! a\<BS>"
            return
        end

        let l:line2 = getline(".")
        if len(l:line2) == col(".")
            " ����������ǵ�ǰ�����һ���ַ�
            execute "normal! v%xa"
        else
            " ��������Ų��ǵ�ǰ�����һ���ַ�
            execute "normal! v%xi"
        end

    else
        execute "normal! a\<BS>"
    end
endfunction
" ���˸��ɾ��һ��������ʱͬʱɾ����Ӧ��������
inoremap <BS> <ESC>:call RemovePairs()<CR>a

fun! StripTrailingWhitespace()
    " Don't strip on these filetypes
    if &ft =~ 'markdown'
        return
    endif
    %s/\s\+$//e
endfun

autocmd BufWritePre * call StripTrailingWhitespace()

" locate project dir by BLADE_ROOT file
function! FindProjectRootDir()
    let rootfile = findfile("BLADE_ROOT", ".;")
    " in project root dir
    if rootfile == "BLADE_ROOT"
        return ""
    endif
    return substitute(rootfile, "/BLADE_ROOT$", "", "")
endfunction


" auto insert gtest header inclusion for test source file
function! s:InsertHeaderGuard()
    let fullname = expand("%:p")
    let rootdir = FindProjectRootDir()
    if rootdir != ""
        let path = substitute(fullname, "^" . rootdir . "/", "", "")
    else
        let path = expand("%")
    endif
    let varname = "_" . toupper(substitute(path, "[^a-zA-Z0-9]", "_", "g"))
    exec 'norm O#ifndef ' . varname
    exec 'norm o#define ' . varname
    exec '$norm o#endif // ' . varname
endfunction

function! InsertHeaderInfo()
    call append(0, "// Copyright (C) ".strftime("%Y")."  .")
    call append(1, "// Author: davidluan")
    call append(2, "// CreateTime: ".strftime("%Y-%m-%d"))
    call append(3, "")
endfunction

autocmd BufNewFile *.{h,hh,hxx,hpp,cpp,cc,c} nested call InsertHeaderInfo()
autocmd BufNewFile *.{h,hh,hxx,hpp} nested call <SID>InsertHeaderGuard()

augroup filetype
   au! BufRead,BufNewFile *.proto setfiletype proto
augroup end

""""""""""python""""""""""""""
""""""""""""""""""""""""""""""
" set filetype=python
autocmd BufNewFile,BufRead *.py,*.pyw setf python
autocmd BufRead,BufNewFile *.cmake,CMakeLists.txt,*.cmake.in runtime! indent/cmake.vim
autocmd BufRead,BufNewFile *.cmake,CMakeLists.txt,*.cmake.in setf cmake
autocmd BufRead,BufNewFile *.ctest,*.ctest.in setf cmake


" Tab related
set ts=4
set sw=4
set smarttab
set et
set ambiwidth=double

" Format related
""set tw=78
set lbr
set fo+=mB

" Indent related
set cin
set ai
" �����Զ�����
" set smartindent
set cino=:0g0t0(susj1

set showtabline=2

imap jj <ESC>
imap ww <c-o>w
imap bb <c-o>b

" Editing related
set backspace=indent,eol,start 	"����ɾ�����з���
set whichwrap=b,s,<,>,[,]
"set mouse=a						" ȷ��������ģʽ��ʶ�����
"set selectmode=
set mousemodel=popup
set keymodel=
set selection=inclusive
set ignorecase
set smartcase
"set cursorline              " ���ù��ʮ�����꣬������ǰ��
"set nocursorline           " ��ͻ����ʾ��ǰ��
"hi cursorline guibg=#333333   	" ������ǰ�еı�����ɫ
"set cursorcolumn           " ���ù��ʮ�����꣬������ǰ��
"hi CursorColumn guibg=#333333      " ������ǰ�еı�����ɫ
" ��������ʱ�����ݵ���ת��ƥ��Ķ�Ӧ���ţ���ʾƥ���ʱ����matchtime����
set showmatch
set matchtime=3             " ��λ��ʮ��֮һ��
set matchpairs=(:),{:},[:],<:>        " ƥ�����ŵĹ����������html

" Misc
set wildmenu
" set spell

" Encoding related
set langmenu=zh_CN.UTF-8

"language message zh_CN.UTF-8
set fileencodings=utf-8,ucs-bom,gb18030,cp936,big5,euc-jp,euc-kr,latin1
""set termencoding=utf-8

" ��������δ������޸�ʱ�л�����������ʱ���޸��� coder ���𱣴�
set hidden

" ����������༭���ļ����л���
" CTRL-6 �� CTRL-^ �� :e #��

" ����ģʽ�����������ƶ����
" this will make backspace no use"imap <c-h> <left>
imap <c-l> <right>
imap <c-j> <c-o>gj
imap <c-k> <c-o>gk
imap <c-u> <c-o><c-u>
imap <c-d> <c-o><c-d>

" paste toogle"
""nmap <c-i> :set pastetoggle<CR>i
""imap <c-i> <c-o>:set pastetoggle<CR>

""""""""""begin""""""" windows likely, some from msvin.vim"""""""""""""""""""""
" backspace in Visual mode deletes selection
vnoremap <BS> d


" ctrl +s save all tabs
nmap <silent> <C-S> :wall<CR>
vmap <silent> <C-S> <ESC>:wall<CR>
imap <silent> <C-S> <ESC>:wall<CR>

nmap <c-Q> :q<CR>

" CTRL-A is Select all
nmap <C-A> ggvG
imap <C-A> <c-o>gg <c-o>vG
""noremap <C-A> gggH<C-O>G
""inoremap <C-A> <C-O>gg<C-O>gH<C-O>G
""cnoremap <C-A> <C-C>gggH<C-O>G

" CTRL-Tab is Next window
noremap <C-Tab> <C-W>w
inoremap <C-Tab> <C-O><C-W>w
cnoremap <C-Tab> <C-C><C-W>w
onoremap <C-Tab> <C-C><C-W>w

""""""""end""""""""" windows likely, some from msvin.vim"""""""""""""""""""""


" del balck lines" ɾ���հ���
nmap <c-#> :g/^\s*$/d <cr>


" buffers :bufdo :bnext :buffer
" ����Ǹ�buffer�Ѿ������Ǹ����ڼ��������˵�´���
set switchbuf=useopen
nmap <C-n> :bprevious<CR>
nmap <C-m> :bnext<CR>


" File type related
filetype plugin indent on

" python �﷨����
let g:python_highlight_all = 1
let python_highlight_all =1

" python pydiction
let g:pydiction_location = '~/.vim/pydiction/complete-dict'

"     zo: �򿪹��λ�õ��۵����룻
"     zc: �۵����λ�õĴ��룻
"     zr: ���ļ��������۵��Ĵ���򿪣�
"     zm: ���ļ������д򿪵Ĵ����۵���
"     zR: ���ú� zr ���ƣ���������۵����۵��е��۵�����
"     zM: ���ú� zm ���ƣ�����ر����۵���
"     zi: �۵���򿪲���֮����л����

" Python ����������Զ���ȫ
autocmd FileType python set omnifunc=pythoncomplete#Complete

" Python �����Զ��۵�
autocmd FileType python setlocal foldmethod=indent
"Ĭ��չ�����д���
set foldlevel=99

""""""""""""""""""""""""""""""
""""""""""python""""""""""""""


" Display related
set ru
set nu
set sm
set hls

if (has("gui_running"))
    set guioptions+=b
    colo torte
    set nowrap
else
    colo ron
    set wrap
endif

syntax enable
syntax on
colorscheme elflord
" colorscheme desert

"=============================================================================
" Platform dependent settings
"=============================================================================
if (has("win32"))
    "-------------------------------------------------------------------------
    " Win32
    "-------------------------------------------------------------------------
    if (has("gui_running"))
        set guifont=Bitstream_Vera_Sans_Mono:h9:cANSI
        set guifontwide=NSimSun:h9:cGB2312
    endif
else
    if (has("gui_running"))
        set guifont=Bitstream\ Vera\ Sans\ Mono\ 9
    endif

endif

" plugins settings

" UltiSnips  =====>  TextMates "


"bufexplorer���������л����
"version 7.2.8
"'\be'  --������
"'\bs'  --ˮƽ�ָ��
"'\bv' 10--��ֱ�ָ��

" buf file list
nmap  <C-B> :BufExplorerVerticalSplit<CR>
imap  <C-B> <c-o>:BufExplorerVerticalSplit<CR>

map <leader><leader> <leader>be       "��ݼ���


"ctags.vim���ڱ����״̬����ʾ������Ϣ
"����Ŀ����Ŀ¼ִ��ctags -R����tagsĿ¼
"��Դset tags=../../tags������Ӧ��tags����
"�ں������ϰ� <C-]> ����ת���������壬�� <C-T> ���Է��ص��õ�ַ
set tags+=./tags,tags;
""set autochdir

"NERD_commenter��ע�ʹ���
"����Ϊ���Ĭ�Ͽ�ݼ�
"{{
"<leader>ca   ->�ڿ�ѡ��ע�ͷ�ʽ֮���л�������C/C++ �Ŀ�ע��/* */����ע��//
"<leader>cc   ->ע�͵�ǰ��
"<leader>cs   ->�ԡ��ԸС��ķ�ʽע��
"<leader>cA   ->�ڵ�ǰ��β���ע�ͷ���������Insertģʽ
"<leader>cu   ->ȡ��ע��
"<leader>cm   ->��ӿ�ע��
let NERDShutUp=1
"}}

nmap <F3> :cs find d <C-R>=expand("<cword>")<CR><CR>
nmap <F4> :cs find t <C-R>=expand("<cword>")<CR><CR>
nmap <F5> :cs find f <C-R>=expand("<cfile>")<CR><CR>


nmap <F8> :TagbarToggle<CR>
"NERDTree�������ļ�����
" nmap <F5> :NERDTree  <CR>
" autocmd VimEnter * NERDTree
let NERDTreeIgnore=['\.swp$']
let NERDTreeQuitOnOpen = 1  " ��ͨ��NERD Tree���ļ��Զ��˳�NERDTree����


"authorinfo.vim���Զ����������Ϣ����Ҫ��NERD_commenter����)ʹ��,:AuthorInfoDetect����
"let g:vimrc_author='davidluan'
"let g:vimrc_email='yjluan@gmail.com'
"let g:vimrc_homepage='http://www.xx.com'



"fencview.vim���Զ�����ʶ��,��:FencView�鿴�ļ�����͸����ļ�����
" let g:fencview_autodetect = 1
" let g:fencview_checklines = 10




" DoxygenToolkit
let g:DoxygenToolkit_authorName="davidluan"
let g:DoxygenToolkit_licenseTag="My own license\<enter>"
let g:DoxygenToolkit_undocTag="DOXIGEN_SKIP_BLOCK"
""let g:DoxygenToolkit_briefTag_pre = "@brief\t"
let g:DoxygenToolkit_paramTag_pre = "@param\t"
let g:DoxygenToolkit_returnTag = "@return\t"
let g:DoxygenToolkit_briefTag_funcName = "no"
let g:DoxygenToolkit_maxFunctionProtoLines = 30
map fg : Dox<cr>
map fh : DoxAuthor<cr>
" map <F10> : DoxAuthor<cr>
map <F10> : call InsertHeaderInfo()<cr>


" ifndef define
function InsertHeadDef(firstLine, lastLine)
    if a:firstLine <1 || a:lastLine> line('$')
        echoerr 'InsertHeadDef : Range overflow !(FirstLine:'.a:firstLine.';LastLine:'.a:lastLine.';ValidRange:1~'.line('$').')'
        return ''
    endif
    let sourcefilename=expand("%:t")
    let definename=substitute(sourcefilename,' ','','g')
    let definename=substitute(definename,'\.','_','g')
    let definename = toupper(definename)
    exe 'normal '.a:firstLine.'GO'
    call setline('.', '#ifndef _'.definename."_")
    normal ==o
    call setline('.', '#define _'.definename."_")
    exe 'normal =='.(a:lastLine-a:firstLine+1).'jo'
    call setline('.', '#endif // _'.definename.'_')
    let goLn = a:firstLine+2
    exe 'normal =='.goLn.'G'
endfunction

function InsertHeadDefN()
    let firstLine = 1
    let lastLine = line('$')
    let n=1
    while n < 20
        let line = getline(n)
        if n==1
            if line =~ '^\/\*.*$'
                let n = n + 1
                continue
            else
                break
            endif
        endif
        if line =~ '^.*\*\/$'
            let firstLine = n+1
            break
        endif
        let n = n + 1
    endwhile
    call InsertHeadDef(firstLine, lastLine)
endfunction

map fd : call InsertHeadDefN()<cr>
map <F11> : call InsertHeadDefN()<cr>


" a.vim h cpp�ļ��л�
map av : AV<cr>
nmap <F2> : AV<cr>

"MiniBufExplorer������ļ��л� ��ʹ�����˫����Ӧ�ļ��������л�

"  clang complete

"  omnicppcomplete

" SuperTab

" cscope
" vim ./configure --enable-cscope  vim֧��cscope

if has("cscope")
    set csto=0 "��ôcscope���ݽ��ᱻ���Ȳ��ң�Ȼ��Ż����tag�ļ�
    set cst
    set cspc=3
endif

" Tlist ���뵼��
let Tlist_Ctags_Cmd = '/usr/bin/ctags'
let Tlist_Show_One_File = 1            "��ͬʱ��ʾ����ļ���tag��ֻ��ʾ��ǰ�ļ���
let Tlist_Exit_OnlyWindow = 1          "���taglist���������һ�����ڣ����˳�vim
let Tlist_Use_Right_Window = 1         "���Ҳര������ʾtaglist����
let Tlist_Auto_Open = 0         		"�Զ���taglist����
let Tlist_Auto_Update = 1       	" �Զ��������±༭�ļ���taglist
" let Tlist_Close_On_Select =1 			" ѡ����tag���Զ��ر�taglist����

" syntastic
""let g:syntastic_check_on_open = 1
""let g:syntastic_error_symbol = 'x'
""let g:syntastic_warning_symbol = '?'
""let g:syntastic_auto_loc_list = 1
""let g:syntastic_loc_list_height = 5
""let g:syntastic_enable_highlighting = 0



" winmanager �ļ��������
let g:NERDTree_title="[NERD Tree]"
let g:winManagerWindowLayout='NERDTree'
let g:persistentBehaviour=0
"�ڽ���vimʱ�Զ���winmanager
"let g:AutoOpenWinManager = 1
function! NERDTree_Start()
    exec 'NERDTree'
endfunction
function! NERDTree_IsValid()
    return 1
endfunction
nmap wm :if IsWinManagerVisible() <BAR> WMToggle<CR> <BAR> else <BAR> WMToggle<CR>:q<CR> endif <CR><CR>
nmap <F9> :if IsWinManagerVisible() <BAR> WMToggle<CR> <BAR> else <BAR> WMToggle<CR>:q<CR> endif <CR><CR>

" CtrlP https://github.com/kien/ctrlp.vim"

noremap <C-W><C-U> :CtrlPMRU<CR>
nnoremap <C-W>u :CtrlPMRU<CR>

let g:ctrlp_custom_ignore = '\.git$\|\.hg$\|\.svn$\|.rvm$'
let g:ctrlp_working_path_mode=0
let g:ctrlp_match_window_bottom=1
let g:ctrlp_max_height=15
let g:ctrlp_match_window_reversed=0
let g:ctrlp_mruf_max=500
let g:ctrlp_follow_symlinks=1
