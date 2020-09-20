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

causes a compiler error:

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

