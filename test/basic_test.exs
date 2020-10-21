defmodule SelectrixTest.CheckFunctions do
  use ExUnit.Case, async: true

  @function_body_fail """
  defmodule TestCodeError do
    def function(x) do
      x + "foo"
    end
    @after_compile Selectrix.TypeCheck
  end
  """

  @error_msg ""

  test "selectrix tests function contents" do
    assert_raise CompileError, @error_msg, fn ->
      Code.compile_string(@function_body_fail)
    end
  end

end
