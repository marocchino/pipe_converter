# PipeConverter

## Usage

```bash
$ ./pipe_converter "a(b, c, d)"
b |> a(c, d)
$ ./pipe_converter --revert "b |> a |> c(d)"
c(a(b), d)
```

## Build

```bash
$ mix escript.build
```

## Test

```bash
$ mix test
```
