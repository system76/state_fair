defmodule TestModule do
  import StateFair

  defstruct state: :new

  state_manager :state do
    event :do_stuff do
      transition from: :new, to: :done
    end

    event :change_color do
      transition from: :green, to: :red
      transition from: :green, to: :blue
    end
  end
end

defmodule StateFairTest do
  use ExUnit.Case, async: true
  doctest StateFair

  test "events change the state of their structs" do
    {:ok, mod} = %TestModule{state: :new} |> TestModule.do_stuff

    assert mod.state == :done
  end

  test "returns :error on invalid transitions" do
    assert %TestModule{state: :invalid} |> TestModule.do_stuff == :error
  end

  test "it picks the first matching transition" do
    {:ok, mod} = %TestModule{state: :green} |> TestModule.change_color

    assert mod.state == :red
  end

  test "reports whether events can be fired" do
    assert %TestModule{state: :new} |> TestModule.can_do_stuff?
    refute %TestModule{state: :done} |> TestModule.can_do_stuff?
  end

  test "bang events change the state of their structs" do
    mod = %TestModule{state: :new} |> TestModule.do_stuff!

    assert mod.state == :done
  end

  test "bang events raise an exception on invalid transitions" do
    assert_raise StateFair.InvalidTransitionError, fn ->
      %TestModule{state: :invalid} |> TestModule.do_stuff!
    end
  end
end
