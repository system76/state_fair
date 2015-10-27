defmodule StateFair do
  @moduledoc """
  Provides a state manager system.
  """

  @doc """
  Register a state machine on a property of the current module's struct.
  """
  defmacro state_manager(property, do: block) do
    quote do
      @state_manager_property unquote(property)
      unquote(block)
    end
  end

  @doc """
  Register an event in the current state machine.
  """
  defmacro event(name, do: block) do
    quote do
      @event_transitions []
      unquote(block)

      def unquote(name)(struct), do: StateFair.StateManager
        .handle_event(struct, @state_manager_property, @event_transitions)

      def unquote(:"can_#{name}?")(struct), do: StateFair.StateManager
        .can_handle_event?(struct, @state_manager_property, @event_transitions)

      def unquote(:"#{name}!")(struct), do: StateFair.StateManager
        .handle_event!(struct, @state_manager_property, @event_transitions)
    end
  end

  @doc """
  Register a transition within an event.
  """
  defmacro transition(from: from, to: to) do
    quote do
      @event_transitions [{unquote(from), unquote(to)}|@event_transitions]
    end
  end
end
