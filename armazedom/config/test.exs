import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :armazedom, ArmazedomWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "E3TrDs69Yj7US2f2jerIzbh7z9ObWliH2pN/DrBC13+aQM3lQ57JqDkknxPHKcLy",
  server: false

# In test we don't send emails
config :armazedom, Armazedom.Mailer, adapter: Swoosh.Adapters.Test

# Disable swoosh api client as it is only required for production adapters
config :swoosh, :api_client, false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime

# Enable helpful, but potentially expensive runtime checks
config :phoenix_live_view,
  enable_expensive_runtime_checks: true
