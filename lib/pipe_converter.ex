defmodule PipeConverter do
  @moduledoc """
  No content here
  """

  @spec trim_leading(String.t(), String.t()) :: {String.t(), String.t()}
  def trim_leading(leading, " " <> tail), do: trim_leading(leading <> " ", tail)
  def trim_leading(leading, "\t" <> tail), do: trim_leading(leading <> "\t", tail)

  def trim_leading(leading, code) do
    cond do
      String.contains?(code, "=") ->
        [head, tail] = String.split(code, "=")
        trim_leading(leading <> head <> "=", tail)

      String.contains?(code, "<-") ->
        [head, tail] = String.split(code, "<-")
        trim_leading(leading <> head <> "<-", tail)

      String.contains?(code, "->") ->
        [head, tail] = String.split(code, "->")
        trim_leading(leading <> head <> "->", tail)

      :else ->
        {leading, code}
    end
  end
end
