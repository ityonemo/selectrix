# Selectrix

A Static Typechecker for Elixir

## Warning

Currently this software is vaporware, this archive is only the
outermost shell and performs no actual typechecking.

## Features

- a custom type-system for the beam that is not based on any theoretical typesystems, but is based on experience with the BEAM.

- not a DSL in the elixir language (no macros in the checked code)

- Hooks into the elixir compiler tracer, and has a way of invocation that works even if it should require a tracer message that doesn’t exist yet.

- Pluggable

## Current non-features

- Performance.  Expect the first iteration to cause your compilation times to increase.

- PLT Caching.  This will probably be necessary in future iterations.

## Default Type Checker

- defaults to the elixir type system as defined by [mavis](https://github.com/ityonemo/mavis)

## Basic examples

```elixir
defmodule AddFail do
  def add(a) do
    a + "fail"
  end

  @after_compile Selectrix.TypeCheck
end
```

causes the compiler error:

```text
nofile:3: (type error)

function Kernel.+/2 with spec
  (integer(), integer()) :: integer()
  (float(), float()) :: float()
  (integer(), float()) :: float()
  (float(), float()) :: float()
called with (a :: any(), "fail" :: <<_::32, _::_*8>>)
```

```elixir
defmodule AddWarn do
  @spec add(integer | :atom) :: integer
  def add(a) do
    a + 3
  end

  @after_compile Selectrix.TypeCheck
end
```

causes the compiler warning:

```text
warning: input types a :: integer() | atom(), 3 :: 3 may fail with function `Kernel.+/2` with spec
  (integer(), integer()) :: integer()
  (float(), float()) :: float()
  (integer(), float()) :: float()
  (float(), float()) :: float()

  nofile:4: AddWarn.add/1
```

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

