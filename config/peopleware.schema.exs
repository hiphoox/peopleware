[
  mappings: [
    "peopleware.Elixir.Peopleware.Endpoint.url.host": [
      doc: "Provide documentation for peopleware.Elixir.Peopleware.Endpoint.url.host here.",
      to: "peopleware.Elixir.Peopleware.Endpoint.url.host",
      datatype: :binary,
      default: "localhost"
    ],
    "peopleware.Elixir.Peopleware.Endpoint.secret_key_base": [
      doc: "Provide documentation for peopleware.Elixir.Peopleware.Endpoint.secret_key_base here.",
      to: "peopleware.Elixir.Peopleware.Endpoint.secret_key_base",
      datatype: :binary,
      default: "vz1ZmGLvNkurxEjFugID71Ejs0DPFyRfV3azXsPBSoDUsgbqF+/MTEgQCjwP1/yG"
    ],
    "peopleware.Elixir.Peopleware.Endpoint.debug_errors": [
      doc: "Provide documentation for peopleware.Elixir.Peopleware.Endpoint.debug_errors here.",
      to: "peopleware.Elixir.Peopleware.Endpoint.debug_errors",
      datatype: :atom,
      default: false
    ],
    "peopleware.Elixir.Peopleware.Endpoint.pubsub.name": [
      doc: "Provide documentation for peopleware.Elixir.Peopleware.Endpoint.pubsub.name here.",
      to: "peopleware.Elixir.Peopleware.Endpoint.pubsub.name",
      datatype: :atom,
      default: Peopleware.PubSub
    ],
    "peopleware.Elixir.Peopleware.Endpoint.pubsub.adapter": [
      doc: "Provide documentation for peopleware.Elixir.Peopleware.Endpoint.pubsub.adapter here.",
      to: "peopleware.Elixir.Peopleware.Endpoint.pubsub.adapter",
      datatype: :atom,
      default: Phoenix.PubSub.PG2
    ],
    "peopleware.Elixir.Peopleware.Endpoint.http.port": [
      doc: "Provide documentation for peopleware.Elixir.Peopleware.Endpoint.http.port here.",
      to: "peopleware.Elixir.Peopleware.Endpoint.http.port",
      datatype: :binary,
      default: 4000
    ],
    "peopleware.Elixir.Peopleware.Endpoint.server": [
      doc: "Provide documentation for peopleware.Elixir.Peopleware.Endpoint.server here.",
      to: "peopleware.Elixir.Peopleware.Endpoint.server",
      datatype: :atom,
      default: true
    ],
    "peopleware.Elixir.Peopleware.Repo.adapter": [
      doc: "Provide documentation for peopleware.Elixir.Peopleware.Repo.adapter here.",
      to: "peopleware.Elixir.Peopleware.Repo.adapter",
      datatype: :atom,
      default: Ecto.Adapters.Postgres
    ],
    "peopleware.Elixir.Peopleware.Repo.username": [
      doc: "Provide documentation for peopleware.Elixir.Peopleware.Repo.username here.",
      to: "peopleware.Elixir.Peopleware.Repo.username",
      datatype: :binary,
      default: "hiphoox"
    ],
    "peopleware.Elixir.Peopleware.Repo.password": [
      doc: "Provide documentation for peopleware.Elixir.Peopleware.Repo.password here.",
      to: "peopleware.Elixir.Peopleware.Repo.password",
      datatype: :binary,
      default: ""
    ],
    "peopleware.Elixir.Peopleware.Repo.database": [
      doc: "Provide documentation for peopleware.Elixir.Peopleware.Repo.database here.",
      to: "peopleware.Elixir.Peopleware.Repo.database",
      datatype: :binary,
      default: "peopleware"
    ],
    "logger.console.format": [
      doc: "Provide documentation for logger.console.format here.",
      to: "logger.console.format",
      datatype: :binary,
      default: """
      $time $metadata[$level] $message
      """
    ],
    "logger.console.metadata": [
      doc: "Provide documentation for logger.console.metadata here.",
      to: "logger.console.metadata",
      datatype: [
        list: :atom
      ],
      default: [
        :request_id
      ]
    ],
    "logger.level": [
      doc: "Provide documentation for logger.level here.",
      to: "logger.level",
      datatype: :atom,
      default: :info
    ]
  ],
  translations: [
  ]
]