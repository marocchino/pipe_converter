# PipeConverter

**note**: It is early release. It has some bugs and lack of use cases.

## Demo

[![asciicast](https://asciinema.org/a/7345c7n8th9jdbq4n39lrb409.png)](https://asciinema.org/a/7345c7n8th9jdbq4n39lrb409)

## Config

### Vim

```viml
" Add this line to your .vimrc file
" Vundle
Plugin 'marocchino/pipe_converter'

" Plug
Plug 'marocchino/pipe_converter', { 'do': 'mix escript.build' }

" minpac
call minpac#add('marocchino/pipe_converter', { 'do': 'mix escript.build' })



let g:pipe_converter_command = "~/.vim/plugged/pipe_converter/pipe_converter"


" Change it your own keymap.
nnoremap ec :call PipeConvert()<CR>
nnoremap er :call PipeRevert()<CR>
```

## Usage in shell

```bash
$ cd pipe_converter
$ ./pipe_converter "a(b, c, d)"
b |> a(c, d)
$ ./pipe_converter --revert "b |> a |> c(d)"
c(a(b), d)
```

## Escript Build

```bash
$ mix escript.build
```

## Test

```bash
$ mix test
```
