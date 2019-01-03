defmodule Temporario.Paste do
  use Timex
  use Ecto.Schema
  import Ecto.Changeset

  alias Temporario.{Paste, PasteStorage}

  @primary_key {:guid, Ecto.UUID, []}
  @derive {Phoenix.Param, key: :guid}
  @derive {Jason.Encoder, except: [:__meta__]}
  schema "pastes" do
    field :payload, :string
    field :expiration, :utc_datetime
    field :destroy_on_reading, :boolean
    field :requests, :integer

    field :created_at, :utc_datetime
  end

  @default_expiration "1-minute"
  @expiration_presets [
    "Immediately": "1-second",
    "After a minute": "1-minute",
    "After an hour": "1-hour",
    "After a day": "1-day",
    "After a week": "1-week",
    "After a month": "1-month",
    "After a year": "1-year",
    "Never": "never",
  ]

  @max_payload_chars 52_428_800 # (50MB)

  @expiration_presets_to_timeshift %{
    "1-second" => [seconds: 1],
    "1-minute" => [minutes: 1],
    "1-hour" => [hours: 1],
    "1-day" => [days: 1],
    "1-week" => [weeks: 1],
    "1-month" => [months: 1],
    "1-year" => [years: 1],
    "never" => [years: 1999],
  }

  def expiration_choices, do: @expiration_presets
  def default_expiration_choice, do: @default_expiration

  @doc false
  def changeset(%Paste{} = paste, attrs \\ %{}) do
    # Convert form raw expiration to datetime
    attrs = convert_expiration_to_offset(attrs, "expiration")

    paste
    |> cast(attrs, [:payload, :expiration, :destroy_on_reading])
    |> validate_required([:payload, :expiration])
    |> validate_length(:payload, min: 2, max: @max_payload_chars)
    |> validate_datetime_in_future(:expiration)
    |> change(%{guid: UUID.uuid4()})
    |> change(%{created_at: DateTime.utc_now()})
  end

  def from_map(%{} = raw_paste) do
    {:ok, dt_expiration, 0} = DateTime.from_iso8601(raw_paste["expiration"])
    {:ok, dt_created_at, 0} = DateTime.from_iso8601(raw_paste["created_at"])

    %Paste{
      guid: raw_paste["guid"],
      payload: raw_paste["payload"],
      expiration: dt_expiration,
      destroy_on_reading: raw_paste["destroy_on_reading"],
      requests: raw_paste["requests"],

      created_at: dt_created_at,
    }
  end

  def increment_requests(%Paste{} = paste) do
    %{paste | requests: paste.requests + 1}
  end

  def save(%Ecto.Changeset{} = changeset) do
    if changeset.valid? do
      {:ok, Ecto.Changeset.apply_changes(changeset)}
    else
      {:error, %{changeset | action: :check_errors}} # action is set, trigger the form errors
    end
  end

  def load(%Paste{} = paste) do
    if valid?(paste) do
      newpaste = increment_requests(paste)
      if newpaste.destroy_on_reading and newpaste.requests >= 2 do
        PasteStorage.delete_from_fs(newpaste.guid)
      else
        PasteStorage.write_to_fs({:ok, newpaste})
      end
      newpaste
    else
      PasteStorage.delete_from_fs(paste.guid)
      raise Temporario.Paste.InvalidGUID
    end
  end

  defp valid?(%Paste{} = paste) do
    case DateTime.compare(paste.expiration, Timex.now) do
      :lt -> false
      _ -> true
    end
  end

  defp convert_expiration_to_offset(attrs, field) do
    expiration_raw_value = Map.get(attrs, field, @default_expiration)
    timeshift = Map.get(@expiration_presets_to_timeshift,
      expiration_raw_value,
      @expiration_presets_to_timeshift[@default_expiration])
    Map.put(attrs, field, Timex.shift(DateTime.utc_now(), timeshift))
  end

  defp validate_datetime_in_future(%Ecto.Changeset{} = changeset, field, options \\ []) do
    validate_change(changeset, field, fn field, datetime ->
       case DateTime.compare(datetime, DateTime.utc_now()) do
         :lt -> [{field, options[:message] || "must be set sometime in the future"}]
         _ -> []
       end
    end)
  end

end

defmodule Temporario.Paste.InvalidGUID do
  defexception message: "Invalid Paste GUID"
end

defimpl Plug.Exception, for: File.Error do
  def status(_exception), do: 404
end

defimpl Plug.Exception, for: Temporario.Pastes.Paste.InvalidGUID do
  def status(_exception), do: 404
end
