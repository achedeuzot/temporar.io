defmodule TemporarioWeb.UAInspectorInit do
  @spec init_ua_inspector() :: :ok
  def init_ua_inspector() do
    priv_dir = Application.app_dir(:temporario_web, "priv")

    Application.put_env(
      :ua_inspector,
      :database_path,
      Path.join([priv_dir, "data", "ua_inspector", "matomo"])
    )

    try do
      UAInspector.Downloader.download()
    catch
      x -> IO.puts("Could not update the UAInspector User Agent Database. Error: #{x}")
    end

    UAInspector.reload()
  end
end

require Protocol
Protocol.derive(Jason.Encoder, UAInspector.Result, [])
Protocol.derive(Jason.Encoder, UAInspector.Result.Bot, [])
Protocol.derive(Jason.Encoder, UAInspector.Result.BotProducer, [])
Protocol.derive(Jason.Encoder, UAInspector.Result.Client, [])
Protocol.derive(Jason.Encoder, UAInspector.Result.OS, [])
Protocol.derive(Jason.Encoder, UAInspector.Result.Device, [])
