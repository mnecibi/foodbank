defmodule Foodbank.Event.EctoJsonSerializer.Decoder do
  @moduledoc """
  The Decoder is responsible to fully decode an event raw map, after is was read from the eventstore.

  ```
  defmodule MyEventHappened do
    use #{__MODULE__}
  end
  ```

  This will add a default implementation, that decodes the event Root struct without knowlage of internal types.
  """

  alias __MODULE__

  @callback decode(map()) :: struct()

  defmacro __using__(_opts \\ []) do
    quote do
      @behaviour unquote(Decoder)
      import unquote(Decoder)

      @impl unquote(Decoder)
      @spec decode(map()) :: %__MODULE__{}
      def decode(raw_data_map) do
        decode_struct(__MODULE__, raw_data_map)
      end

      defoverridable unquote(Decoder)
    end
  end

  def decode_date(nil), do: nil

  def decode_date(date_str) do
    case Date.from_iso8601(date_str) do
      {:ok, %Date{} = date} -> date
      _ -> nil
    end
  end

  def decode_datetime(nil), do: nil

  def decode_datetime(datetime_str) do
    case DateTime.from_iso8601(datetime_str) do
      {:ok, %DateTime{} = datetime, _rest} -> datetime
      _ -> nil
    end
  end

  def decode_time(nil), do: nil

  def decode_time(time_str) do
    case Time.from_iso8601(time_str) do
      {:ok, %Time{} = time} -> time
      _ -> nil
    end
  end

  def decode_atom(nil), do: nil
  def decode_atom(atom_str), do: String.to_existing_atom(atom_str)

  def decode_struct(module, data) do
    Code.ensure_loaded!(module)
    struct(module, to_atom_keys(data))
  end

  def to_atom_keys(json) when is_map(json) do
    Enum.map(json, fn {k, v} -> {to_atom_key(k), v} end)
    |> Map.new()
  end

  defp to_atom_key(key) when is_atom(key), do: key
  defp to_atom_key(key) when is_binary(key), do: String.to_existing_atom(key)
end
