defmodule SelectrixTest.CodeCheckTest do
  use ExUnit.Case, async: true
  import ExUnit.CaptureIO

  # make sure it syncs with the expectations defined in the README.md

  defp capture_err(fun) do
    capture_io(:stderr, fun)
  end

  @code_error """
  defmodule SelectrixTest.TestCodeError do

    @spec int_only(integer) :: :ok
    def int_only(integer), do: :ok

    def function() do
      int_only("foo")
    end
    @after_compile Selectrix.TypeCheck
  end
  """

  @error_msg ""

  test "selectrix finds errors in code" do
    assert_raise CompileError, @error_msg, fn ->
      Code.compile_string(@code_error)
    end
  end

  @code_warn """
  defmodule SelectrixTest.TestCodeWarn do

    @spec any_integer() :: integer
    def any_integer do
      :erlang.phash2("foo")
    end

    @spec ranged_int_only(1..10) :: :ok
    def ranged_int_only(_int), do: :ok

    def function(x) do
      any_integer
      |> ranged_int_only
    end

    @after_compile Selectrix.TypeCheck
  end
  """

  test "selectrix finds warnings in code" do
    assert (capture_err fn ->
      Code.compile_string(@code_warn)
    end) =~ "some error"
  end
end
