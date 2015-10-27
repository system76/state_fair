defmodule StateFair.InvalidTransitionError do
  @moduledoc """
  Raised at runtime when a bang method of an event is attempted and no legal
  transition can be found.
  """
  defexception [:message]
end
