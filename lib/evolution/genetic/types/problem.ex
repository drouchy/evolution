defmodule Evolution.Genetic.Problem do
  alias Evolution.Genetic.Chromosome

  @callback genotype(Map.t) :: Chromosome.t

  @callback fitness(Chromosome.t, Map.t) :: number()

  @callback terminate?(Chromosome.t, integer(), Map.t) :: boolean()
end
