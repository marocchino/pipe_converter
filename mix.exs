defmodule PipeConverter.Mixfile do
  use Mix.Project

  def project do
    [app: :pipe_converter,
     version: "0.1.0",
     escript: escript,
     elixir: "~> 1.3",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps()]
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
end
