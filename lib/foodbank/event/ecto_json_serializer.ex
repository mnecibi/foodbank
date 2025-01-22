defmodule Foodbank.Event.EctoJsonSerializer do
  @moduledoc """
  Serialize to/from PostgreSQL's native `jsonb` format.
  """
  @behaviour EventStore.Serializer

  require Logger

  # event
  def serialize(%_{} = term), do: to_json(term)
  # metadata
  def serialize(%{} = term), do: to_json(term)

  def deserialize(json_map, config) when is_map(json_map) do
    case Keyword.get(config, :type) do
      # metadata
      nil ->
        json_map

      # event
      type ->
        try do
          jason_map_with_version = Map.put_new(json_map, "version", 0)

          event_type =
            String.to_existing_atom(type)
            |> Code.ensure_loaded!()

          transformed_map =
            event_type.upcast(jason_map_with_version, jason_map_with_version["version"])

          event_type.decode(transformed_map)
        rescue
          err ->
            Logger.info(
              "Cannot unmarshal type #{type} fall back to generic representation. Error: #{inspect(err)}"
            )

            %{event: json_map, config: config}
        end
    end
  end

  # === serialize
  defp to_json(%Time{} = data), do: Time.to_iso8601(data)
  defp to_json(%Date{} = data), do: Date.to_iso8601(data)
  defp to_json(%DateTime{} = data), do: DateTime.to_iso8601(data)
  defp to_json(%NaiveDateTime{} = data), do: NaiveDateTime.to_iso8601(data)
  defp to_json(%URI{} = data), do: URI.to_string(data)
  defp to_json(%Decimal{} = data), do: Decimal.to_string(data, :normal)

  defp to_json(%_{} = data) do
    Map.from_struct(data)
    |> to_json()
  end

  defp to_json(%{} = data) do
    data
    |> Enum.map(fn {k, v} -> {"#{k}", to_json(v)} end)
    |> Map.new()
  end

  defp to_json(data) when is_list(data) do
    Enum.map(data, fn v -> to_json(v) end)
  end

  defp to_json(nil), do: nil
  defp to_json(data) when is_boolean(data), do: data
  defp to_json(data) when is_atom(data), do: Atom.to_string(data)
  defp to_json(data), do: data
end
