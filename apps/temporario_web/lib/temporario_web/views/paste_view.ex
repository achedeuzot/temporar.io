defmodule TemporarioWeb.PasteView do
  use TemporarioWeb, :view

  def title(:new, _assigns), do: "New Secure Paste"

  def metadesc(:new, _assigns) do
    """
    Paste something into this secure client-side encrypted pastebin.
    """
  end

  def title(:show, _assigns), do: "Displaying secure paste..."

  def metadesc(:show, _assigns) do
    """
    Displaying a secure paste content.
    """
  end

end
