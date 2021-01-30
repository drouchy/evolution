defmodule Evolution.Genetic.Reporters.PubSubReporter do
  @behaviour Evolution.Genetic.Reporter

  require Logger
  alias Phoenix.PubSub

  @impl true
  def init(_settings), do: :ok

  @impl true
  def new_generation(population, _settings) do
    PubSub.broadcast :evolution, "population:#{population.id}", {:new_generation, population}
  end

  @impl true
  def new_champion(population, _settings) do
    PubSub.broadcast :evolution, "population:#{population.id}", {:new_champion, population}
  end

  @impl true
  def solution_found(population, _settings) do
    PubSub.broadcast :evolution, "population:#{population.id}", {:solution_found, population}
  end

  def subscribe(population) do
    Logger.debug fn -> "Subscribing to events for population #{population.id}" end
    PubSub.subscribe :evolution, "population:#{population.id}"
  end

  def unsubscribe(population) do
    Logger.debug fn -> "Unsbscribing to events for population #{population.id}" end
    PubSub.unsubscribe :evolution, "population:#{population.id}"
  end
end
