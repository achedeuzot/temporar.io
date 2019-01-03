defmodule TemporarioWeb.PageController do
  use TemporarioWeb, :controller

  def index(conn, _params) do
    conn |> redirect(to: Routes.paste_path(conn, :new))
  end

  def faq(conn, _params) do
    render conn, "faq.html"
  end

end
