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

  defp response({opts, code}) do
    if opts[:revert] do
      code |> to_tree |> to_braces
    else
      code |> to_tree |> to_pipe
    end
  end
end
