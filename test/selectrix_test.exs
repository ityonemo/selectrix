defmodule SelectrixTest do
  use ExUnit.Case, async: true

  # make sure it syncs with the expectations defined in the README.md

  readme_content = __DIR__
  |> Path.join("../README.md")
  |> File.read!
  |> String.split("```")

  failing_code = readme_content
  |> Enum.reject(&(&1 =~ "deps"))
  |> Enum.find(&String.starts_with?(&1, "elixir"))
  |> String.trim("elixir\n")

  @failing_code failing_code

  error_msg = readme_content
  |> Enum.find(&String.starts_with?(&1, "text"))
  |> String.trim("text\n")

  @error_msg error_msg

  test "compiler causes fail" do
    assert_raise CompileError, @error_msg, fn ->
      Code.compile_string(@failing_code)
    end
  end
end
