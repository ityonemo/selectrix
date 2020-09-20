defmodule SelectrixTest do
  use ExUnit.Case, async: true

  @failing_code """
  defmodule AddFail do
    def add(a) do
      a + "fail"
    end

    @after_compile Selectrix.TypeCheck
  end
  """

  test "compiler causes fail" do
    msg = """
    function Kernel.+/2 with spec
      (integer(), integer()) :: integer()
      (float(), float()) :: float()
      (integer(), float()) :: float()
      (float(), float()) :: float()
    got (any, <<::32+_*8>>)
    """

    assert_raise Selectrix.TypeError, msg, fn ->
      Code.compile_string(@failing_code)
    end
  end
end
