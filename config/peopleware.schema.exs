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
      default: "g/z3ICJVkXVPdNyUf0wFe52NMF49WHJrNG4VyrBdmasFgd/5JYIyV1Pcq9uoxhwO"
    ],
    "peopleware.Elixir.Peopleware.Endpoint.debug_errors": [
      doc: "Provide documentation for peopleware.Elixir.Peopleware.Endpoint.debug_errors here.",
      to: "peopleware.Elixir.Peopleware.Endpoint.debug_errors",
      datatype: :atom,
      default: true
    ],
    "peopleware.Elixir.Peopleware.Endpoint.server": [
      doc: "Provide documentation for peopleware.Elixir.Peopleware.Endpoint.server here.",
      to: "peopleware.Elixir.Peopleware.Endpoint.server",
      datatype: :atom,
      default: true
    ],
    "peopleware.Elixir.Peopleware.Endpoint.http.port": [
      doc: "Provide documentation for peopleware.Elixir.Peopleware.Endpoint.http.port here.",
      to: "peopleware.Elixir.Peopleware.Endpoint.http.port",
      datatype: :integer,
      default: 4000
    ],
    "peopleware.Elixir.Peopleware.Endpoint.cache_static_lookup": [
      doc: "Provide documentation for peopleware.Elixir.Peopleware.Endpoint.cache_static_lookup here.",
      to: "peopleware.Elixir.Peopleware.Endpoint.cache_static_lookup",
      datatype: :atom,
      default: true
    ],
    "peopleware.Elixir.Peopleware.Repo.url": [
      doc: "Provide documentation for peopleware.Elixir.Peopleware.Repo.url here.",
      to: "peopleware.Elixir.Peopleware.Repo.url",
      datatype: :binary,
      default: "ecto://hiphoox:@localhost/peopleware"
    ],
    "logger.console.format": [
      doc: "Provide documentation for logger.console.format here.",
      to: "logger.console.format",
      datatype: :binary,
      default: """
      [$level] $message
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
    ]
  ],
  translations: [
  ]
]