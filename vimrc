" An example for a vimrc file.
"
" Maintainer:	Bram Moolenaar <Bram@vim.org>
" Last change:	2011 Apr 15
"
" To use it, copy it to
"     for Unix and OS/2:  ~/.vimrc
"	      for Amiga:  s:.vimrc
"  for MS-DOS and Win32:  $VIM\_vimrc
"	    for OpenVMS:  sys$login:.vimrc

" When started as "evim", evim.vim will already have done these settings.
if v:progname =~? "evim"
  finish
endif

" Use Vim settings, rather than Vi settings (much better!).
" 使用Vim的设置，而不是Vi的设置。
" This must be first, because it changes other options as a side effect.
set nocompatible

" allow backspacing over everything in insert mode
" 允许退格键在插入模式下删除任何东西。
set backspace=indent,eol,start

if has("vms")     " 如果vms，编辑时不进行备份。
  set nobackup		" do not keep a backup file, use versions instead
" else
"   set backup		" keep a backup file
endif
set writebackup         " 设置写入文件后备份
set history=50		" keep 50 lines of command line history
                  " 保持50行的命令行历史记录
set ruler		" show the cursor position all the time
           	" 状态栏一直显示光标位置
set number 	" 文本右边显示行号
set ignorecase          " 搜索时忽略大小写
set incsearch		" do incremental searching
                " 增量搜索
set foldcolumn=6        " 设置折叠级数
set co=90               " 设置行宽
set linespace=6         " 设置行距
set softtabstop=2       " 用两个空格来替代一个tab
set shiftwidth=2        " 将缩进量设置为2个空格；默认8个
set spl=en spell        " 英语拼写检查

" For Win32 GUI: remove 't' flag from 'guioptions': no tearoff menu entries
" let &guioptions = substitute(&guioptions, "t", "", "g")

" Don't use Ex mode, use Q for formatting
" 不使用Ex模式，使用Q来排版
map Q gq

" 插入一行之后不要编辑，太麻烦了。
map o o
" 插入一行之后不要编辑，太麻烦了。
map O O

" <kinder:note> 下面保存会话信息。
" 本功能将被绑定到<F4>键中。
function SaS()
  execute "w" 
  let s:session_file = expand("%") . ".ses"
  execute "mksession!" s:session_file 
endfunction
nmap <F4> <ESC>:call SaS()<RETURN>        " 保存会话、文本

" <kinder:note>
" 下面是反排版。即将若干固定宽度的文本按照标点分割或合并为一句。
" 本功能将被绑定到<F5>键中。
function AntiTypesetting()
  if getline(".") =~ '[.|?|!|:|。|？|！|：]$'
    if getline(".") !~ '[.|?|!|:|。|？|！|：] '
      return
    endif
  endif
  while getline(".") !~ '[.|?|!|:|。|？|！|：]$'
    execute ":normal J"
  endwhile
  if getline(".") =~ '\. '
    execute 's/\. /.
/g'
  endif
  if getline(".") =~ '? '
    execute 's/? /?
/g'
  endif
  if getline(".") =~ '! '
    execute 's/! /!
/g'
  endif
  if getline(".") =~ ': '
    execute 's/: /:
/g'
  endif
  if getline(".") =~ '\。'
    execute 's/\。/。
/g'
  endif
  if getline(".") =~ '？'
    execute 's/？/？
/g'
  endif
  if getline(".") =~ '！'
    execute 's/！/！
/g'
  endif
  if getline(".") =~ '：'
    execute 's/：/：
/g'
  endif
    execute ":normal oj"
endfunction
nmap <F5> <ESC>:call AntiTypesetting()<RETURN>

" 下面是我的@寄存器命令，这些命令需要自己操作。
" markdown的语法：区块代码 BlockCode
" @a "ay$  $xoOI    p 
" markdown的语法：行内代码 LineCode
" @b "by$ xi``hp
" markdown的语法：强调 empesize
" @c "cy$ xi****hhp
" markdown的语法：区块引言 BlockQuotes，插入>和空格
" @d "dy$ 0i> j
" markdown的语法：无序清单UnorderList， 插入空格和-
" @e "ey$ I  - 
" 合并原文和译文
" @f "fy$ A    || Jj 
" 开头空两格
" @g "gy$ I  
" 开头插入注释符号#
" @h "hy$ I#  
" 以#开头的行为界限进行折叠
" @z "zy$ vj/^#
kzfj

" 我的笔记缩写
iabbr kn <kinder:note>
iabbr kc </kinder:note>
iabbr kv # vim: set filetype=markdown :
iabbr a1 ā
iabbr a2 á
iabbr a3 ǎ
iabbr a4 à
iabbr o1 ō
iabbr o2 ó
iabbr o3 ǒ
iabbr o4 ò
iabbr e1 ē
iabbr e2 é
iabbr e3 ě
iabbr e4 è
iabbr i1 ī
iabbr i2 í
iabbr i3 ǐ
iabbr i4 ì
iabbr u1 ū
iabbr u2 ú
iabbr u3 ǔ
iabbr u4 ù
iabbr v0 ü
iabbr v2 ǘ
iabbr v3 ǚ
iabbr v4 ǜ

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

" In many terminal emulators the mouse works just fine, thus enable it.
" 激活鼠标定位
if has('mouse')
  set mouse=a
endif

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
" 如果终端支持彩色显示，则显示语法高亮和搜索高亮。
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")

  " Enable file type detection. 激活文档类型检测：插件、缩进
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  " 如果是text文件，则将文件宽度设置为78字符。
  autocmd FileType text setlocal textwidth=78

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  " Also don't do it when the mark is in the first line, that is the default
  " position when opening a file.
  autocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif |
  " 下面在打开文件时在该目录寻找同名ses会话文件以便载入。
  autocmd BufReadPost *
    \ let s:session_file = expand("%") . ".ses" |
    \ if filereadable(s:session_file) == 1 |
    \ execute "source" s:session_file |
    \ endif
  " 下面在保存文件之后，自动保存会话信息。
  " 如果没有同名会话文件，则询问是否保存。
  autocmd BufWritePost *
    \ let s:session_file = expand("%") . ".ses" |
    \ if filewritable(s:session_file) == 1 |
    \   execute "mksession!" s:session_file |
    \ else |
    \   echo "是否保存会话以便折叠? [y|n] " |
    \   if nr2char(getchar()) == "y" |
    \     execute "mksession!" s:session_file |
    \   endif  |
    \ endif

  augroup END

else

  set autoindent		" always set autoindenting on
                    " 如果不能运行自动命令，则自动缩进。
endif " has("autocmd")

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
" 比较修改后的文本和原文本
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
		  \ | wincmd p | diffthis
endif

" 设置gvim的字体。lubuntu的字体显示有问题。
if has('gui_gtk2')
  set guifont=Bitstream\ Vera\ Sans\ Mono\ 10
endif

"---------------------vundle start--------------------------
" 安装：
" git clone https://github.com/gmarik/vundle.git ~/.vim/bundle/Vundle.vim

set nocompatible              " be iMproved, required  必须的
filetype off                  " required  必须的

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
" call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required  必须的。
Plugin 'gmarik/Vundle.vim'

" The following are examples of different formats supported.
" Keep Plugin commands between vundle#begin/end.
" 将插件命令放在begin和end之间。
" 1.插件在GitHub仓库。
" plugin on GitHub repo  
" Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-rails'
Plugin 'scrooloose/nerdtree'
Plugin 'scrooloose/nerdcommenter'
Plugin 'honza/vim-snippets'
Plugin 'Lokaltog/vim-easymotion'
Plugin 'Valloric/YouCompleteMe'
" 2. 插件在vim仓库
" plugin from http://vim-scripts.org/vim/scripts.html 
" Plugin 'L9'
Plugin 'FencView.vim'
Plugin 'UltiSnips'
Plugin 'AutoClose'
Plugin 'ZenCoding.vim'
" 3. 插件不在GitHub上
" Git plugin not hosted on GitHub
" Plugin 'git://git.wincent.com/command-t.git'
" 4.本地git仓库。
" git repos on your local machine (i.e. when working on your own plugin)
" Plugin 'file:///home/gmarik/path/to/plugin'
" 5. 脚本在仓库的子目录
" The sparkup vim script is in a subdirectory of this repo called vim.
" Pass the path to set the runtimepath properly.
" Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}
" Avoid a name conflict with L9
" Plugin 'user/L9', {'name': 'newL9'}

" All of your Plugins must be added before the following line
call vundle#end()            " required 必须
filetype plugin indent on    " required 必须
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList          - list configured plugins
" :PluginInstall(!)    - install (update) plugins
" :PluginSearch(!) foo - search (or refresh cache first) for foo
" :PluginClean(!)      - confirm (or auto-approve) removal of unused plugins
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line
"---------------------vundle   end--------------------------
"
"
  "NERDTree plugin
  let NERDTreeWinPos = "right" "where NERD tree window is placed on the screen
  let NERDTreeWinSize = 31 "size of the NERD tree
  nmap <F8> <ESC>:NERDTreeToggle<RETURN>      
  " Open and close the NERD_tree.vim separately

set showcmd		" display incomplete commands
             	" 在状态栏显示未完成输入的命令
