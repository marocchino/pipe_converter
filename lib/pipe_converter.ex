defmodule PipeConverter do
  @moduledoc """
  No content here
  """

  @regex ~r/
    (?:
      (?:[:@]?\w+|
        [.\w]+|
        ~\w[\/\|"'(\[{<].+[\/\|"')\]}>]\w*|
        ".*"|
        '.*'|
        %?{.*}|%\w+{.*}|
        (?:\w+)?\[.*\]
      )\s+\|>\s+
    )?
    [.\w]+\(.*\)
    (?:\s+\|>\s+[.\w]+\(.*?\))*
  /x
  @doc """
  Replace relative code with callback

  ## Examples

      iex> replace("name -> func(arg),", fn _ -> "<<code>>" end)
      "name -> <<code>>,"
      iex> replace("name -> arg_name |> func(),", fn _ -> "<<code>>" end)
      "name -> <<code>>,"
      iex> replace("name -> arg.name |> func(),", fn _ -> "<<code>>" end)
      "name -> <<code>>,"
      iex> replace("name -> arg[:name] |> func(),", fn _ -> "<<code>>" end)
      "name -> <<code>>,"
      iex> replace(~s'name -> arg["name"] |> func(),', fn _ -> "<<code>>" end)
      "name -> <<code>>,"
      iex> replace("name -> @arg |> func(),", fn _ -> "<<code>>" end)
      "name -> <<code>>,"
      iex> replace(~s'name -> "" |> func(),', fn _ -> "<<code>>" end)
      "name -> <<code>>,"
      iex> replace(~s'name -> "arg" |> func(),', fn _ -> "<<code>>" end)
      "name -> <<code>>,"
      iex> replace("name -> '' |> func(),", fn _ -> "<<code>>" end)
      "name -> <<code>>,"
      iex> replace("name -> 'arg' |> func(),", fn _ -> "<<code>>" end)
      "name -> <<code>>,"
      iex> replace("name -> {} |> func(),", fn _ -> "<<code>>" end)
      "name -> <<code>>,"
      iex> replace("name -> {1, 2, 3} |> func(),", fn _ -> "<<code>>" end)
      "name -> <<code>>,"
      iex> replace("name -> %{} |> func(),", fn _ -> "<<code>>" end)
      "name -> <<code>>,"
      iex> replace("name -> %{a: 1} |> func(),", fn _ -> "<<code>>" end)
      "name -> <<code>>,"
      iex> replace("name -> [] |> func(),", fn _ -> "<<code>>" end)
      "name -> <<code>>,"
      iex> replace("name -> [1, 2] |> func(),", fn _ -> "<<code>>" end)
      "name -> <<code>>,"
      iex> replace("name -> ~w[1 2] |> func(),", fn _ -> "<<code>>" end)
      "name -> <<code>>,"
      iex> replace("name -> Module |> func(),", fn _ -> "<<code>>" end)
      "name -> <<code>>,"
      iex> replace("name -> %Struct{} |> func(),", fn _ -> "<<code>>" end)
      "name -> <<code>>,"
      iex> replace("name -> %Struct{name: nil} |> func(),", fn _ -> "<<code>>" end)
      "name -> <<code>>,"
      iex> replace("name -> ~w[a b c]a |> func(),", fn _ -> "<<code>>" end)
      "name -> <<code>>,"
      iex> replace("name -> ~r/a b c/i |> func(),", fn _ -> "<<code>>" end)
      "name -> <<code>>,"
      iex> replace("name -> ~s|a b c| |> func(),", fn _ -> "<<code>>" end)
      "name -> <<code>>,"
      iex> replace("name -> ~s<a b c> |> func(),", fn _ -> "<<code>>" end)
      "name -> <<code>>,"
  """
  @spec replace(String.t(), (String.t() -> String.t())) :: String.t()
  def replace(code, callback) do
    Regex.replace(@regex, code, callback)
  end
end
