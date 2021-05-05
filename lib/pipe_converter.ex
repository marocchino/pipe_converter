defmodule PipeConverter do
  @moduledoc """
  No content here
  """

  @regex ~r/(?:(?:\w+|"\w+"|%?{.+}|\[.+\])\s+\|>\s+)?[.\w]+\(.*?\)(?:\s+\|>\s+[.\w]+\(.*?\))*/
  @doc """
  Replace relative code with callback

  ## Examples

      iex> replace("name -> func(arg),", fn _ -> "<<code>>" end)
      "name -> <<code>>,"
  """
  @spec replace(String.t(), (String.t() -> String.t())) :: String.t()
  def replace(code, callback) do
    Regex.replace(@regex, code, callback)
  end
end
