defmodule Foodbank.Event.EctoJsonSerializer.Upcaster do
  @moduledoc """
  The Upcaster is responsible to transform events from an older version to its newest form.

  ```
  defmodule MyEventHappened do
    use DB.Event.EctoJsonSerializer.Upcaster
  end
  ```

  This will add a default implementation, that just outputs an untransfomed event.
  """

  alias __MODULE__

  @callback upcast(map(), non_neg_integer()) :: map()

  defmacro __using__(_opts \\ []) do
    quote do
      @behaviour unquote(Upcaster)
      import unquote(Upcaster)

      @impl unquote(Upcaster)
      @spec upcast(old_map :: map(), version :: non_neg_integer()) :: map()
      def upcast(old_map, _version), do: old_map
      defoverridable unquote(Upcaster)

      def upcast_next(%{"version" => v} = data), do: upcast(data, v)
    end
  end

  @doc """
  Increase the version in the raw data by a certain amount

  ## options

  * by: the amount to increase the version by. Defaults to 1
  """
  @spec increase_version(map(), [] | [{:by, integer()}]) :: map()
  def increase_version(raw_data, opts \\ []) do
    by = opts[:by] || 1
    Map.update!(raw_data, "version", fn v -> v + by end)
  end
end
