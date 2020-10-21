defmodule Selectrix.Message do
  def warn(reasons, env) when is_list(reasons) do
    Enum.map(reasons, &warn(&1, env))
  end
  def warn(reason, env) do
    metadata = reason.meta
    |> Keyword.take([:line, :file])
    |> Enum.into(%{})

    IO.warn("""
    no messages yet
    """,
    env |> Map.merge(metadata) |> Macro.Env.stacktrace)
  end

  def error_params(reason, env) do
    Keyword.merge([
      description: "no message yet",
      line: env.line,
      file: env.file
    ], reason.meta)
  end
end
