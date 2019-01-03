defmodule UAPreviewBlocker do
  defmodule UABlocked do
    @moduledoc """
    Exception raised when bad UA for preview tries to access paste
    """
    defexception plug_status: 400, message: "invalid user agent", conn: nil, router: nil

    defimpl Plug.Exception, for: UABlocked do
      def status(_exception), do: 400
    end
  end

  def block_ua_previews(conn, _opts \\ []) do
    headers = Enum.into conn.req_headers, %{}
    ua = headers["user-agent"]

    IO.inspect(UAInspector.parse(ua))
    case UAInspector.bot?(ua) do
      true -> raise UAPreviewBlocker.UABlocked
      _ -> conn
    end
  end

end
