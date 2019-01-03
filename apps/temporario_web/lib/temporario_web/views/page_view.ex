defmodule TemporarioWeb.PageView do
  use TemporarioWeb, :view

  def title(:faq, _assigns), do: "Frequently Asked Questions"

  def metadesc(:faq, _assigns) do
    """
    Client-side encrypted pastebin FAQ page: How does it work ? How secure is it ?
    Is it open source ? What are the features ? and more...
    """
  end

end
