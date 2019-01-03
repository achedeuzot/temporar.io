defmodule TemporarioWeb.PasteController do
  use TemporarioWeb, :controller
  import UAPreviewBlocker

  alias Temporario.Pastes
  alias Temporario.Paste

  plug :block_ua_previews when action in [:show]

  def new(conn, _params) do
    changeset = Pastes.change_paste(%Paste{})
    render(conn, "new.html",
      changeset: changeset,
      expiration_choices: Paste.expiration_choices,
      default_expiration_choice: Paste.default_expiration_choice)
  end

  def create(conn, %{"paste" => paste_params}) do
    case Pastes.create_paste(paste_params) do
      {:ok, paste} ->
        conn
        |> put_flash(:info, "Paste created successfully.")
        |> redirect(to: Routes.paste_path(conn, :show, paste))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html",
          changeset: changeset,
          expiration_choices: Paste.expiration_choices,
          default_expiration_choice: Paste.default_expiration_choice)
    end
  end

  def show(conn, %{"guid" => guid}) do
    paste = Pastes.get_paste!(guid)
    conn
    |> put_flash(:info, "Just copy the URL in the address bar of your browser to share this paste.")
    |> render("show.html", paste: paste)
  end

end
