defmodule PipeConverter.Mixfile do
  use Mix.Project

  def project do
    [app: :pipe_converter,
     version: "0.1.0",
     escript: escript,
     elixir: "~> 1.3",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps(),
     package: package(),
     description: description()]
  end

  def application do
    [applications: [:logger]]
  end

  defp deps do
    []
  end

  defp escript do
    [main_module: PipeConverter.CLI]
  end

  defp description do
    """
    The pipe converter can convert a line of code to pipe operator style
    and revert it.

    ```
    $ cd pipe_converter
    $ ./pipe_converter "a(b, c, d)"
    b |> a(c, d)
    $ ./pipe_converter --revert "b |> a |> c(d)"
    c(a(b), d)
    ```
    """
  end

  defp package do
    [name: :pipe_converter,
     files: ["lib", "plugin", "mix.exs", "README.md", "LICENSE"],
     maintainers: ["marocchino"],
     licenses: ["MIT"],
     links: %{"GitHub" => "https://github.com/marocchino/ffaker"}]
  end
end
