defmodule TemporarioWeb.Router do
  use TemporarioWeb, :router

    @csp "default-src 'self';
          style-src 'self' 'unsafe-inline' https://fonts.googleapis.com;
          connect-src 'self';
          img-src 'self';
          font-src 'self' https://fonts.googleapis.com https://fonts.gstatic.com;
          script-src 'self' 'unsafe-inline' 'unsafe-eval';
          frame-src 'self';
          form-action 'self';
         "
         |> String.replace("\n", "")
         |> String.replace(~r/ +/, " ")

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers, %{"content-security-policy" => @csp}
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", TemporarioWeb do
    pipe_through :browser

    get "/", PageController, :index
    get "/faq", PageController, :faq

    resources "/pastes", PasteController, except: [:index, :edit, :update, :delete], param: "guid"
  end

#   Other scopes may use custom stacks.
  scope "/api/v1", TemporarioWeb do
    pipe_through :api

    resources "/pastes", PasteAPIController, only: [:create, :show], param: "guid"
  end
end
