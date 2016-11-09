defmodule PipeConverter.CLI do
  import PipeConverter

  def main(args \\ []) do
    args |> parse_args |> response |> IO.puts
  end

  defp parse_args(args) do
    {opts, params, _} = OptionParser.parse(args, switches: [revert: :boolean])
    [code | _] = params
    {opts, code}
  end

  defp response({opts, " " <> tail}), do: " " <> response({opts, tail})
  defp response({opts, "\t" <> tail}), do: "\t" <> response({opts, tail})
  defp response({opts, code}) do
    cond do
      String.contains?(code, "=") ->
        [head, tail] = String.split(code, "=")
        head <> "=" <> response({opts, tail})
      String.contains?(code, "<-") ->
        [head, tail] = String.split(code, "<-")
        head <> "<-" <> response({opts, tail})
      String.contains?(code, "->") ->
        [head, tail] = String.split(code, "->")
        head <> "->" <> response({opts, tail})
      opts[:revert] ->
        code |> to_tree |> to_braces
      :else ->
        code |> to_tree |> to_pipe
    end
  end
end
