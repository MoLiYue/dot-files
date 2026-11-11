set nocompatible
filetype on

" 新建文件头部信息使用的作者信息
let s:author = 'MoLiYue'
let s:mail = 'moliyue018@gmail.com'

" 插件管理（Vundle）
" Vundle 未安装时自动 clone；clone 失败则跳过插件配置，避免每次启动报 E117。
let s:vundle_dir = expand('~/.vim/bundle/Vundle.vim')
if !isdirectory(s:vundle_dir) && executable('git')
    execute 'silent! !git clone --depth 1 https://github.com/VundleVim/Vundle.vim.git ' . shellescape(s:vundle_dir)
endif

if isdirectory(s:vundle_dir)
    set rtp+=~/.vim/bundle/Vundle.vim
    call vundle#begin()

    " 这里根据自己需要的插件来设置，以下是我的配置
    " YouCompleteMe: 语句补全插件（需手动安装到 ~/.vim/bundle/YouCompleteMe）
    set runtimepath+=~/.vim/bundle/YouCompleteMe
    augroup vimrc_ycm
        autocmd!
        autocmd InsertLeave * if pumvisible() == 0 | pclose | endif " 离开插入模式后自动关闭预览窗口
    augroup END
    let g:ycm_collect_identifiers_from_tags_files = 1           " 开启 YCM 基于标签引擎
    let g:ycm_seed_identifiers_with_syntax = 1                  " 语法关键字补全
    let g:ycm_complete_in_comments = 1                          " 在注释输入中也能补全
    let g:ycm_complete_in_strings = 1                           " 在字符串输入中也能补全
    let g:ycm_collect_identifiers_from_comments_and_strings = 1 " 注释和字符串中的文字也会被收入补全
    let g:ycm_confirm_extra_conf = 0                            " 关闭加载 .ycm_extra_conf.py 提示
    let g:ycm_key_list_select_completion = ['<c-n>', '<Down>']  " 映射按键，没有这个会拦截掉 tab，导致其他插件的 tab 不能用.
    let g:ycm_key_list_previous_completion = ['<c-p>', '<Up>']
    let g:ycm_global_ycm_extra_conf = '~/.vim/bundle/YouCompleteMe/third_party/ycmd/.ycm_extra_conf.py'
    let g:ycm_show_diagnostics_ui = 0                           " 禁用语法检查
    inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<CR>"             " 回车即选中当前项
    nnoremap <c-j> :YcmCompleter GoToDefinitionElseDeclaration<CR>     " 跳转到定义处
    let g:ycm_min_num_of_chars_for_completion = 2               " 从第 2 个键入字符就开始罗列匹配项

    " github 仓库中的插件
    Plugin 'VundleVim/Vundle.vim'

    Plugin 'vim-airline/vim-airline'
    " vim-airline 配置: 优化 vim 界面
    " 显示颜色
    set t_Co=256
    " 使用 powerline 打过补丁的字体
    let g:airline_powerline_fonts = 1
    " 开启 tabline
    let g:airline#extensions#tabline#enabled = 1
    " tabline 中当前 buffer 两端的分隔字符
    let g:airline#extensions#tabline#left_sep = ' '
    " tabline 中未激活 buffer 两端的分隔字符
    let g:airline#extensions#tabline#left_alt_sep = ' '
    " tabline 中 buffer 显示编号
    let g:airline#extensions#tabline#buffer_nr_show = 1
    " 映射切换 buffer 的键位
    nnoremap [b :bp<CR>
    nnoremap ]b :bn<CR>
    " 映射 <leader>num 到 num buffer
    map <leader>1 :b 1<CR>
    map <leader>2 :b 2<CR>
    map <leader>3 :b 3<CR>
    map <leader>4 :b 4<CR>
    map <leader>5 :b 5<CR>
    map <leader>6 :b 6<CR>
    map <leader>7 :b 7<CR>
    map <leader>8 :b 8<CR>
    map <leader>9 :b 9<CR>

    " vim-scripts 中的插件
    Plugin 'taglist.vim'
    " ctags 配置: F3 快捷键显示程序中的各种 tags，包括变量和函数等。
    map <F3> :TlistToggle<CR>
    let Tlist_Use_Right_Window = 1
    let Tlist_Show_One_File = 1
    let Tlist_Exit_OnlyWindow = 1
    let Tlist_WinWidth = 25

    Plugin 'The-NERD-tree'
    " NERDTree 配置: F2 快捷键显示当前目录树
    map <F2> :NERDTreeToggle<CR>
    let NERDTreeWinSize = 25

    Plugin 'indentLine.vim'
    Plugin 'delimitMate.vim'

    call vundle#end()
else
    echohl WarningMsg
    echomsg '未找到 Vundle，已跳过插件配置（安装后运行 :PluginInstall）'
    echohl None
endif

" 新文件标题
" 新建 .c,.h,.sh,.java 文件，自动插入文件头
function! SetTitle()
    " 如果文件类型为 .sh 文件
    if &filetype == 'sh'
        call setline(1, "#!/bin/zsh")
        call append(line("$"), "")
        call append(line("$"), "##########################################################################")
        call append(line("$"), "# File Name: ".expand("%"))
        call append(line("$"), "# Author: ".s:author)
        call append(line("$"), "# Mail: ".s:mail)
        call append(line("$"), "# Created Time: ".strftime("%c"))
        call append(line("$"), "##########################################################################")
        call append(line("$"), "")
    else
        call setline(1, "/*************************************************************************")
        call append(line("$"), "	> File Name: ".expand("%"))
        call append(line("$"), "	> Author: ".s:author)
        call append(line("$"), "	> Mail: ".s:mail)
        call append(line("$"), "	> Created Time: ".strftime("%c"))
        call append(line("$"), " ************************************************************************/")
        call append(line("$"), "")
    endif
    if &filetype == 'cpp'
        call append(line("$"), "#include<iostream>")
        call append(line("$"), "using namespace std;")
        call append(line("$"), "")
    endif
    if &filetype == 'c'
        call append(line("$"), "#include<stdio.h>")
        call append(line("$"), "")
    endif
    " 新建文件后，自动定位到文件末尾
    normal! G
endfunction

augroup vimrc_newfile
    autocmd!
    autocmd BufNewFile *.cpp,*.[ch],*.sh,*.java call SetTitle()
augroup END

" 键盘命令
nmap <leader>w :w!<cr>
nmap <leader>f :find<cr>

" 映射全选+复制 ctrl+a
map <C-A> ggVGY
map! <C-A> <Esc>ggVGY
map <F12> gg=G
" 选中状态下 Ctrl+c 复制
vmap <C-c> "+y

" 实用设置
" 设置当文件被改动时自动载入
set autoread
" quickfix 模式
augroup vimrc_quickfix
    autocmd!
    autocmd FileType c,cpp nnoremap <buffer> <leader><space> :w<cr>:make<cr>
augroup END
" 共享剪贴板（+ 为系统剪贴板，* 为主选区）
set clipboard=unnamed,unnamedplus
" 从不备份
set nobackup
" make 运行
set makeprg=g++\ -Wall\ \ %
" 自动保存
set autowrite
set ruler                   " 打开状态栏标尺
set cursorline              " 突出显示当前行
set magic                   " 设置魔术
set guioptions-=T           " 隐藏工具栏
set guioptions-=m           " 隐藏菜单栏
" 设置在状态行显示的信息
set foldcolumn=0
set foldmethod=indent
set foldlevel=3
set foldenable              " 开始折叠
" 不要使用 vi 的键盘模式，而是 vim 自己的
set nocompatible
" 去掉输入错误的提示声音
set noeb
" 在处理未保存或只读文件的时候，弹出确认
set confirm
" 自动缩进
set autoindent
set cindent
" Tab 键的宽度
set tabstop=4
" 统一缩进为 4
set softtabstop=4
set shiftwidth=4
" 不要用空格代替制表符
set noexpandtab
" 在行和段开始处使用制表符
set smarttab
" 显示行号
set number
" 历史记录数
set history=1000
" 禁止生成临时文件
set noswapfile
" 搜索忽略大小写
set ignorecase
" 搜索逐字符高亮
set hlsearch
set incsearch
" 行内替换
set gdefault
" 编码设置
set enc=utf-8
set fencs=utf-8,ucs-bom,shift-jis,gb18030,gbk,gb2312,cp936
" 语言设置
set langmenu=zh_CN.UTF-8
set helplang=cn
" 我的状态行显示的内容（包括文件类型和解码）
set statusline=[%F]%y%r%m%*%=[Line:%l/%L,Column:%c][%p%%]
" 总是显示状态行
set laststatus=2
" 命令行（在状态行下）的高度，默认为 1，这里是 2
set cmdheight=2
" 保存全局变量
set viminfo+=!
" 带有如下符号的单词不要被换行分割
set iskeyword+=_,$,@,%,#,-
" 字符间插入的像素行数目
set linespace=0
" 增强模式中的命令行自动完成操作
set wildmenu
" 使回格键（backspace）正常处理 indent, eol, start 等
set backspace=2
" 允许 backspace 和光标键跨越行边界
set whichwrap+=<,>,h,l
" 可以在 buffer 的任何地方使用鼠标
set mouse=a
set selection=exclusive
set selectmode=mouse,key
" 通过使用 :commands 命令，告诉我们文件的哪一行被改变过
set report=0
" 在被分割的窗口间显示空白，便于阅读
let &fillchars = 'vert: ,stl: ,stlnc: '
" 高亮显示匹配的括号
set showmatch
" 匹配括号高亮的时间（单位是十分之一秒）
set matchtime=1
" 光标移动到 buffer 的顶部和底部时保持 3 行距离
set scrolloff=3
" 为 C 程序提供自动缩进
set smartindent
" 自动补全括号由 delimitMate 插件负责，这里不再重复映射
filetype plugin indent on
" 打开文件类型检测，加了这句才可以用智能补全
set completeopt=longest,menu
" 语法高亮
syntax on
