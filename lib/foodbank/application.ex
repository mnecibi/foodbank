defmodule Foodbank.Application do
  use Application

  @impl true
  def start(_type, args) do
    Foodbank.Supervisor.start_link(args)
  end
end
