defmodule PipeConverter.CLI do
  @moduledoc """
  Parse options and run script
  """
  alias PipeConverter.Tree

  def main(args \\ []) do
    parse_args(args) |> response() |> IO.puts()
  end

  defp parse_args(args) do
    {opts, [code | _], _} = OptionParser.parse(args, switches: [revert: :boolean])
    {opts, code}
  end

  defp response({[revert: true], code}) do
    {l, c} = PipeConverter.trim_leading("", code)
    l <> Tree.to_braces(Tree.from_code(c))
  end

  defp response({_, code}) do
    {l, c} = PipeConverter.trim_leading("", code)
    l <> Tree.to_pipe(Tree.from_code(c))
  end
end
