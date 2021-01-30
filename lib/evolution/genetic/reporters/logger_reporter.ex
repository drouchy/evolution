defmodule Evolution.Genetic.Reporters.LoggerReporter do
  @behaviour Evolution.Genetic.Reporter
  
  require Logger
  
  @impl true
  def init(_settings), do: :ok
  
  @impl true
  def new_generation(population, _settings) do
    Logger.debug fn -> "#{format_generation(population.generation)} - Population: #{population.size} - champion: #{champion_fitness(population)}" end
  end
  
  @impl true
  def new_champion(population, _settings) do
    Logger.info fn -> "#{format_generation(population.generation)} - Population: #{population.size} - champion: #{champion_fitness(population)}" end
  end
  
  @impl true
  def solution_found(population, _settings) do
    Logger.info fn -> "#{format_generation(population.generation)} - Solution found: #{population.champion.genes}" end
  end
  
  defp format_generation(value) do
    value
    |> Integer.to_string(10)
    |> String.pad_leading(6, "0")
  end
  
  defp champion_fitness(%{champion: nil}), do: "none"
  defp champion_fitness(%{champion: champion}), do: champion.fitness
end