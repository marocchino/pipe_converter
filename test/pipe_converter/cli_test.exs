defmodule PipeConverter.CLITest do
  use ExUnit.Case
  import PipeConverter.CLI
  import ExUnit.CaptureIO
  doctest PipeConverter.CLI

  test "main/1" do
    assert capture_io(fn -> main(["--revert", "name = inner |> outer()"]) end) ==
             "name = outer(inner)\n"

    assert capture_io(fn -> main(["name = outer(inner)"]) end) ==
             "name = inner |> outer()\n"

    assert capture_io(fn -> main(["--revert", "name <- inner |> outer()"]) end) ==
             "name <- outer(inner)\n"

    assert capture_io(fn -> main(["name <- outer(inner)"]) end) ==
             "name <- inner |> outer()\n"

    assert capture_io(fn -> main(["--revert", "name -> inner |> outer()"]) end) ==
             "name -> outer(inner)\n"

    assert capture_io(fn -> main(["name -> outer(inner)"]) end) ==
             "name -> inner |> outer()\n"
  end
end
