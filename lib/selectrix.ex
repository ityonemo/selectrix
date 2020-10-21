defmodule Selectrix do

  def trace({:after_compile, binary}, env) do
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
          called with (a :: any(), "fail" :: <<_::32, _::_*8>>)
          """
      AddWarn ->
        IO.warn(
          """
          input types a :: integer() | atom(), 3 :: 3 may fail with function `Kernel.+/2` with spec
            (integer(), integer()) :: integer()
            (float(), float()) :: float()
            (integer(), float()) :: float()
            (float(), float()) :: float()
          """,
          Macro.Env.stacktrace(
            %{env | line: 4, function: {:add, 1}}))
      _module ->
        trace_module(binary, env)
    end
  end

  def trace(_, _), do: :ok

  @info_funs ~w(__info__ module_info)a

  def trace_module(binary, env) do
    {:beam_file, _, _, _, _, funs} = :beam_disasm.file(binary)

    funs
    |> Stream.reject(fn {:function, name, _, _, _} -> name in @info_funs end)
    |> Stream.map(&Type.Inference.infer/1)
    |> Enum.each(fn
      :ok -> :ok
      {:maybe, reasons} ->
        Selectrix.Message.warn(reasons, env)
      {:error, reason} ->
        params = Selectrix.Message.error_params(reason, env)
        raise CompileError, params
    end)
  end
end
