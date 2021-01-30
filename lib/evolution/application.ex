defmodule Evolution.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Evolution.Repo,
      # Start the Telemetry supervisor
      EvolutionWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: :evolution},
      # Start the Endpoint (http/https)
      EvolutionWeb.Endpoint
      # Start a worker by calling: Evolution.Worker.start_link(arg)
      # {Evolution.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Evolution.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    EvolutionWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
