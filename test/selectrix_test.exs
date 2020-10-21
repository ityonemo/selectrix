defmodule SelectrixTest do
  use ExUnit.Case, async: true
  import ExUnit.CaptureIO

  # make sure it syncs with the expectations defined in the README.md

  defp capture_err(fun) do
    capture_io(:stderr, fun)
  end

  readme_content = __DIR__
  |> Path.join("../README.md")
  |> File.read!
  |> String.split("```")

  [failing_code, warning_code] = readme_content
  |> Enum.reject(&(&1 =~ "deps"))
  |> Enum.filter(&String.starts_with?(&1, "elixir"))
  |> Enum.map(&String.trim(&1, "elixir\n"))

  [error_msg, warn_msg] = readme_content
  |> Enum.filter(&String.starts_with?(&1, "text"))
  |> Enum.map(&String.trim(&1, "text\n"))

  @failing_code failing_code
  @error_msg error_msg

  test "type error causes fail" do
    assert_raise CompileError, @error_msg, fn ->
      Code.compile_string(@failing_code)
    end
  end

  @warning_code warning_code
  @warn_msg String.replace(warn_msg, "warning: ", IO.ANSI.yellow() <> "warning: " <> IO.ANSI.reset())

  test "type warn emits to stderr" do
    assert (capture_err fn ->
      Code.compile_string(@warning_code)
    end) =~ @warn_msg
  end
end
