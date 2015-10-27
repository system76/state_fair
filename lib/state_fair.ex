defmodule StateFair do
  defmacro state_manager(property, do: block) do
    quote do
      @state_manager_property unquote(property)
      unquote(block)
    end
  end

  defmacro event(name, do: block) do
    quote do
      @event_transitions []
      unquote(block)

      def unquote(name)(struct) do
        StateFair.StateManager.handle_event(struct, @state_manager_property, @event_transitions)
      end

      def unquote(:"can_#{name}?")(struct) do
        StateFair.StateManager.can_handle_event?(struct, @state_manager_property, @event_transitions)
      end

      def unquote(:"#{name}!")(struct) do
        StateFair.StateManager.handle_event!(struct, @state_manager_property, @event_transitions)
      end
    end
  end

  defmacro transition(from: from, to: to) do
    quote do
      @event_transitions [{unquote(from), unquote(to)}|@event_transitions]
    end
  end
end
