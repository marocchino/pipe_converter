defmodule PipeConverter.TreeTest do
  use ExUnit.Case, async: true
  import PipeConverter.Tree

  describe "from_code/1" do
    test "1 depth block" do
      assert from_code("outer") == "outer"
      assert from_code("outer()") == ["outer"]
      assert from_code("outer(arg)") == ["outer", "arg"]
      assert from_code("outer(arg1, arg2)") == ["outer", "arg1", "arg2"]

      assert from_code("outer(arg1, arg2, arg3)") ==
               ["outer", "arg1", "arg2", "arg3"]
    end

    test "2 depth block" do
      assert from_code("outer(inner(arg1, arg2))") ==
               ["outer", ["inner", "arg1", "arg2"]]

      assert from_code("outer(inner(arg1, arg2), inner2, inner3())") ==
               ["outer", ["inner", "arg1", "arg2"], "inner2", ["inner3"]]
    end

    test "1 depth pipe" do
      assert from_code("arg |> outer") == ["outer", "arg"]
      assert from_code("\"arg, string\" |> outer") == ["outer", "\"arg, string\""]
      assert from_code("'arg, string' |> outer") == ["outer", "'arg, string'"]
      assert from_code("[1, 2] |> outer") == ["outer", "[1, 2]"]
      assert from_code("{1, method()} |> outer") == ["outer", "{1, method()}"]
      assert from_code("arg1 |> outer(arg2)") == ["outer", "arg1", "arg2"]

      assert from_code("arg1 |> outer(arg2, arg3)") ==
               ["outer", "arg1", "arg2", "arg3"]
    end

    test "2 depth pipe" do
      assert from_code("arg |> inner(arg2) |> outer(inner2)") ==
               ["outer", ["inner", "arg", "arg2"], "inner2"]

      assert from_code("arg |> inner() |> outer(inner2)") ==
               ["outer", ["inner", "arg"], "inner2"]

      assert from_code("arg |> inner() |> outer") == ["outer", ["inner", "arg"]]
    end
  end

  describe "to_braces/1" do
    test "tree can convert to braces" do
      assert to_braces("outer") == "outer"
      assert to_braces(["outer"]) == "outer()"
      assert to_braces(["outer", "arg1", "arg2"]) == "outer(arg1, arg2)"

      assert to_braces(["outer", ["inner", "arg1", "arg2"], "inner2", ["inner3"]]) ==
               "outer(inner(arg1, arg2), inner2, inner3())"
    end
  end

  describe "to_pipe/1" do
    test "tree can convert to pipes" do
      assert to_pipe("outer") == "outer"
      assert to_pipe(["outer"]) == "outer()"
      assert to_pipe(["outer", "arg1", "arg2"]) == "arg1 |> outer(arg2)"
      assert to_pipe(["outer", ["inner", "arg1"]]) == "arg1 |> inner() |> outer()"

      assert to_pipe(["outer", ["inner", "arg1", "arg2"], "inner2", ["inner3"]]) ==
               "arg1 |> inner(arg2) |> outer(inner2, inner3())"
    end
  end

  describe "split_pipe/1" do
    test "split last one" do
      assert split_pipe("arg |> outer(arg2)") == ["arg", "outer(arg2)"]

      assert split_pipe("arg |> inner(arg2) |> outer(inner2)") ==
               ["arg |> inner(arg2)", "outer(inner2)"]
    end
  end

  describe "split_args/1" do
    test "split args" do
      assert split_args("a(b, c(d)), b(), c") == ["a(b, c(d))", "b()", "c"]

      assert split_args("[a(), 'aaaa'], {:tuple, 1}") ==
               ["[a(), 'aaaa']", "{:tuple, 1}"]

      assert split_args("[a(), b()]") == ["[a(), b()]"]
      assert split_args("") == []
    end
  end
end
