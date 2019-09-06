use Mix.Config

# Configure your database
config :api, API.Repo,
  username: "djv",
  password: "postgres",
  database: "puppy_party_test",
  hostname: "localhost",
  port: 5431,
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :api, APIWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Don’t add this configuration option to config/dev.exs or config/prod.exs!
# This is only used during testing to speed up the process by decreasing security settings in this environment.
config :bcrypt_elixir, :log_rounds, 4
