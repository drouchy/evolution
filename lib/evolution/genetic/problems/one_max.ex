defmodule Evolution.Genetic.Problems.OneMax do
  @behaviour Evolution.Genetic.Problem

  @impl true
  def genotype(%{size: size}) do
    genes = for _ <- 1..size, do: Enum.random(0..1)
    %Evolution.Genetic.Chromosome{genes: genes, size: size, fitness: -1}
  end

  @impl true
  def fitness(chromosome, _settings), do: Enum.sum(chromosome.genes)

  @impl true
  def terminate?(fittest, _iteration, _settings), do: fittest.fitness == fittest.size
end