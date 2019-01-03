# Since configuration is shared in umbrella projects, this file
# should only configure the :temporario application itself
# and only for organization purposes. All other config goes to
# the umbrella root.
use Mix.Config

# config :temporario,
#   ecto_repos: [Temporario.Repo]

config :temporario, :pastes,
  save_path: "/tmp/temporario/pastes"

import_config "#{Mix.env()}.exs"
