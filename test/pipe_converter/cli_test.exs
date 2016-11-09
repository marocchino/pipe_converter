defmodule PipeConverter.CLITest do
  use ExUnit.Case
  import PipeConverter.CLI
  import ExUnit.CaptureIO
  doctest PipeConverter.CLI

  describe "main/1" do
    test "print to IO" do
      assert capture_io(fn -> main(["--revert","inner |> outer"]) end) ==
             "outer(inner)\n"
      assert capture_io(fn -> main(["outer(inner)"]) end) ==
             "inner |> outer\n"
    end

    test "remain leading spaces" do
      assert capture_io(fn -> main(["--revert","    inner |> outer"]) end) ==
             "    outer(inner)\n"
      assert capture_io(fn -> main(["    outer(inner)"]) end) ==
             "    inner |> outer\n"
      assert capture_io(fn -> main(["--revert","\tinner |> outer"]) end) ==
             "\touter(inner)\n"
      assert capture_io(fn -> main(["\touter(inner)"]) end) ==
             "\tinner |> outer\n"
    end

    test "leading pattern matching" do
      assert capture_io(fn -> main(["--revert","name = inner |> outer"]) end) ==
             "name = outer(inner)\n"
      assert capture_io(fn -> main(["name = outer(inner)"]) end) ==
             "name = inner |> outer\n"
      assert capture_io(fn -> main(["--revert","name <- inner |> outer"]) end) ==
             "name <- outer(inner)\n"
      assert capture_io(fn -> main(["name <- outer(inner)"]) end) ==
             "name <- inner |> outer\n"
      assert capture_io(fn -> main(["--revert","name -> inner |> outer"]) end) ==
             "name -> outer(inner)\n"
      assert capture_io(fn -> main(["name -> outer(inner)"]) end) ==
             "name -> inner |> outer\n"
    end
  end
end
