defmodule SelectrixTest.SpecCheckTest do
  use ExUnit.Case, async: true
  import ExUnit.CaptureIO

  # make sure it syncs with the expectations defined in the README.md

  defp capture_err(fun) do
    capture_io(:stderr, fun)
  end

  @spec_error_input """
  defmodule SelectrixTest.TestSpecInputError do

    @spec function(integer) :: integer
    def function(x) do
      :erlang.size(x)
    end

    @after_compile Selectrix.TypeCheck
  end
  """

  @error_input_msg ""

  test "selectrix errors on incorrect input spec" do
    assert_raise CompileError, @spec_error_input, fn ->
      Code.compile_string(@error_input_msg)
    end
  end

  @spec_error_output """
  defmodule SelectrixTest.TestSpecOutputError do

    @spec function(String.t) :: atom
    def function(x) do
      :erlang.size(x)
    end

    @after_compile Selectrix.TypeCheck
  end
  """

  @error_output_msg ""

  test "selectrix errors on incorrect output spec" do
    assert_raise CompileError, @spec_error_output, fn ->
      Code.compile_string(@error_output_msg)
    end
  end

  @spec_warn_input """
  defmodule SelectrixTest.TestSpecInputWarn do

    @spec function(binary | atom) :: non_neg_integer
    def function(x) do
      :erlang.size(x)
    end

    @after_compile Selectrix.TypeCheck
  end
  """

  test "selectrix warns on overbroad input spec" do
    assert (capture_err fn ->
      Code.compile_string(@spec_warn_input)
    end) =~ "some error"
  end

  @spec_warn_output_broad """
  defmodule SelectrixTest.TestSpecOutputBroad do

    @spec function(binary) :: non_neg_integer | atom
    def function(x) do
      :erlang.size(x)
    end

    @after_compile Selectrix.TypeCheck
  end
  """

  test "selectrix warns on overbroad output spec" do
    assert (capture_err fn ->
      Code.compile_string(@spec_warn_output_broad)
    end) =~ "some error"
  end

  @spec_warn_output_narrow """
  defmodule SelectrixTest.TestSpecOutputNarrow do

    @spec function(binary) :: 1..100
    def function(x) do
      :erlang.size(x)
    end

    @after_compile Selectrix.TypeCheck
  end
  """

  test "selectrix warns on narrow output spec" do
    assert (capture_err fn ->
      Code.compile_string(@spec_warn_output_narrow)
    end) =~ "some error"
  end

end
