defmodule Temporario.PasteStorage do
  use Timex
  alias Temporario.Paste

  def write_to_fs({:error, %Ecto.Changeset{} = changeset}) do
    {:error, changeset}
  end

  def write_to_fs({:ok, %Paste{} = paste}) do
    # Use configuration to save the paste to filesystem
    paste |> get_dir |> File.mkdir_p!
    File.open!(get_path(paste), [:read, :write], fn file ->
      IO.binwrite(file, Jason.encode!(paste))
    end)
    {:ok, paste}
  end

  def read_from_fs(guid) do
    File.open!(get_path(guid), [:read], fn file ->
      IO.binread(file, :all) |> Jason.decode!() |> Paste.from_map()
    end)
  end

  def delete_from_fs(guid) do
    File.rm(get_path(guid))
  end

  defp get_dir(%Paste{} = paste) do
    get_dir(paste.guid)
  end

  defp get_dir(guid) do
    is_guid!(guid)
    Path.join([
      Application.get_env(:temporario, :pastes)[:save_path],
      String.slice(guid, 0, 2),
      String.slice(guid, 2, 2)
    ])
  end

  defp get_path(%Paste{} = paste) do
    get_path(paste.guid)
  end

  defp get_path(guid) do
    if is_guid!(guid) do
      Path.join([get_dir(guid), guid <> ".paste"])
    else
      raise Paste.InvalidGUID
    end
  end

  def is_guid!(thing) do
    if is_guid?(thing) do
      thing
    else
      raise Paste.InvalidGUID
    end
  end

  def is_guid?(thing) do
    regexp = ~r/^[0-9a-f]{8}\-[0-9a-f]{4}\-4[0-9a-f]{3}\-[89ab][0-9a-f]{3}\-[0-9a-f]{12}$/u
    if is_binary(thing) and Regex.match?(regexp, thing), do: true, else: false
  end

end
