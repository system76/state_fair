defmodule StateFair.StateManager do
  def handle_event(struct, property, transitions) do
    current_state = Map.get(struct, property)

    case find_legal_transition(transitions, current_state) do
      {_, target} -> {:ok, Map.put(struct, property, target)}
      nil         -> :error
    end
  end

  def can_handle_event?(struct, property, transitions) do
    current_state = Map.get(struct, property)

    case find_legal_transition(transitions, current_state) do
      {_, target} -> true
      nil         -> false
    end
  end

  def handle_event!(struct, property, transitions) do
    case handle_event(struct, property, transitions) do
      {:ok, struct} -> struct
      :error        -> raise StateFair.InvalidTransitionError
    end
  end

  defp find_legal_transition(transitions, target) do
    transitions
    |> Enum.reverse
    |> Enum.find fn {state, _} -> state == target end
  end
end
