{ pkgs, ... }: {
  enable = true;
  settings = {
    background = "dark";
    copyindent = false;
    expandtab = true;
    hidden = true;
    mouse = "a";
    number = true;
    relativenumber = true;
    shiftwidth = 2;
    tabstop = 2;
    undofile = true;
  };
  extraConfig = ''
    " Standard Settings
    set nocompatible
    syntax on
    set re=0
    filetype plugin indent on
    set backspace=indent,eol,start
    set softtabstop=2
    set textwidth=80
    set autowrite
    set autowriteall
    set autoread
    set showcmd
    set laststatus=2
    set showtabline=2
    set guioptions-=e
    set splitbelow splitright
    set backupdir=.backup/,~/.backup/,/tmp//
    set directory=.swp/,~/.swp/,/tmp//
    set undodir=.undo/,~/.undo/,/tmp//
    map <Space> <Leader>

    " ALE Settings
    let g:ale_fix_on_save = 1 " Run fixers on write
    let g:ale_completion_enabled = 1 " Allow autocompletion
    let g:ale_completion_autoimport = 1 " Allow autocompletion of imports
    let g:ale_set_balloons = 1 " Show hover info in balloon

    " ALE deno customization
    let g:ale_deno_unstable = 1
    " autocmd BufNewFile,BufRead *.ts if filereadable("tsconfig.json") | let g:ale_deno_lsp_project_root = 'tsconfig.json' | endif

    " ALE Autocompletion
    set omnifunc=ale#completion#OmniFunc

    " ALE mappings
    nmap gr <Plug>(ale_rename)
    nmap gR <Plug>(ale_find_reference)
    nmap gd <Plug>(ale_go_to_definition)
    nmap gD <Plug>(ale_go_to_type_definition)
    nmap <Leader>h <Plug>(ale_hover)
    nmap <Leader>j <Plug>(ale_code_action)
    nmap <Leader>f <Plug>(ale_fix)

    " ALE linters
    let g:ale_linters = {
    \  'javascript': ['deno'],
    \  'javascriptreact': ['deno'],
    \  'nix': ['nix'],
    \  'typescript': ['deno'],
    \  'typescriptreact': ['deno'],
    \  'rust': ['analyzer'],
    \  'json': ['jq'],
    \  'go': ['gofmt', 'gopls']
    \}

    " ALE fixers (formatting)
    let g:ale_fixers = {
    \  '*': ['remove_trailing_lines', 'trim_whitespace'],
    \  'javascript': ['deno'],
    \  'javascriptreact': ['deno'],
    \  'nix': ['nixpkgs-fmt'],
    \  'typescript': ['deno'],
    \  'typescriptreact': ['deno'],
    \  'rust': ['rustfmt'],
    \  'json': ['jq'],
    \  'go': ['gofmt', 'goimports']
    \}
  '';
  plugins = [
    pkgs.vimPlugins.ale
  ];
}
