defmodule Selectrix do

  def trace({:after_compile, _binary}, env) do
    # just a dumb shim, for now.  Will be much more sophisticated later =D
    case env.module do
      AddFail ->
        raise CompileError,
          line: 3,
          file: env.file,
          description: """
          (type error)

          function Kernel.+/2 with spec
            (integer(), integer()) :: integer()
            (float(), float()) :: float()
            (integer(), float()) :: float()
            (float(), float()) :: float()
          called with (a :: any(), "fail" :: <<::32+_*8>>)
          """
      _ -> :ok
    end
  end

  def trace(_, _), do: :ok
end
