import Config

config :pleroma, :instance,
  registrations_open: false,
  federating: true,
  federation_incoming_replies_max_depth: 10

config :pleroma, :shout,
  enabled: false

config :pleroma, :frontend_configurations,
  pleroma_fe: %{
    background: "/static/background.jpg",
    logo: "/static/logo.png"
  }
