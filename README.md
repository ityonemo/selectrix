# Selectrix

**Static Typechecker for Elixir**

## Basic example

```elixir
defmodule AddFail do
  def add(a) do
    a + "fail"
  end

  @after_compile Selectrix.TypeCheck
end
```

causes the compiler error:

<pre><code style="color:red">function Kernel.+/2 with spec
  (integer(), integer()) :: integer()
  (float(), float()) :: float()
  (integer(), float()) :: float()
  (float(), float()) :: float()
got (any, <<::32+_*8>>)
</code></pre>

## Future Installation

The package will be able to be installed by adding `selectrix` to your list of
dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:selectrix, "~> 0.1.0"}
  ]
end
```

Docs will be found at [https://hexdocs.pm/selectrix](https://hexdocs.pm/selectrix).

