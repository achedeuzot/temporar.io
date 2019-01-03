defmodule Temporario.Pastes do
  @moduledoc """
  The Pastes context.

  It manages `Paste`s.
  """
  alias Temporario.{Paste, PasteStorage}

  @doc """
  Gets a single paste.

  Raises `Ecto.NoResultsError` if the Paste does not exist.

  ## Examples

      iex> get_paste!(123)
      %Paste{}

      iex> get_paste!(456)
      ** (Ecto.NoResultsError)

  """
  def get_paste!(guid) do
    PasteStorage.read_from_fs(guid)
    |> Paste.load()
  end

  @doc """
  Creates a paste.

  ## Examples

      iex> create_paste(%{field: value})
      {:ok, %Paste{}}

      iex> create_paste(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_paste(attrs \\ %{}) do
    %Paste{requests: 0}
    |> Paste.changeset(attrs)
    |> Paste.save()
    |> PasteStorage.write_to_fs()
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking paste changes.

  ## Examples

      iex> change_paste(paste)
      %Ecto.Changeset{source: %Paste{}}

  """
  def change_paste(%Paste{} = paste) do
    Paste.changeset(paste, %{})
  end
end
