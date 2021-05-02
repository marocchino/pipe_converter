defmodule PipeConverter.Tree do
  @moduledoc """
  Convert code to tree and convert it
  """
  @type t :: String.t() | list(t())

  @spec from_code(String.t()) :: t()
  def from_code(code) do
    if String.contains?(code, "|>") do
      [head, rest] = split_pipe(code)

      case from_code(rest) do
        [func | args] -> [func, from_code(head) | args]
        func -> [func, from_code(head)]
      end
    else
      map =
        Regex.named_captures(
          ~r/(?<func>[^()]+)(?<brakets>\((?<args>.*)\))?$/,
          code
        )

      case map["brakets"] do
        "" ->
          code

        "()" ->
          [map["func"]]

        _ ->
          tail = map["args"] |> split_args() |> Enum.map(&from_code/1)
          [map["func"] | tail]
      end
    end
  end

  @spec to_braces(t()) :: String.t()
  def to_braces([func | args]) do
    "#{func}(#{args |> Enum.map(&to_braces/1) |> Enum.join(", ")})"
  end

  def to_braces(tree), do: tree

  @spec to_pipe(t()) :: String.t()
  def to_pipe([func]), do: "#{func}()"
  def to_pipe([func, arg1]), do: "#{to_pipe(arg1)} |> #{func}()"

  def to_pipe([func, arg1 | args]) do
    rest_args = Enum.map(args, &to_pipe/1) |> Enum.join(", ")
    "#{to_pipe(arg1)} |> #{func}(#{rest_args})"
  end

  def to_pipe(tree), do: tree

  @spec split_pipe(String.t()) :: t()
  def split_pipe(args) do
    [tail | heads] = String.split(args, ~r(\s*\|>\s*)) |> Enum.reverse()
    head = Enum.reverse(heads) |> Enum.join(" |> ")
    [head, tail]
  end

  @spec split_args(String.t()) :: t()
  def split_args(""), do: []
  def split_args(args), do: String.split(args, ~r/\s*,\s*/) |> do_split_args()

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
    count(str, "(") == count(str, ")") and
      count(str, "[") == count(str, "]") and
      count(str, "{") == count(str, "}")
  end

  defp count(str, c), do: String.graphemes(str) |> Enum.count(&(&1 == c))
end
