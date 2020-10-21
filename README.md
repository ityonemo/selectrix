# Selectrix

A Static Typechecker for Elixir

## Warning

Currently this software is vaporware, at the moment this repo is only the
outermost shell and performs no actual typechecking.  Considerable
work will be going into [mavis](https://github.com/ityonemo/mavis) and 
[mavis_inference](https://github.com/ityonemo/mavis) before
further work happens here.

## Funding

@Dusty on Elixirforums suggested that I take GitHub sponsorship, so that
has been set up.  I feel like this funding structure vaguely
disincentivizes "get this POC out"-type projects on a timetable, and
is more suited for projects that need long-term maintenance.  But it's
the simplest thing I could do.  Accordingly, the sponsorships will
be terminated before the end of November.  If you'd prefer a different
way of leaving me a tip, message me on elixirforums (my gh handle) or
the Elixir Slack (my gh handle).

## Updates

check the issues list for updates

## Features

- a custom type-system for the beam that is not based on any theoretical typesystems, but is based on experience with the BEAM.

- not a DSL in the elixir language (no nonstandard macros in the checked code)

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

