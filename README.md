# PipeConverter

## Config

### Vim

```viml
" Add this line to your .vimrc file
Plugin 'marocchino/pipe_converter'

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
