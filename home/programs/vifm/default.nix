{ pkgs, ... }: {
  home.packages = with pkgs; [
    vifm
  ];

  xdg.configFile."vifm/vifmrc".text = ''
    let &vicmd = $EDITOR

    set syscalls
    set trash
    set vifminfo=dhistory,savedirs,chistory,state,tui,shistory,
          \phistory,fhistory,dirstack,registers,bookmarks,bmarks
    set history=100
    set nofollowlinks
    set sortnumbers
    set undolevels=100
    set vimhelp
    set runexec
    set timefmt='%Y/%m/%d %H:%M'
    set wildmenu
    set wildstyle=popup
    set suggestoptions=normal,visual,view,otherpane,keys,marks,registers
    set ignorecase
    set smartcase
    set nohlsearch
    set incsearch
    set scrolloff=4
    set statusline="  Hint: %z%= %A %10u:%-7g %15s %20d  "

    " make own scheme some day, based on slate/nvim
    colorscheme Default-256 Default

    " BOOKMARKS
    mark b ~/bin/
    mark h ~/

    " COMMANDS
    command! df df -h %m 2> /dev/null
    command! diff ${pkgs.neovim}/bin/nvim -d %f %F
    command! zip ${pkgs.zip}/bin/zip -r %c.zip %f
    command! run !! ./%f
    command! make !!make %a
    command! mkcd :mkdir %a | cd %a
    command! vgrep ${pkgs.neovim}/bin/nvim "+grep %a"
    command! reload :write | restart full

    " FILETYPES
    filextype {*.ove}
      \ {Open project in olive-editor}
      \ olive-editor %f &,

    filextype {*.xcf}
      \ {Open project in GIMP}
      \ gimp %f &,

    filextype {*.kra}
      \ {Open project in Krita}
      \ krita %f &,

    " audio
    filextype {*.wav,*.mp3,*.flac,*.m4a,*.wma,*.ape,*.ac3,*.og[agx],*.spx,*.opus,
      \*.aac,*.mpga},<audio/*>
      \ {Play using mpv}
      \ mpv --no-video %f &,

    " video
    filetype {*.avi,*.mp4,*.wmv,*.dat,*.3gp,*.ogv,*.mkv,*.mpg,*.mpeg,*.vob,
      \*.fl[icv],*.m2v,*.mov,*.webm,*.ts,*.mts,*.m4v,*.r[am],*.qt,*.divx,
      \*.as[fx]},<video/*>
      \ {View in mpv}
      \ mpv %f &,
    filetype *.avi,*.mp4,*.wmv,*.dat,*.3gp,*.ogv,*.mkv,*.mpg,*.mpeg,*.vob,
      \*.fl[icv],*.m2v,*.mov,*.webm,*.ts,*.mts,*.m4v,*.r[am],*.qt,*.divx,
      \*.as[fx]
      \ {View in timg}
      \ timg -pq -V --title --center --clear %f; read -n1 -s -r -p "Press any key to return",
    fileviewer *.avi,*.mp4,*.wmv,*.dat,*.3gp,*.ogv,*.mkv,*.mpg,*.mpeg,*.vob,
      \*.fl[icv],*.m2v,*.mov,*.webm,*.ts,*.mts,*.m4v,*.r[am],*.qt,*.divx,
      \*.as[fx]
      \ timg -pq -V --color8 -g%pwx%ph --title --center --frames=1 %f,

    " image
    filextype {*.bmp,*.jpg,*.jpeg,*.png,*.gif,*.xpm},<image/*>
      \ {View with swayimg}
      \ ${pkgs.swayimg}/bin/swayimg %f &,
    filetype *.bmp,*.jpg,*.jpeg,*.png,*.gif,*.xpm
      \ {View in timg}
      \ timg -ps -E --title --center --clear %f; read -n1 -s -r -p "Press any key to return",
    fileviewer *.bmp,*.jpg,*.jpeg,*.png,*.gif,*.xpm
      \ timg -pq -g%pwx%ph --frames=1 --title --center --clear %f,

    filextype {*.xhtml,*.html,*htm),<text/html>
      \ {Open with firefox}
      \ firefox %f &,
    filetype {*.xhtml,*.html,*htm),<text/html>
      \ {Open with Links}
      \ links %f,

    filetype {*.o},<application/x-object>
      \ {List symbols}
      \ nm %f | less,

    filetype {*.[1-8]]},<text/troff>
      \ {Open man page}
      \ man ./%c
    fileviewer {*.[1-8]]},<text/troff>
      \ man ./%c | col -b

    filetype *.sha1
           \ {Check SHA1 hash sum}
           \ sha1sum -c %f %S,
    filetype *.sha256
           \ {Check SHA256 hash sum}
           \ sha256sum -c %f %S,
    filetype *.sha512
           \ {Check SHA512 hash sum}
           \ sha512sum -c %f %S,

    filetype {*.asc},<application/pgp-signature>
           \ {Check signature}
           \ !!gpg --verify %c,
    
    fileviewer *.zip,*.jar,*.war,*.ear,*.oxt unzip -l %f

    fileviewer *.tgz,*.tar.gz tar -tzf %c
    fileviewer *.tar.bz2,*.tbz2 tar -tjf %c
    fileviewer *.tar.xz,*.txz tar -tJf %c
    fileviewer *.tar.zst,*.tzst tar -t --zstd -f %c
    fileviewer {*.tar},<application/x-tar> tar -tf %c

    " KB MAPPINGS

    " Start shell in current directory
    nnoremap s :shell<cr>
    
    " dir to clipboard
    nnoremap yd :!echo -n %d | ${pkgs.wl-clipboard}/bin/wl-copy %i
      \ && echo -n %d | ${pkgs.wl-clipboard}/bin/wl-copy -p %i<cr>
    " file to clipboard
    nnoremap yf :!echo -n %c:p | ${pkgs.wl-clipboard}/bin/wl-copy %i
      \ && echo -n %c:p | ${pkgs.wl-clipboard}/bin/wl-copy -p %i<cr>

    " faster renaming
    nnoremap I cw<c-a>
    nnoremap cc cw<c-u>
    nnoremap A cw

    " open console in dir
    nnoremap ,t :!$TERM &<cr>

    " MISC
    
    " show dotfiles
    windo normal zo
  '';
}
