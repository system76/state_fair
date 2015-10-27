# StateFair

Inspired by the[`state_machine` ruby gem](https://github.com/pluginaweek/state_machine),
this

## Installation

The package can be installed as:

  1. Add state_fair to your list of dependencies in `mix.exs`:

        def deps do
          [{:state_fair, "~> 0.1"}]
        end

## Overview

```elixir
defmodule Order do
  import StateFair

  defstruct status: :new

  state_manager :status do
    event :purchase do
      transition from: :new, to: :ordered
    end

    event :ship do
      transition from: :ordered, to: :shipped
    end

    event :cancel do
      transition from: [:new, :ordered], to: :cancelled
    end

    event :force_cancel do
      transition from: {:any}, to: :cancelled
    end
  end
end

order = %Order{status: :new}

{:ok, order} = order |> Order.purchase # => order.status == :ordered

if order |> Order.can_ship? do
  order = order |> Order.ship! # => order.status == :shipped
end

order |> Order.cancel # => :error
order |> Order.cancel! # throws StateFair.InvalidTransitionError
order |> Order.force_cancel! # => order.status == :cancelled
```
