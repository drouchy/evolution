defmodule Evolution.Genetic.Reporter do
  @callback init(options :: Keyword.t()) :: {:ok, map()}
  @callback new_generation(population :: Population.t(), options :: Keyword.t()) :: :ok
  @callback new_champion(population :: Population.t(), options :: Keyword.t()) :: :ok
  @callback solution_found(population :: Population.t(), options :: Keyword.t()) :: :ok

end
