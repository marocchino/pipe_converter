defmodule PipeConverter do

  def to_braces(tree) do
    if is_list(tree) do
      [method | args] = tree
      "#{method}(#{args |> Enum.map(&to_braces/1) |> Enum.join(", ")})"
    else
      tree
    end
  end

  def to_pipe(tree) do
    case tree do
      tree when not is_list(tree) -> tree
      [method] ->
        "#{method}()"
      [method, arg1] ->
        "#{to_pipe(arg1)} |> #{method}"
      [method, arg1 | args] ->
        rest_args = args |> Enum.map(&to_pipe/1) |> Enum.join(", ")
        "#{to_pipe(arg1)} |> #{method}(#{rest_args})"
    end
  end

  def to_tree(code) do
    if String.contains?(code, "|>") do
      [head, rest] = split_pipe(code)
      case to_tree(rest) do
         [method | args] -> [method, to_tree(head) | args]
         method -> [method, to_tree(head)]
      end
    else
      map =
        Regex.named_captures(~r/(?<method>[^(]+)(?<brakets>\((?<args>.*)\))?/,
                             code)
      case map["brakets"] do
        "" -> map["method"]
        "()" -> [map["method"]]
        _ ->
          tail = map["args"] |> split_args |> Enum.map(&to_tree/1)
          [map["method"] | tail]
      end
    end
  end

  def split_pipe(args) do
    [tail | heads] = args |> String.split(~r(\s*\|>\s*)) |> Enum.reverse
    head = heads |> Enum.reverse |> Enum.join(" |> ")
    [head, tail]
  end

  def split_args(""), do: []
  def split_args(args) do
    args |> String.split(~r/\s*,\s*/) |> do_split_args
  end

  defp do_split_args([]), do: []
  defp do_split_args([head]), do: [head]
  defp do_split_args([head | tail]) do
    if closed?(head) do
      [head | do_split_args(tail)]
    else
      [h | t] = tail
      do_split_args([head <> ", " <> h | t])
    end
  end

  defp closed?(str) do
    graphemes = String.graphemes(str)
    Enum.count(graphemes, fn(x) -> x == "(" end) ==
      Enum.count(graphemes, fn(x) -> x == ")" end)
  end
end
