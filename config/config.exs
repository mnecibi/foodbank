import Config

config :foodbank, ecto_repos: [Foodbank.Repo]

config :foodbank, Foodbank.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "foodbank_db",
  hostname: "localhost",
  port: 5432,
  pool_size: 10

config :foodbank, Foodbank.Commanded,
  event_store: [
    adapter: Commanded.EventStore.Adapters.EventStore,
    event_store: Foodbank.EventStore
  ],
  pubsub: :local,
  registry: :local

eventstore_config = [
  serializer: Foodbank.Event.EctoJsonSerializer,
  column_data_type: "jsonb",
  types: EventStore.PostgresTypes,
  shared_connection_pool: :shared_eventstore_pool,
  username: "postgres",
  password: "postgres",
  database: "foodbank_eventstore",
  hostname: "localhost",
  port: 5432
]

config :foodbank, Foodbank.EventStore, eventstore_config

config :foodbank, event_stores: [Foodbank.EventStore]
