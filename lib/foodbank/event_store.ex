defmodule Foodbank.EventStore do
  use EventStore, otp_app: :foodbank

  def init(config) do
    {:ok, config}
  end
end
