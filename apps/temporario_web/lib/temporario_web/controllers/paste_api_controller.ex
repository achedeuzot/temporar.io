defmodule TemporarioWeb.PasteAPIController do
  use TemporarioWeb, :controller

  alias Temporario.Pastes

  defp render_detail({message, values}) do
    Enum.reduce values, message, fn {k, v}, acc ->
      String.replace(acc, "%{#{k}}", to_string(v))
    end
  end

  def create(conn, %{"paste" => paste_params}) do
    case Pastes.create_paste(paste_params) do
      {:ok, paste} ->
        conn
        |> put_status(:created)
        |> json(%{paste: paste.guid})
      {:error, %Ecto.Changeset{} = changeset} ->
        errors = Enum.map(changeset.errors, fn {field, detail} ->
          %{
            field: "#{field}",
            detail: render_detail(detail)
          }
        end)
        conn
        |> put_status(:bad_request)
        |> json(%{errors: errors})
    end
  end

  def create(conn, _params) do
    conn
    |> put_status(:bad_request)
    |> json(%{errors: %{field: "paste", detail: "missing paste item"}})
  end

  def show(conn, %{"guid" => guid}) do
    paste = Pastes.get_paste!(guid)
    json conn, %{paste: paste}
  end

end
