defmodule Mix.Tasks.UaInspectorDownload do
  use Mix.Task

  @shortdoc "Downloads UAInspector Files"
  def run(_args) do
    Application.ensure_all_started(:hackney)
    Mix.Task.run("ua_inspector.download.databases", ["--force"])
    Mix.Task.run("ua_inspector.download.short_code_maps", ["--force"])
  end
end
