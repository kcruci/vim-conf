if version < 700
    echo "~/.vimrc: Vim 7.0+ is required!, you should upgrade your vim to latest version."
endif

set nocompatible
" 关闭 vi 兼容模式

set fileencodings=utf8,utf-8,gbk,gb2312,gb18030,cp936,ucs-bom,default,latin1
set fileformats=unix,dos,mac
set encoding=utf-8
set fileencoding=utf-8

" 插入匹配括号
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

" 按退格键时判断当前光标前一个字符，
" 如果是左括号，则删除对应的右括号以及括号中间的内容
function! RemovePairs()
    let l:line = getline(".")
    let l:previous_char = l:line[col(".")-1] " 取得当前光标前一个字符

    if index(["(", "[", "{"], l:previous_char) != -1
        let l:original_pos = getpos(".")
        execute "normal %"
        let l:new_pos = getpos(".")

        " 如果没有匹配的右括号
        if l:original_pos == l:new_pos
            execute "normal! a\<BS>"
            return
        end

        let l:line2 = getline(".")
        if len(l:line2) == col(".")
            " 如果右括号是当前行最后一个字符
            execute "normal! v%xa"
        else
            " 如果右括号不是当前行最后一个字符
            execute "normal! v%xi"
        end

    else
        execute "normal! a\<BS>"
    end
endfunction
" 用退格键删除一个左括号时同时删除对应的右括号
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
" 智能自动缩进
" set smartindent
set cino=:0g0t0(susj1

set showtabline=2

imap jj <ESC>
imap ww <c-o>w
imap bb <c-o>b

" Editing related
set backspace=indent,eol,start 	"可以删除换行符号
set whichwrap=b,s,<,>,[,]
"set mouse=a						" 确保在所有模式下识别鼠标
"set selectmode=
set mousemodel=popup
set keymodel=
set selection=inclusive
set ignorecase
set smartcase
"set cursorline              " 设置光标十字坐标，高亮当前行
"set nocursorline           " 不突出显示当前行
"hi cursorline guibg=#333333   	" 高亮当前行的背景颜色
"set cursorcolumn           " 设置光标十字坐标，高亮当前列
"hi CursorColumn guibg=#333333      " 高亮当前列的背景颜色
" 插入括号时，短暂的跳转到匹配的对应括号，显示匹配的时间由matchtime决定
set showmatch
set matchtime=3             " 单位是十分之一秒
set matchpairs=(:),{:},[:],<:>        " 匹配括号的规则，增加针对html

" Misc
set wildmenu
" set spell

" Encoding related
set langmenu=zh_CN.UTF-8

"language message zh_CN.UTF-8
set fileencodings=utf-8,ucs-bom,gb18030,cp936,big5,euc-jp,euc-kr,latin1
""set termencoding=utf-8

" 允许在有未保存的修改时切换缓冲区，此时的修改由 coder 负责保存
set hidden

" 在两个最近编辑的文件间切换。
" CTRL-6 或 CTRL-^ 或 :e #。

" 插入模式下上下左右移动光标
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


" del balck lines" 删除空白行
nmap <c-#> :g/^\s*$/d <cr>


" buffers :bufdo :bnext :buffer
" 如果那个buffer已经在让那个窗口激活，而不是说新窗口
set switchbuf=useopen
nmap <C-n> :bprevious<CR>
nmap <C-m> :bnext<CR>


" File type related
filetype plugin indent on

" python 语法高亮
let g:python_highlight_all = 1
let python_highlight_all =1

" python pydiction
let g:pydiction_location = '~/.vim/pydiction/complete-dict'

"     zo: 打开光标位置的折叠代码；
"     zc: 折叠光标位置的代码；
"     zr: 将文件中所有折叠的代码打开；
"     zm: 将文件中所有打开的代码折叠；
"     zR: 作用和 zr 类似，但会打开子折叠（折叠中的折叠）；
"     zM: 作用和 zm 类似，但会关闭子折叠；
"     zi: 折叠与打开操作之间的切换命令；

" Python 函数、类的自动补全
autocmd FileType python set omnifunc=pythoncomplete#Complete

" Python 代码自动折叠
autocmd FileType python setlocal foldmethod=indent
"默认展开所有代码
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


"bufexplorer：缓冲区切换浏览
"version 7.2.8
"'\be'  --正常打开
"'\bs'  --水平分割打开
"'\bv' 10--垂直分割打开

" buf file list
nmap  <C-B> :BufExplorerVerticalSplit<CR>
imap  <C-B> <c-o>:BufExplorerVerticalSplit<CR>

map <leader><leader> <leader>be       "快捷键打开


"ctags.vim：在标题或状态栏显示函数信息
"在项目顶层目录执行ctags -R生成tags目录
"打开源set tags=../../tags，将相应的tags加入
"在函数名上按 <C-]> 即可转到函数定义，按 <C-T> 可以返回调用地址
set tags+=./tags,tags;
""set autochdir

"NERD_commenter：注释代码
"以下为插件默认快捷键
"{{
"<leader>ca   ->在可选的注释方式之间切换，比如C/C++ 的块注释/* */和行注释//
"<leader>cc   ->注释当前行
"<leader>cs   ->以”性感”的方式注释
"<leader>cA   ->在当前行尾添加注释符，并进入Insert模式
"<leader>cu   ->取消注释
"<leader>cm   ->添加块注释
let NERDShutUp=1
"}}

nmap <F3> :cs find d <C-R>=expand("<cword>")<CR><CR>
nmap <F4> :cs find t <C-R>=expand("<cword>")<CR><CR>
nmap <F5> :cs find f <C-R>=expand("<cfile>")<CR><CR>


nmap <F8> :TagbarToggle<CR>
"NERDTree：智能文件管理
" nmap <F5> :NERDTree  <CR>
" autocmd VimEnter * NERDTree
let NERDTreeIgnore=['\.swp$']
let NERDTreeQuitOnOpen = 1  " 当通过NERD Tree打开文件自动退出NERDTree界面


"authorinfo.vim：自动添加作者信息（需要和NERD_commenter联用)使用,:AuthorInfoDetect呼出
"let g:vimrc_author='davidluan'
"let g:vimrc_email='yjluan@gmail.com'
"let g:vimrc_homepage='http://www.xx.com'



"fencview.vim：自动编码识别,用:FencView查看文件编码和更改文件编码
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


" a.vim h cpp文件切换
map av : AV<cr>
nmap <F2> : AV<cr>

"MiniBufExplorer：多个文件切换 可使用鼠标双击相应文件名进行切换

"  clang complete

"  omnicppcomplete

" SuperTab

" cscope
" vim ./configure --enable-cscope  vim支持cscope

if has("cscope")
    set csto=0 "那么cscope数据将会被优先查找，然后才会查找tag文件
    set cst
    set cspc=3
endif

" Tlist 代码导航
let Tlist_Ctags_Cmd = '/usr/bin/ctags'
let Tlist_Show_One_File = 1            "不同时显示多个文件的tag，只显示当前文件的
let Tlist_Exit_OnlyWindow = 1          "如果taglist窗口是最后一个窗口，则退出vim
let Tlist_Use_Right_Window = 1         "在右侧窗口中显示taglist窗口
let Tlist_Auto_Open = 0         		"自动打开taglist窗口
let Tlist_Auto_Update = 1       	" 自动更新最新编辑文件的taglist
" let Tlist_Close_On_Select =1 			" 选择了tag后自动关闭taglist窗口

" syntastic
""let g:syntastic_check_on_open = 1
""let g:syntastic_error_symbol = 'x'
""let g:syntastic_warning_symbol = '?'
""let g:syntastic_auto_loc_list = 1
""let g:syntastic_loc_list_height = 5
""let g:syntastic_enable_highlighting = 0



" winmanager 文件浏览窗口
let g:NERDTree_title="[NERD Tree]"
let g:winManagerWindowLayout='NERDTree'
let g:persistentBehaviour=0
"在进入vim时自动打开winmanager
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
