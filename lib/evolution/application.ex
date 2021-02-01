defmodule Evolution.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      Evolution.Repo,
      EvolutionWeb.Telemetry,
      {Phoenix.PubSub, name: Evolution.PubSub},
      EvolutionWeb.Endpoint,
      {Task.Supervisor, name: Evolution.Genetic.TaskSupervisor}
    ]

    opts = [strategy: :one_for_one, name: Evolution.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def config_change(changed, _new, removed) do
    EvolutionWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
