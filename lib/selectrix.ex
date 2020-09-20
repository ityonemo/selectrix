defmodule Selectrix do

  def trace({:after_compile, _binary}, env) do
    # just a dumb shim, for now.  Will be much more sophisticated later =D
    case env.module do
      AddFail ->
        raise Selectrix.TypeError, message: """
        function Kernel.+/2 with spec
          (integer(), integer()) :: integer()
          (float(), float()) :: float()
          (integer(), float()) :: float()
          (float(), float()) :: float()
        got (any, <<::32+_*8>>)
        """
      _ -> :ok
    end
  end

  def trace(_, _), do: :ok
end
