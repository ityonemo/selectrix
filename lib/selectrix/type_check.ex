defmodule Selectrix.TypeCheck do
  def __after_compile__(env, binary) do
    :elixir_env.trace({:after_compile, binary}, env)
  end
end
