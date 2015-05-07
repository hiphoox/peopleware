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
    "peopleware.Elixir.Peopleware.Endpoint.root": [
      doc: "Provide documentation for peopleware.Elixir.Peopleware.Endpoint.root here.",
      to: "peopleware.Elixir.Peopleware.Endpoint.root",
      datatype: :binary,
      default: "/Users/hiphoox/Development/Elixir/recluIT/peopleware"
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
      default: nil
    ],
    "peopleware.Elixir.Peopleware.Endpoint.cache_static_manifest": [
      doc: "Provide documentation for peopleware.Elixir.Peopleware.Endpoint.cache_static_manifest here.",
      to: "peopleware.Elixir.Peopleware.Endpoint.cache_static_manifest",
      datatype: :binary,
      default: "priv/static/manifest.json"
    ],
    "peopleware.Elixir.Peopleware.Endpoint.server": [
      doc: "Provide documentation for peopleware.Elixir.Peopleware.Endpoint.server here.",
      to: "peopleware.Elixir.Peopleware.Endpoint.server",
      datatype: :atom,
      default: true
    ],
    "peopleware.mailgun_domain": [
      doc: "Provide documentation for peopleware.mailgun_domain here.",
      to: "peopleware.mailgun_domain",
      datatype: :binary,
      default: "sandbox859abcbc300b41bcbec5af10244cb0fe.mailgun.org"
    ],
    "peopleware.mailgun_key": [
      doc: "Provide documentation for peopleware.mailgun_key here.",
      to: "peopleware.mailgun_key",
      datatype: :binary,
      default: "key-f15925d915ebe1ce03b081e6fffe1c10"
    ],
    "peopleware.confirm_url": [
      doc: "Provide documentation for peopleware.confirm_url here.",
      to: "peopleware.confirm_url",
      datatype: :binary,
      default: "http://localhost:4000/confirm/"
    ],
    "peopleware.reset_pass_url": [
      doc: "Provide documentation for peopleware.reset_pass_url here.",
      to: "peopleware.reset_pass_url",
      datatype: :binary,
      default: "http://localhost:4000/confirm_reset/"
    ],
    "peopleware.test_file_path": [
      doc: "Provide documentation for peopleware.test_file_path here.",
      to: "peopleware.test_file_path",
      datatype: :binary,
      default: "/tmp/mailgun.json"
    ],
    "peopleware.email_sender": [
      doc: "Provide documentation for peopleware.email_sender here.",
      to: "peopleware.email_sender",
      datatype: :binary,
      default: "contacto@recluit.com"
    ],
    "peopleware.welcome_email_subject": [
      doc: "Provide documentation for peopleware.welcome_email_subject here.",
      to: "peopleware.welcome_email_subject",
      datatype: :binary,
      default: "Hola "
    ],
    "peopleware.welcome_email_body": [
      doc: "Provide documentation for peopleware.welcome_email_body here.",
      to: "peopleware.welcome_email_body",
      datatype: :binary,
      default: "/Users/hiphoox/Development/Elixir/recluIT/peopleware/priv/static/welcome_email_body.html.eex"
    ],
    "peopleware.change_pass_email_body": [
      doc: "Provide documentation for peopleware.change_pass_email_body here.",
      to: "peopleware.change_pass_email_body",
      datatype: :binary,
      default: "/Users/hiphoox/Development/Elixir/recluIT/peopleware/priv/static/change_pass_email_body.html.eex"
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
      default: "norber0"
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