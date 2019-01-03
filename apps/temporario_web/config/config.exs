# Since configuration is shared in umbrella projects, this file
# should only configure the :temporario_web application itself
# and only for organization purposes. All other config goes to
# the umbrella root.
use Mix.Config

# General application configuration
config :temporario_web,
  ecto_repos: [Temporario.Repo],
  generators: [context_app: :temporario]

# Configures the endpoint
config :temporario_web, TemporarioWeb.Endpoint,
  render_errors: [view: TemporarioWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: TemporarioWeb.PubSub, adapter: Phoenix.PubSub.PG2]

remote_database = "https://raw.githubusercontent.com/matomo-org/device-detector/master/regexes"
remote_shortcode = "https://raw.githubusercontent.com/matomo-org/device-detector/master"

config :ua_inspector,
  init: {TemporarioWeb.UAInspectorInit, :init_ua_inspector},
  remote_path: [
    bot: "#{remote_database}",
    browser_engine: "#{remote_database}/client",
    client: "#{remote_database}/client",
    device: "#{remote_database}/device",
    os: "#{remote_database}",
    short_code_map: "#{remote_shortcode}",
    vendor_fragment: "#{remote_database}"
  ],
  skip_download_readme: true

config :phoenix, :format_encoders,
  json: Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
