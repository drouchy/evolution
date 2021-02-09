defmodule Evolution.Reporters.BlackHoleReporter do
  @behaviour Evolution.Genetic.Reporter
  
  @impl true
  def init(_settings), do: :ok
  
  @impl true
  def new_generation(_population, _settings), do: :ok
  
  @impl true
  def new_champion(_population, _settings), do: :ok
  
  @impl true
  def solution_found(_population, _settings), do: :ok
end