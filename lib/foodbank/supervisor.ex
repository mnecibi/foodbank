defmodule Foodbank.Supervisor do
  use Supervisor

  def start_link(args) do
    Supervisor.start_link(__MODULE__, args)
  end

  @impl true
  def init(_args) do
    children = [
      Foodbank.Repo,
      Foodbank.Commanded
    ]

    opts = [strategy: :one_for_one]

    Supervisor.init(children, opts)
  end
end
